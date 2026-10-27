#!/bin/sh
# The chain gate (slice K4c, O-s11-1). For each call script below, deploy the
# program with `evm run --create`, then do one `evm run --prestate --dump`
# step for each call of the script. After each step, the storage must equal
# the state that `langc run` prints for the calls up to that step, and the
# result must agree with the result of the call: ok, revert (`none`) or trap
# (the Trap() selector). A view call must return the 32-byte word of the view
# value (slice K4c, C-K4-10). The logs of the step (`evm run --debug`) must
# equal the events that `langc run` prints for the call: one LOG1 for each
# event, in order (slice K4c, C-K4-13). The TIMESTAMP of the block is NOW (the
# prestate timestamp) and the sender is CALLER. It needs evm (go-ethereum), bc, od and build/slottool.
# Run it from the kit root.
set -u
fail=0
steps=0
tmp=${TMPDIR:-/tmp}/langc-evm.$$
mkdir -p "$tmp"
. test/evmchain.sh

# wantlogs PROG K: one line for each event that `langc run` prints for call K
# (tmp/run): topic 0 (from the `langc abi` event line, C-K4-16) and the data
# words. test/abi.expect holds the cast check of the topics. When alloc is set
# (the mock token), each pay line of call K gives the line of the Transfer LOG3
# of the mock (test/diff.sh lg, S7 s2 O139).
wantlogs() {
  : >"$tmp/wantlogs"
  build/langc --kit abi "$1" --text >"$tmp/abi" || : >"$tmp/abi"
  awk -v k="$2" -v m="${alloc:+1}" '/^[^ ]/ { p = ($1 == k); next } p && ($1 == "event" || (m && $1 == "pay"))' "$tmp/run" >"$tmp/events"
  while read -r _ev _evname _evargs; do
    if [ "$_ev" = pay ]; then
      _to=$(echo "${_evargs%% *}" | cut -c3- | tr A-F a-f)
      echo "$transfer,$(pad "$receiver"),$(pad "$_to") $(pad "$(word "${_evargs#* }")")" >>"$tmp/wantlogs"
      continue
    fi
    _topic=$(awk -v n="$_evname" '$3 == "event" && index($2, n "(") == 1 { print substr($1, 3) }' "$tmp/abi")
    _data=
    for _a in $_evargs; do _data=$_data$(pad "$(word "$_a")"); done
    echo "$_topic ${_data:--}" >>"$tmp/wantlogs"
  done <"$tmp/events"
}

