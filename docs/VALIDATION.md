# Validation

Date: YYYY-MM-DD. <Tool>: <version>. Host executable: `<path>` at
<commit>.

`<gate command>` passes: <what the gate checks and builds>, and it runs <N>
tests with zero failures. The test runner reported <S> seconds.

> Write here: one paragraph for each slice, in this form.

The <slice> review adds <N> cases in `<test file>`. They check <the forms
and the cases that work>. Refusals cover <the cases that the compiler must
refuse>.

## The attack corpus (S8)

The S8 rows are call scripts of `examples/mandate.lang` in `test/run/`.
`test/run.sh` runs each script on `langc --kit run`, and part 2 of
`test/diff.sh` runs it on `evm` with the chain id 1337. The G2 and G3 rows
use the mandate `gMandate` of `examples/precompile.lang`: the cap is
1000000u and the `autoLimit` is 100u. Row 1 of each script is `grant`.

| Attack | Form | Row | Result |
|---|---|---|---|
| Honest | The honest spend | `mandate-honest.script` rows 2 to 4 | `check` gives 0u, `execute` pays, a second `check` gives REPLAY (9u) |
| G1 | A cred sig of another user (another vault key) | `mandate-g1.script` row 2 | WRONG_SESSION (5u) |
| G1 | A cred sig of another session from the same vault | `mandate-g1.script` row 3 | WRONG_SESSION (5u) |
| G1 | A guest `lookup` with a user argument | `test/check/lookup-user.lang` | The type checker refuses it (4.3) |
| G2 | A changed price | `mandate-g2.script` row 2 | NO_PATH (2u) |
| G2 | A changed payee | `mandate-g2.script` row 3 | WRONG_MERCHANT (3u) |
| G2 | A listing that is not in the view | `mandate-g2.script` row 4 | NO_PATH (2u) |
| G2 | An unrequested item in the view | `mandate-g2.script` rows 5 to 7 | The residual of 4.5 |
| G2 | A promoted or demoted item in the view | `mandate-g2.script` rows 8 to 10 | The residual of 4.5 |
| G3 | A price over the cheapest matching listing | `mandate-g3.script` rows 2 to 4 | The residual of 4.5 |

The residual of 4.5. The contract does not know the request of the user or
the order of the listings in the view. Thus it cannot refuse a cart of a
listing that is in the view. For each residual form, the rows show the
bound of the `Gate` of 4.1:

- A total at or below `autoLimit` gives 0u. The loss is at most
  `autoLimit` for the mandate, because the limit is over all spends of
  the mandate.
- A total above `autoLimit` with no valid confirm sig gives NEED_CONFIRM
  (8u).
- A total above `autoLimit` with the confirm sig gives 0u. The user saw
  the cart and the claim, and approved them.

`maxQty` also limits the quantity of each line.

## The x402 route (S8)

The x402 route uses the entries of PLAN section 7 (Q3 (a), Q-S8-4 (a)).
In the verify step, the facilitator runs `check` by `eth_call`. In the
settle step, the facilitator sends `execute`. The facilitator does not
need a key of the user.

`test/run/mandate-x402.script` has these rows in the facilitator order.
The spend is `tSpend` of `examples/precompile.lang` (the session 11u, the
total 450u).

| Row | Step | Entry | Result |
|---|---|---|---|
| 1 | The user stores the mandate | `grant` | ok |
| 2, 3 | Verify, two times | `check` | 0u; no `pay` line, and the session stays unused |
| 4 | Settle | `execute` | pays 450u of the token 0x..ee to the merchant 0xaa |
| 5 | Settle the same session again | `execute` | revert; no tokens move |
| 6 | Verify after the settle | `check` | REPLAY (9u) |

`check` does not change the state. Thus the verify step cannot move
tokens, and the facilitator can do it again. `execute` does all the checks
of `check` before it pays. Thus a facilitator that does not do the verify
step also cannot move more tokens than the mandate allows.

The token signature (O18). We read the source of `FiatTokenV2_2`, the
USDC token (circlefin/stablecoin-evm, the `master` branch at the commit
fc85788bc7c2 of 2026-08-12):

