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
