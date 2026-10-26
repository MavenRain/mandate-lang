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