- `transferWithAuthorization` with a `bytes` signature
  (`contracts/v2/FiatTokenV2_2.sol` line 116) calls
  `_transferWithAuthorization` (`contracts/v2/EIP3009.sol` line 118).
- That function calls `_requireValidSignature` (line 277), which calls
  `SignatureChecker.isValidSignatureNow` (line 283).
- `isValidSignatureNow` (`contracts/util/SignatureChecker.sol` lines 39
  to 48) uses ERC-1271 when the signer address has code (`extcodesize`
  more than 0, line 84): a STATICCALL of `isValidSignature` on the signer
  (line 65). When the signer address has no code, it uses ECDSA.

Thus the token accepts an ERC-1271 contract signature. A user account
with an EIP-7702 delegate has code. Thus the token sends the signature of
the user to `isValidSignature` of the account, and does not use ECDSA.
The contract of PLAN section 7 has no `isValidSignature` entry. Thus we
expect that the token refuses an EIP-3009 signature of a user that has
the delegate. No row tests this (O150). The x402 route of this repo stays
`check` plus `execute`.

## The zkpolicy condition (S9)

The S9 rows test the policy check of PLAN 4.9 with a mock verifier (O173
to O176). The real verifier of zkpolicy-lang is not available. Thus one
row is BLOCKED (the end of this section).

The mock rule (O183, O184, O186):

- The mock verifier is at the address 0x..ef, next to the token mock
  0x..ee. `build/asmtool verifier` prints its runtime.
- The five words of 4.9 are a to e: `policyId`, the domain, the mandate
  `id`, the session id `sid` and the cart hash. The mock key K is the
  ASCII bytes "mandate-mock" in one word.
- The proof word p is correct when it is keccak256 of the 192 bytes K,
  a, b, c, d, e. `build/asmtool proof A B C D E` prints the correct proof
  word.
- The mock reverts when the call data is not 192 bytes. Else it returns
  the word 1 (a correct proof) or 0.
- The kit op `policyVerify v a b c d e p` makes one STATICCALL to v with
  the five words and p. It gives flagYes only when the call succeeds, the
  return data is 32 bytes and the word is 1. Else it gives flagNo. A
  failed call does not revert.
- On `langc run`, the host gives flagYes only when v is 0x..ef and p is
  the correct proof word. The type checker and the lowering keep each
  call opaque. Thus a `PolicyProof` term comes only from the `prove`
  operation at run time.

| Slice | Row | Form | Result |
|---|---|---|---|
| s1 (O173) | `precompile.script` row 11 and `test/precompile.sh` | `verifyPolicy` at 0x..ef with the proof of the words 1 to 5 | flagYes (1) |
| s1 (O173) | `precompile.script` row 12 and `test/precompile.sh` | `verifyPolicy` at 0x..ef with the word 9 | flagNo (0) |
| s1 (O173) | `precompile.script` row 13 and `test/precompile.sh` | `verifyPolicy` at 0x..ab (no code: the call succeeds with no return data) | flagNo (0) |
| s1 (O173) | `test/precompile.sh` | A direct `evm run` of 160 bytes to the mock | revert |
| s2 (O174) | `precompile-proof.script` row 1 | `prove` gives the correct proof word | ok: the continuation gets the `PolicyProof` |
| s2 (O174) | `precompile-proof.script` rows 2 to 4 | `prove` gives a wrong word (1u), the proof of another session (the sid 102u) or the proof of another cart (the cart hash plus 1) | revert: no `PolicyProof`, and the continuation does not run |
| s2 (O174) | `precompile-proof.script` row 5 | `askProofN` at `nMandate` (the verifier 0x..ab, no code) with the correct proof word | revert |
| s2 (O174) | `test/run.sh`, the refused runs | The answer `prove 1u 2u` (two words) and the answer `prove 0xzz` (not a word) | RUN_ANSWER (exit 1) and EVAL_ARGS (exit 2), before the continuation |
| s2 (O174) | `test/check/policy-proof-forged.lang` | `pack 0u refl` as a `PolicyProof`, with no `prove` | The type checker refuses it (PATH_END) |
| s2 (O174) | `test/check/policy-ok-verifier.lang` | `unit` as the `PolicyOk` of a mandate with the verifier 0x..ef | The type checker refuses it (TYPE_MISMATCH) |
| s3 (O176) | `mandate.script` rows 20 and 21 | `grant` with the verifier 0x..ef, then `check` with the correct proof (L 32u) | ok, then 0u |
| s3 (O176) | `mandate.script` rows 22 to 25 | `check` with no proof (L 0u), a changed proof word, the proof of another cart (the cart hash plus 1) and the proof of another session (12u) | NO_POLICY (10u) |
| s3 (O176) | `mandate.script` row 26 | `check` with the length word 31u (not 0u and not 32u) | BAD_CALLDATA (11u) |
| s3 (O176) | `mandate.script` rows 27 and 28 | `grant` with the verifier 0x..ab (no code), then `check` with the correct proof | ok, then NO_POLICY (10u) |
| s3 (O176) | `mandate.script` rows 33 and 34 | `grant` with the verifier 0x..ef, then the honest `execute` with the correct proof | ok, then the `pay` line and the `Spent` event of S7 |

