#!/bin/sh
# The precompile gate (slice S2, kickoff 1.5). Deploy examples/precompile.lang,
# then do one `evm run --prestate` step for each view and compare the result
# word with a constant. Each constant was confirmed at build (2026-10-15, evm
# 1.14.12) with a direct `evm run --input HEX --receiver 0x..0N` to the
# precompile address 1 (ecrecover) before it entered this file. A closed
# ecrecover computes in the host (front/secp256k1.c, test/secptool.c); an open
# ecrecover stays stuck (R17). This gate
# compares the chain result only. It needs evm (go-ethereum), bc, od and
# build/slottool. Run it from the kit root.
set -u
fail=0
steps=0
tmp=${TMPDIR:-/tmp}/langc-precompile.$$
mkdir -p "$tmp"
. test/evmchain.sh

prog=examples/precompile.lang
caller=0x00000000000000000000000000000000000000aa

# call WANT NAME ARGS...: one step of the view or entry NAME with ARGS at
# TIMESTAMP 1. The result must equal WANT: `out HEX` (HEX as hexnorm), `ok` or
# `revert`. An entry changes the storage of the next step.
call() {
  _want=$1 _name=$2
  shift 2
  steps=$((steps + 1))
  _input=$(input "$prog" "$_name" "$@")
  if ! step 1 "$caller" "$_input"; then
    echo "FAIL precompile $_name: evm: $(head -n 1 "$tmp/dump")"
    fail=$((fail + 1))
    return
  fi
  case $result in
    "out "*) _hex=${result#out }
      [ ${#_hex} -eq 64 ] && result="out $(hexnorm "$_hex")" ;;
  esac
  if [ "$result" != "$_want" ]; then
    echo "FAIL precompile $_name: want $_want, got $result"
    fail=$((fail + 1))
  fi
}

if ! deploy "$prog"; then
  echo "FAIL precompile deploy: $(head -n 1 "$tmp/dump")"
  fail=$((fail + 1))
else
  # The go-ethereum ecrecover vector (core/vm/testdata/precompiles/ecRecover.json, CallEcrecover0).
  h=0x38d18acb67d25c8bb9942764b62f18e17054f66a817bd4295423adf9ed98873eu
  sgood=0x789d1dd423d25f0772d2748d60f7e4b81bb14d086eba8e8e8efb6dcff8a4ae02u
  addr=ceaccac640adf55b2028469bd36ba501f28b699d
  call "out $addr" recover "$h" 27 "$h" "$sgood"
  # s = 0 gives an empty output: the address is 0 (R18).
  call "out 0" recover "$h" 27 "$h" 0u
  # The same ecrecover statement twice (a fold over the pushed words, the end of
  # the list first): the valid s, then s = 0. The sum is the one address (M8).
  call ok sign "$sgood"
  call ok sign 0u
  call "out $addr" recoverSum
  # signedBy: the good signature against its signer; s = 0 (the address 0,
  # confirmed with a direct `evm run` to 0x..01) against the signer 0 fails.
  call "out 1" signedBy "$h" 27 "$h" "$sgood" "0x$addr"
  call "out 0" signedBy "$h" 27 "$h" 0u 0x0000000000000000000000000000000000000000
  # keccak256 of 64 zero bytes; `langc eval examples/precompile.lang hashZero` gives the same word.
  call "out ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5" hashv 0u 0u
  # hash712 (S4, O12): WANT is keccak256 of 0x19 0x01 and the two words by a direct evm run;
  # the second pair is the domain separator and the struct hash of the EIP-712 Mail example.
  call "out b15111afa5c2b936d8dd23e1ffc4a97dd7a9af57a8144231ff70b749ab128d0" hash712v 0u 0u
  call "out be609aee343fb3c4b28e1df9e632fca64fcfaede20f02e86244efddf30957bd2" hash712v 109825249729584807872825749361878700304363337622364782618362889211463320340751u 89183475262805136231107931379173003391419088052721114540770871634179195090718u
  # hash3 and hash4 (S4, Q-S4-1): WANT is keccak256 of the 3 or 4 words by a direct evm run;
  # then the Person hash of the from of the EIP-712 Mail example and its struct hash (mailHash).
  call "out 46700b4d40ac5c35af2c22dda2787a91eb567b06c924a8fb8ae9a05b20c08c21" hash3v 0u 0u 0u
  call "out 12893657d8eb2efad4de0a91bcd0e39ad9837745dec3ea923737ea803fc8e3d" hash4v 0u 0u 0u 0u
  call "out fc71e5fa27ff56c350aa531bc129ebdf613b772b6604664f5d8dbe21b85eb0c8" hash3v 84060893143755716907112057142907579635082498512717439438809184967584834360576u 63375339889627787624264666798085252369542317214172087750695153489931332884040u 1171285107467697789631807507971492729443352172582u
  call "out c52c0ee5d84264471806290a3f2c4cecfc5490626bf912d01f240d7a274b371e" hash4v 72735563278411641485555953421960816083222647397764820742974348683926734887618u 114184078805415388839375382203310112320357356233650573881602044532163417649352u 92874208676831323554465169649579554909400319728404063916443860673617192223697u 82170530013969295004244531055885112529525266356253249484606899500364124008392u
  # chainid and self (S4, O62): the prestate config of test/evmchain.sh sets the chain id 1, and
  # the receiver is the bytes "receiver". The guest run (test/run/precompile.script) gives 1337.
  call "out 1" chainWord
  call "out 7265636569766572" selfAddr
  # leafStep i = natDiv i 2 + natMod i 2 (the parent index plus the side bit).
  call "out 4" leafStep 7
  call "out 3" leafStep 6
  call "out aa" addrWord 0x00000000000000000000000000000000000000aa
  # domainWord: hash3 of the EIP712Domain typeHash, the chain id 1 and the contract address (S5 s1, Q-S5-2 (a)).
  call "out e87553ada92cb0a1fb851c7da488a3970644ad264d9ec721b4c4d0564f8ae2b" domainWord
  # listingHashV: hash4 of the merchant word, the sku, the price and the largest quantity (S5 s1, Q-S5-4 (a)).
  call "out 54fbaf8e6b9b31384796ddd9d0418e8e89f2ba838470db2474c139f0771a9ca9" listingHashV 0x00000000000000000000000000000000000000aa 1u 100u 5u
  # merkle2V: the Merkle root of depth 2 (S5 s1b, Q-S5-5 (b), O79). WANT is keccak256 by direct evm runs:
  # the index 1 gives keccak(keccak(2, 1), 3), the index 2 gives keccak(3, keccak(1, 2)), and the index 0 over demoL0, 7 and demoL1 gives demoRoot.
  call "out 3093105c651cad0e563322634a941388adb5da29ba262eddd8b99c4567960bec" merkle2V 1 1u 3u 2u
  call "out 9b0225f2c6f59eeaf8302811ea290e95258763189b82dc033158e99a6ef45a87" merkle2V 2 1u 3u 2u
  call "out 13cb0cf25603c21f60aa611efe8bd04bbd3b5bff5c45b4f389a7d34d18bf78b7" merkle2V 0 38438969539509123777507335721013279929321164130438759509698342409931075525801u 7u 37752521327644976104017471667882098167668241428459350234168561135720132625645u
fi

rm -rf "$tmp"
echo "precompile: $steps steps checked"
echo "precompile gate: $fail failures"
[ "$fail" -eq 0 ]