# chain PROG SCRIPT: deploy PROG, then one step for each call of SCRIPT.
chain() {
  _prog=$1 _script=$2
  if ! deploy "$_prog"; then
    echo "FAIL evm $_prog: deploy: $(head -n 1 "$tmp/dump")"
    fail=$((fail + 1))
    return
  fi
  awk 'NF && $1 != "--"' "$_script" >"$tmp/calls"
  _calls=$(awk 'END { print NR }' "$tmp/calls")
  _k=0
  while [ "$_k" -lt "$_calls" ]; do
    _k=$((_k + 1))
    awk -v k="$_k" 'NR <= k' "$tmp/calls" >"$tmp/prefix"
    set -- $(awk -v k="$_k" 'NR == k' "$tmp/calls")
    _now=$1 _caller=$2 _name=$3
    shift 3
    steps=$((steps + 1))
    if ! build/langc --kit run "$_prog" "$tmp/prefix" >"$tmp/run" 2>"$tmp/err"; then
      echo "FAIL evm $_script:$_k: langc run: $(head -n 1 "$tmp/err")"
      fail=$((fail + 1))
      return
    fi
    _value=$(awk -v k="$_k" '$1 == k { print $4 }' "$tmp/run")
    case $(awk -v k="$_k" '$1 == k { print $3 }' "$tmp/run") in
      ok) _want=ok ;;
      revert) _want=revert ;;
      trap) _want=trap ;;
      =) _want="out $(word "$_value")" ;;
      *) _want=unknown ;;
    esac
    want "$(awk '$1 == "state" { sub(/^state /, ""); print }' "$tmp/run")"
    _input=$(input "$_prog" "$_name" "$@")
    if ! step "$_now" "$_caller" "$_input"; then
      echo "FAIL evm $_script:$_k $_name: evm: $(head -n 1 "$tmp/dump")"
      fail=$((fail + 1))
      return
    fi
    # A set alloc (the mock token, S7 s2 O139): step puts the storage of all
    # accounts in tmp/raw. Keep only the storage of the receiver (test/diff.sh acct).
    if [ -n "${alloc:-}" ]; then
      awk -F'"' -v a="0x$receiver" 'NF == 3 && length($2) == 42 { p = (tolower($2) == a); next }
        p && NF >= 5 && length($2) == 66 && substr($2, 1, 2) == "0x" { print substr($2, 3), $4 }' "$tmp/dump" >"$tmp/raw"
      awk '{ v = tolower($2); sub(/^0+/, "", v); print $1, (v == "" ? "0" : v) }' "$tmp/raw" | sort >"$tmp/got"
    fi
    case $result in
      "out "*) _hex=${result#out }
        [ ${#_hex} -eq 64 ] && result="out $(hexnorm "$_hex")" ;;
    esac
    if [ "$result" != "$_want" ] || ! cmp -s "$tmp/want" "$tmp/got"; then
      echo "FAIL evm $_script:$_k $_name: want $_want, got $result"
      diff "$tmp/want" "$tmp/got" | head -n 6
      fail=$((fail + 1))
    fi
    wantlogs "$_prog" "$_k"
    if ! logs "$_caller" "$_input" || ! cmp -s "$tmp/wantlogs" "$tmp/gotlogs"; then
      echo "FAIL evm $_script:$_k $_name: logs"
      diff "$tmp/wantlogs" "$tmp/gotlogs" | head -n 6
      fail=$((fail + 1))
    fi
  done
}

# The `langc abi --text` lines (C-K4-16) of examples/contract.lang, map.lang,
# residuals.lang and events.lang and of one refused program
# (test/lower/emit.lang) equal test/abi.expect. Each selector and topic there
# equals the output of `cast sig` or `cast sig-event` (foundry cast 0.3.0, K4c s6).
# The gate does not run cast.
for _p in examples/contract.lang examples/map.lang examples/residuals.lang examples/events.lang \
  test/lower/emit.lang; do
  echo "# $_p --text"
  build/langc --kit abi "$_p" --text 2>&1
  echo "exit $?"
done >"$tmp/abi.got"
# The JSON ABI (Q-K4-3, the default since C-c7-1) of the two programs with
# events. `cast interface` reads each array (K4c s8). The gate does not run cast.
for _p in examples/contract.lang examples/events.lang; do
  echo "# $_p"
  build/langc --kit abi "$_p" 2>&1
  echo "exit $?"
done >>"$tmp/abi.got"
# A flag other than --text after the program is a USAGE error (C-c7-1, O-c14-1).
{
  echo "# examples/events.lang --json"
  build/langc --kit abi examples/events.lang --json 2>&1
  echo "exit $?"
} >>"$tmp/abi.got"
# S7 s1: a List U256 entry argument is a uint256[] (cast sig 'payList(uint256,uint256[])').
{
  echo "# examples/listarg.lang --text"
  build/langc --kit abi examples/listarg.lang --text 2>&1
  echo "exit $?"
} >>"$tmp/abi.got"
# S7 s2 (O138): the entries of examples/mandate.lang. cast sig gives the same selectors for
# 'check(uint256[])', 'execute(uint256[])' and
# 'grant(address,address,address,address,address,uint256,uint256,uint256,uint256,address,uint256,address)'.
{
  echo "# examples/mandate.lang --text"
  build/langc --kit abi examples/mandate.lang --text 2>&1
  echo "exit $?"
} >>"$tmp/abi.got"
if ! cmp -s test/abi.expect "$tmp/abi.got"; then
  echo "FAIL evm abi: the langc abi lines differ from test/abi.expect"
  diff test/abi.expect "$tmp/abi.got" | head -n 6
  fail=$((fail + 1))
fi

# basic.script runs on test/contract-nocall.lang (C-K4d-5): this test has no
# code at the token 0x..ee, thus on examples/contract.lang the CALLs of deposit
# and withdraw revert (C-K4-14), while `langc run` says ok.
chain test/contract-nocall.lang test/run/basic.script
chain examples/map.lang test/run/map.script
chain examples/residuals.lang test/run/residuals.script
chain examples/events.lang test/run/events.script
chain examples/lists.lang test/run/lists.script
# S7 s1: a List U256 entry argument. Then call data that the list prologue of payList must revert: the offset
# word 0x20 (not 32 N = 0x40), the length 257 (above the bound 256, with 257 items), and a length 3 with 2 items.
chain examples/listarg.lang test/run/listarg.script
listrevert() {
  steps=$((steps + 1))
  if ! deploy examples/listarg.lang || ! step 1 0x00000000000000000000000000000000000000bb "$(sel 'payList(uint256,uint256[])')$2"; then
    echo "FAIL evm listarg $1: evm: $(head -n 1 "$tmp/dump")"
    fail=$((fail + 1))
  elif [ "$result" != revert ]; then
    echo "FAIL evm listarg $1: want revert, got $result"
    fail=$((fail + 1))
  fi
}
listrevert offset "$(pad 1)$(pad 20)$(pad 1)$(pad 7)"
listrevert length "$(pad 0)$(pad 40)$(pad 101)$(awk 'BEGIN { for (i = 0; i < 257; i++) printf "%064d", 0 }')"
listrevert short "$(pad 1)$(pad 40)$(pad 3)$(pad 1)$(pad 2)"
# S7 s2 (O139): examples/mandate.lang. langc run signs the view sig with the chain id
# 1337 (the domain of the view sig). Thus the mandate chain uses the chain id 1337, and
# the config of the other chains stays 1. test/mandate-evm.script is
# test/run/mandate.script with the token 0x..ee in each grant: the token 0x..05 is the
# modexp precompile, and a precompile ignores alloc code. alloc puts the mock token of
# test/diff.sh (build/asmtool mock, mode 0) at 0x..ee, thus execute pays the mock.
# S9 s3 (O176): alloc also puts the mock verifier (build/asmtool verifier) at 0x..ef,
# the policy verifier of the grant rows of O176.
build/asmtool mock >"$tmp/mock" || { echo "FAIL evm mandate: asmtool mock"; exit 1; }
build/asmtool verifier >"$tmp/ver" || { echo "FAIL evm mandate: asmtool verifier"; exit 1; }
transfer=$(keccak "$(printf '%s' 'Transfer(address,address,uint256)' | od -v -An -tx1 | tr -d ' \n')")
_config=$config
config="{\"chainId\":1337,${config#*,}"
alloc=",\"0x00000000000000000000000000000000000000ee\":{\"balance\":\"0x0\",\"code\":\"0x$(cat "$tmp/mock")\",\"storage\":{}}"
ver=00000000000000000000000000000000000000ef
alloc="$alloc,\"0x$ver\":{\"balance\":\"0x0\",\"code\":\"0x$(cat "$tmp/ver")\",\"storage\":{}}"
chain examples/mandate.lang test/mandate-evm.script
alloc=
config=$_config
# test/same-state.lang: the entry ping keeps the state and emits one LOG1 (O-d7-1).
chain test/same-state.lang test/same-state.script

rm -rf "$tmp"
echo "evm steps: $steps checked"
echo "evm gate: $fail failures"
[ "$fail" -eq 0 ]