The scripts of the s1 and s2 rows are in `test/run/`. `test/run.sh` runs
them on `langc --kit run`. `test/precompile.sh` runs the s1 rows on `evm`
with the mock verifier at 0x..ef in the alloc (O187).

The s3 rows are in `test/run/mandate.script` and in
`test/mandate-evm.script`, with the same row numbers. `test/run.sh` runs
them on `langc --kit run`. Part 2 of `test/diff.sh` runs them on `evm`,
and `test/evm.sh` runs `test/mandate-evm.script` on a chain. Both put the
mock verifier at 0x..ef in the alloc (O197). The call data of `check` and
`execute` ends with the proof tail: the proof word p, then the length
word L (Q-S9-7 (a)). A row with no verifier has the tail 0u 0u, and the
contract does not call a verifier.

The row with the real verifier is BLOCKED (O178, Q-S1-3 (a)). It waits
for two items:

- zkpolicy-lang P10, its EVM verifier. P10 is not started; it waits for
  zkml-lang Z9.
- The mandate instance of 4.9: the words in limbs, the cart binding by
  keccak in the circuit, and the approving decision.

P10 alone does not close the row. The row needs three results: an
approving proof that succeeds, a valid proof of a denying decision that
gives NO_POLICY, and the proof of an approved cart with another cart that
gives NO_POLICY. If the P10 verifier has another call form, the kit op
changes (O29). S9 closes without this row (Q-S9-4 (a)). The mutants of
the S8 and S9 rows come in S10 (PLAN section 9).

## The mutants (S10)

S10 tests the S8 and S9 rows with mutants (PLAN O207 to O232). A mutant
is one small edit of one site that a row must find. Each of the 23
mutants is KILLED: a result row that passes on the unmodified tree fails
on the mutant.

The method (O209):

- Each mutant runs in a scratch tree under `$TMPDIR`: a `git archive`
  copy of HEAD, or a copy of the working tree when the session has new
  rows. The main checkout does not change.
- A mutant is one `sd -F` edit of one site. The count of the old text is
  checked before the edit. The guard chain of `examples/mandate.lang` is
  in the def `check` and again in the def `execute`, with the same text.
  Thus a guard mutant edits the two copies, and the count 2 is one site
  (O215).
- Before each edit, the unmodified scratch tree is built (`make -B -j 2
  build/langc build/asmtool build/slottool`) and the killing script
  runs. Both must exit 0. After the edit, the same build and the same
  killing script run again. make 3.81 compares mtimes to the second,
  thus `-B`.
- KILLED: a FAIL line for a reachable result row that passed on the
  unmodified tree. A missing tool, a setup failure or a build stop is
  not a kill. When the killing script does not kill the mutant, `make -k
  -B -j 2 check` runs, and a FAIL line of another row that passed on the
  unmodified tree is a kill by that row.
- After each mutant, the original file goes back, and `cmp` checks it.
- A SURVIVED mutant gets a new row in the same session. Then the mutant
  runs again.

s1 (`mandate-lang-work/S10-s1-mut.sh`) ran the build and `test/run.sh`
on the unmodified tree before each edit (O216). The first run of s2
(`S10-s2-mut.sh`) built the unmodified tree before each edit, but ran
each killing script only on its first use. That did not meet O209.
During the review of s2, all 16 mutants of s2 ran again in separate
scratch trees, each with a fresh build and a fresh passing killing
script before the edit. All 16 were KILLED by result rows that passed on
their own fresh baselines (O223).

A script name with no path is in `test/run/`.

| Slice | Mutant | Site | Killing row |
|---|---|---|---|
| s1 (O210) | G1a | `examples/mandate.lang`, the defs `check` and `execute`: the cred check (WRONG_SESSION, 5u) goes out | `mandate-g1.script` row 2: 5u changes to 0u |
| s1 (O210) | G2a | The same defs: the price word goes out of the leaf hash `hash4` (8 copies) | `mandate-g2.script` row 3: 3u changes to 2u; each other mandate script fails too |
| s1 (O210) | G2b | The same defs: the compare of the merchant word of the header with the session merchant (WRONG_MERCHANT, 3u) goes out | The new row `mandate-g2b.script` (O217): 3u changes to 5u |
| s1 (O210) | G3a | The same defs: `u256Le total (mAutoLimit s)` changes to `u256Le total (u256Sub (mAutoLimit s) 1u)` (at or below changes to below) | The new row `mandate-g3a.script` (O218): 0u changes to 8u |
| s1 (O210) | G3b | The same defs: the confirm sig check (NEED_CONFIRM, 8u) goes out | `mandate-g3.script` row 3: 8u changes to 0u |
| s1 (O210) | R1 | The same defs: the spent check (REPLAY, 9u) goes out | `mandate-honest.script` row 4: 9u changes to 0u; `mandate-x402.script` row 5: the `execute` revert changes to ok |
| s1 (O210) | X1 | The def `execute`: the payee of the pay changes from `(mMerchant s)` to `(mVault s)` | The pay line of `mandate-x402.script` and of `mandate-honest.script` |
| s2 (O211) | L1 | `src/lower.c`, the STUCK value of `policyVerify`: the first two fields change places | `test/precompile.sh`, the correct-proof row: want out 1, got out 0 |
| s2 (O211) | L2 | `src/evm.c`, IR_STMT_VERIFY: after the STATICCALL, DUP1, ISZERO and a jump to the revert label (a failed call reverts) | The new row of `test/precompile.sh` (O224): want out 0, got revert |
| s2 (O211) | E1 | `src/evm.c`, IR_STMT_VERIFY: the last EVM_OP_AND of the three-way test changes to EVM_OP_OR | `test/precompile.sh`, the wrong-proof row and the row of 0x..ab: want out 0, got out 1 |
| s2 (O211) | E2 | `src/evm.c`, IR_STMT_VERIFY: the input length of the STATICCALL is one word less | `test/precompile.sh`, the correct-proof row: want out 1, got out 0 |
| s2 (O211) | K1 | The mock verifier of `build/asmtool` reads 4 words, not 5 | `test/precompile.sh`, the correct-proof row: want out 1, got out 0 |
| s2 (O211) | H1 | `src/front/eval.c`, the host rule of `policyVerify` (O186): the memcmp of the address has the length 0 | `mandate.script`, `precompile.script` and `precompile-proof.script` |
| s2 (O211) | H2 | The same host rule: the memcmp of the proof digest has the length 0 | `mandate.script`, `precompile.script` and `precompile-proof.script` |
| s2 (O211) | H3 | `src/front/eval.c`, `policy_verify`: the `!m->policy_mock \|\|` guard goes out, thus a closed call converts in checking | The new row `test/check/policy-closed-call.lang` (O225): want exit 1 and PATH_END, got exit 0 |
| s2 (O211) | P1 | `src/front/check.c`, the generic `run_answer` of all IO ops: the RUN_ANSWER refusal goes out | `test/run.sh`, the refused run `prove 1u 2u`: exit 0, not exit 1 and RUN_ANSWER |
| s2 (O211) | P2 | The same `run_answer`: the EVAL_ARGS refusal goes out | `test/run.sh`, the refused run `prove 0xzz`: exit 1, not exit 2 and EVAL_ARGS |
| s2 (O211) | N1 | `examples/mandate.lang`: the NO_POLICY guard (`flagNo flagYes` changes to `flagNo flagNo`) | `mandate.script` |
| s2 (O211) | N2 | `examples/mandate.lang`: the test of the verifier 0 (no call) inverts | `mandate.script` and 6 more scripts |
| s2 (O211) | D1 | `examples/mandate.lang`, the fold step of the decoder of the proof tail (in `check` and `execute`): the write of the length word L does not occur | `mandate.script` |
| s2 (O211) | D2 | The same fold step: the write of the proof word p occurs at pos 2, not at pos 1 | `mandate.script` |
| s2 (O211) | A1 | `test/diff.sh`: the alloc of the mock verifier at 0x..ef goes out | `test/diff.sh`: 5 FAIL lines, the first at `test/mandate-evm.script` line 21 |
| s2 (O211) | A2 | `test/evm.sh`: the same alloc goes out | `test/evm.sh`: 7 FAIL lines, the first at the same line 21 |

The 4 new rows (Q-S10-2 (a)). Before S10, no row killed these 4
mutants:

- `test/run/mandate-g2b.script` (G2b, O217). WRONG_MERCHANT (3u) has two
  sources: the line check (a leaf merchant that is not the merchant word
  of the header) and the G2b site (the merchant word compared with the
  session merchant). Form 2 of `mandate-g2.script` has the merchant word
  0xaa and a leaf of 0xbb. Thus the line check gives 3u, and the G2b site
  does not decide. The new row has the merchant word 0xbb (187u): the
  line check passes, and only the G2b site gives 3u.
- `test/run/mandate-g3a.script` (G3a, O218). No row had the total at the
  `autoLimit`. The new row is the grant of `mandate-g3.script` with the
  `autoLimit` 90u, then `s8hSpendA` (the total 90u) with a confirm sig
  that is not valid. It gives codeOk (0u), because a total at the
  `autoLimit` needs no confirm.
- `test/precompile.sh`, the verifier at 0x..ac (L2, O224). No verifier
  reverted. The new verifier has the code 0x5f5ffd (PUSH0 PUSH0 REVERT),
  and `verifyPolicy` of 0x..ac with the true proof must give out 0. A
  failed call gives flagNo; it does not revert.
- `test/check/policy-closed-call.lang` (H3, O225). The PATH_END row
  `test/check/policy-proof-forged.lang` has the open values s and c, thus
  the H3 mutant does not reach it. No row had a closed `policyVerify`
  call. The new row is `closedCall : Path Flag (policyVerify 0x..ef 1u
  2u 3u 4u 5u PF) flagYes := refl`, with PF the true proof
  (`build/asmtool proof 1 2 3 4 5`). The type checker keeps the call
  opaque and refuses the row (PATH_END). The row is in
  `test/check/kit.txt` and in `test/check/expect.txt`.

Each session has a gate (O212). The s1 gate gives EXIT 0 (O219), and
each change is one of the 2 new rows of s1: `diff gate: 21 rows` changes
to `23 rows`, and `runs: 16 checked` changes to `18 checked`. The s2
gate gives EXIT 0 (O226), and each change is one of the 2 new rows of
s2: `check refusals: 185 checked` changes to `186 checked`, and
`precompile: 31 steps checked` changes to `32 steps checked`. The final
gate of s3 (O230) gives EXIT 0 in 505 s, with the same results as the
s2 gate: s3 adds no row.

The row with the real verifier stays BLOCKED after the close of the plan
(O178, the end of the S9 section). A later slice can open the plan again
for it (O212).
