# mandate-lang plan

mandate-lang is a Cubical TT language for agent payment mandates. A user
gives an agent a mandate. The mandate is a type: its terms are the spends
that the user authorized. Each cart line holds a path back to a listing
that the user saw. Each payment credential is indexed by the session that
asked for it. A spend above the user's limit needs an explicit user
confirmation. The compiler checks the program and writes the EVM bytecode
of the checker: an EIP-7702 delegate contract with a check entry that an
x402 payment facilitator can call. `design/DESIGN.md` holds the request
and the brief verbatim.

## 1. Rulings

USER rulings (the request, 2026-10-24):

- R1 type formers: for type constructors (higher kinds), only cell monads
  and their duals, in a locally presentable, locally cartesian closed
  (infinity,1)-category, as Cubical TT realizes it.
- R2 base types and operations: the minimum for the pasted brief
  (mandate-lang: agent payment mandates).
- R3 host: TinyCC.
- R4 target: the minimum for the brief: EVM, as an EIP-7702 delegate
  contract or as a check that an x402 payment facilitator runs.

USER rulings (2026-10-24, S1), verbatim: "For Q1 to Q9, take
recommendations, and rule (b) for Q10.  Give next session prompt"

- Q1 (a): the reading of R1 as intent-lang ruled it (section 2).
- Q2 (a): IO is the free CM of the payment operations; the checker is the
  CC `Machine` (4.6, 4.7).
- Q3 (a): one EIP-7702 delegate with `execute`, plus `check` for an x402
  facilitator (section 7).
- Q4 (a): one Merkle root over the listings that the user saw or approved,
  with `maxQty` per leaf (4.2).
- Q5 (a): a vault key apart from the agent key signs `Cred s` (4.3).
- Q6 (a): `autoLimit` over all spends of the mandate (4.5).
- Q7 (a): one ERC-20 per mandate by the kit `pay`.
- Q8 (a): the kernel port from bridge-lang, plus the host `ecrecover` of
  intent-lang ef5abe8 (section 6).
- Q9 (a): the kit additions `chainid`, `self` and the byte form of
  `keccak` in mandate-lang (O12).
- Q10 (b): plan a slice now that adds a zkpolicy-lang proof (section 4.9,
  slice S9).

USER rulings (2026-10-24, the S1 questions), verbatim: "Take all
recommendations for rulings."

- Q-S1-1 (a): a policy proof per mandate: `policyVerifier == 0` means
  none; for another mandate each spend needs one (4.9).
- Q-S1-2 (a): the public inputs `policyId`, `domain`, mandate `id`,
  `sid`, `cartHash` (4.9).
- Q-S1-3 (a): the mock verifier in S9 now; the row with the real verifier
  after zkpolicy-lang P10 (BLOCKED).
- Q-S1-4 (a): this plan records the request to zkpolicy-lang (O27);
  zkpolicy-lang does it in its own slice.
- Q-S1-5 (a): `lookup` takes only the session (4.3); S8 adds a run script
  for G1 of the paper.
- Q-S1-6 (a): Q4 (a) stays; the residual of 4.5 adds two forms of G2; S8
  adds a row for each of the five forms.
- Q-S1-7 (a): the `autoLimit` rule of Q6 (a) stays; S8 adds a G3 row
  below `autoLimit` and one above it.

USER rulings (2026-10-24, S4 s2 Step 0, by AskUserQuestion): all (a).

- Q-S2-1 (a): drop the contract writer of bridge-lang; the mandate
  contract writer comes in S7.
- Q-S2-2 (a): drop the ZK surface of orbit-lang S8 B2b; the policy proof
  surface comes in S9 (4.9).
- Q-S2-3 (a): the failed-STATICCALL revert path of lower.c stays without
  a test; the S9 STATICCALL policy verifier op adds a failing precompile
  row.
- Q-S2-4 (a): examples/dao.lang keeps the DAO prelude as kernel text
  without `b0`, `w0`, `c0` and `complete`.
- Q-S3-1 (a): port F16 to F19, the Fin kit note and their matrix rows
  from bridge-lang formers/FORMERS.md as a docs change (S4 s3).
- Q-S3-2 (a): `bagComm` stays the swap of 4.4.
- Q-S4-1 (a): fixed-arity `hash3` and `hash4` with the plumbing of
  `hash` (S4 s3).

Builder calls (NOT ruled; section 10 gives each one, section 11 gives the
questions):

- O1: the name mandate-lang (from the brief).
- O2: the kit is hosts/tcc-evm-contract (U256, Addr, Env, `pay`, `pull`,
  events). `pay` calls `transfer(to, amount)` of the token with the
  contract as the sender. Under EIP-7702 the contract is the user account,
  so `pay` spends the user's tokens.
- Tests are guest-language files plus `langc run` scripts. The kit gate
  scripts stay. We add no new harness.

- 2026-10-24 (S5 s1 kickoff, claude7): the USER RULED (a) on Q-S5-1 to
  Q-S5-4 (section 11).
- 2026-10-24 (S5 s1, claude7): the USER RULED (b) on Q-S5-5 (section
  11): a word select op in S5 s1b.
- 2026-10-25 (S5 s1b, claude7): `flagIf` is the word select (O79), so
  `side` lowers and the chain runs `merkle2V` (O80). Gate EXIT 0.
- 2026-10-25 (S5 s2, claude7): the USER RULED (a) on Q-S5-6 (O83) and
  Q-S5-7 (O82).
- 2026-10-25 (S5 close, claude7): S5 DONE. Gate EXIT 0 with the counts
  of the S5 row (section 9).
- 2026-10-25 (S6 kickoff, claude7): the USER accepted the S5 commit
  0fb3760 as the base (O85). The USER RULED Q-S6-1 (a), Q-S6-2 (a),
  Q-S6-3 (a) and Q-S6-4 (b) (section 11).
- 2026-10-25 (S6 s1, claude7): the USER RULED Q-S6-5 (a) and Q-S6-6 (a)
  (section 11). s1 DONE, UNSTAGED (O90 to O94).
- 2026-10-25 (S6 s2 part 1, claude7): the R1 field rule (Q-S6-1 (a)) and
  `IO` in domain/domain.lang, UNSTAGED (O95 to O97). Q-S6-7 OPEN.
- 2026-10-25 (S6 s2 part 2, claude7): the USER RULED Q-S6-7 (a): the
  field `confirmNext`
  takes the closed data `Prod Nat (Prod U256 U256)`. Q-S6-8 RULED (a):
  `elim` takes a motive on Flag; `confirm` uses the inspect form, and the
  no case reverts. s2 part 2 DONE, UNSTAGED (O98 to O101).
- 2026-10-25 (S6 s2 part 3, claude7): the answer form of `langc run`
  (Q-S6-1 (a)): an IO entry prints `K NAME OP WORD`, and the next script
  line answers it. The new code RUN_ANSWER. No new question. s2 part 3
  DONE, UNSTAGED (O102 to O105).
- 2026-10-25 (S6 close, claude7): 8 of 8 mutants KILLED (O106). M1 (the
  OP check of run_answer) lived first; the USER RULED (a): a new
  RUN_ANSWER row answers each operation after the wrong OP. Run refusals
  13 to 14. The host README run output text. S6 DONE, STAGED (O107).
- 2026-10-25 (S6 staged review): fixed the printed Flag motive ambiguity
  (O108) and added the typed viewer and credential responses required by
  4.3 and 4.6 (O109). The word transport of Q-S6-1 (a) is retained.
- 2026-10-25 (S7 kickoff, claude7): base 17d50a4, the USER S6 commit
  (tree 4e66bc61). It adds the S6 staged review (O108, O109: 8 files) to
  the staged tree d47c84eb, thus the S7 items start at O110. The S7
  plan: the sessions s1 to s4 (O110), the facts and the gaps O111 to
  O118, the questions Q-S7-1 to Q-S7-3 (section 11).
  The USER RULED (2026-10-25): the base 17d50a4 is accepted (O111);
  Q-S7-1 (a), Q-S7-2 (a) and Q-S7-3 (a), each as RECOMMENDED.
- 2026-10-25 (S7 s1, claude7): `Machine` and `Req` in domain/domain.lang
  (the cofield is `mStep`, O119), the kit example examples/machine.lang
  (O120), a last `List U256` entry argument (Q-S7-2 (a): a CALLDATALOAD
  fold, O121 to O124), the `uint256[]` ABI fix (O125) and
  examples/listarg.lang with its rows (O126). The USER RULED Q-S7-4 (a)
  (2026-10-25, O127). s1 DONE (O128); the S7 row stays IN PROGRESS.
  S7 s2 part 1: examples/mandate.lang part 1 (O129, O130). The USER
  RULED Q-S7-5 (a) (2026-10-25, O131): the kit lowers a Prod fold
  accumulator (O132), and Q-S7-6 (a) (2026-10-25, O133): a trap in a
  part of a Prod fold accumulator is a trap of the fold. The USER RULED
  Q-S7-7 (a) (2026-10-25, O134): the decoder needs no U256 to Nat kit
  op. The USER RULED Q-S7-8 (2026-10-25, O135): (i) (b), the merchant
  address is a state word; (ii) (a), qty over maxQty gives NO_PATH.
  S7 s2 DONE (O136 to O140): the decoder, the step weights, the evm
  rows and the 25 mutants KILLED; the S7 row stays IN PROGRESS.
- 2026-10-26 (S7 close, claude7): S7 s3 DONE (O141 to O143) and s4,
  the close (O144). The final gate gives EXIT 0, the same as the s3
  resume 1b gate. The mutants of S7 ran in s2 (O140, 25 of 25
  KILLED). S7 is DONE and STAGED; the USER commits. The next slice is
  S8.
- 2026-10-26 (S8 kickoff, claude7): the USER commit 11f166e has the
  tree of the S7 close (O145). The fresh gate gives EXIT 0, the same as
  the S7 s4 gate. The S8 plan: O145 to O151, the sessions s1 to s3
  (O146), Q-S8-1 to Q-S8-4. USER rulings (2026-10-26, S8 kickoff, by
  AskUserQuestion): all (a). The S8 row is IN PROGRESS. The next step
  is S8 s1 (mandate-lang-work/S8-s1-PROMPT.md).
- Q-S8-1 (a): one call script per attack and one for the honest spend,
  on `langc run` and on `evm`, plus one IO script of the honest spend.
- Q-S8-2 (a): G1 has two WRONG_SESSION check rows and one type row.
- Q-S8-3 (a): each residual form has an accept row, a NEED_CONFIRM row
  and a confirmed row.
- Q-S8-4 (a): the x402 route stays `check` plus `execute`; O18 is a
  source read, with no row.
- 2026-10-26 (S8 s1, claude7): the honest spend, G1 and G3 rows are in
  test/run/ (on `langc run`) and in part 2 of test/diff.sh (on `evm`).
  The G1 type row is test/check/lookup-user.lang. The IO-to-chain row is
  the entry askSpend with test/run/precompile-spend.script (O152 to
  O158). USER ruling (2026-10-26, S8 s1): Q-S8-5 (a). The gate gives
  EXIT 0. s1 is DONE and STAGED; the USER commits. The next step is S8
  s2 (mandate-lang-work/S8-s2-PROMPT.md).
- Q-S8-5 (a): a new IO entry askSpend; the IO run and the chain run link
  by value.
- 2026-10-26 (S8 s2, claude7): the five G2 rows are in
  test/run/mandate-g2.script (on `langc run`) and in part 2 of
  test/diff.sh (on `evm`). docs/VALIDATION.md has the table of the
  attack forms and the residual of 4.5 (O159 to O165). The gate gives
  EXIT 0. s2 is DONE and STAGED; the USER commits. The next step is S8
  s3 (mandate-lang-work/S8-s3-PROMPT.md).
- 2026-10-26 (S8 s3, claude7): the USER commits 5bde71b (s1) and
  fb2e68e (s2) are in HEAD. The x402 rows are in
  test/run/mandate-x402.script (on `langc run`) and in part 2 of
  test/diff.sh (on `evm`). The O18 source read: the USDC token accepts
  an ERC-1271 signature (O167). docs/VALIDATION.md has the section of
  the x402 route (O166 to O170). The final S8 gate gives EXIT 0. s3 is
  DONE and STAGED, and S8 is DONE; the USER commits. The next step is
  S9 (mandate-lang-work/S9-kickoff-PROMPT.md).
- 2026-10-26 (S9 kickoff, claude7): the USER commit 3074cd1 (S8 s3) is
  in HEAD. The fresh gate gives EXIT 0 and the same result as the S8
  s3 gate (O172). The USER RULED Q-S9-1 to Q-S9-4 (a) (section 11). The
  S9 plan is O171 to O179. The next step is S9 s1
  (mandate-lang-work/S9-s1-PROMPT.md).
- 2026-10-26 (S9 s1, claude7): the kit op policyVerify and the mock
  policy verifier are done (O173, O180 to O188). The s1 gate gives
  EXIT 0. The next step is S9 s2 (mandate-lang-work/S9-s2-PROMPT.md).
- 2026-10-26 (S9 s2, claude7): the USER commit f972a4f (S9 s1) is in
  HEAD. `PolicyProof`, `PolicyOk` and the `prove` operation are done
  (O174, O189 to O194). The s2 gate gives EXIT 0. The next step is S9 s3
  (mandate-lang-work/S9-s3-PROMPT.md).
- 2026-10-26 (S9 s3, claude7): the USER commit 97c8a8a (S9 s2) is in
  HEAD. The proof tail, the policy call and the NO_POLICY rows are done
  (O175, O176, O195 to O202). The s3 gate gives EXIT 0. The next step is
  S9 s4 (mandate-lang-work/S9-s4-PROMPT.md).
- 2026-10-26 (S9 s4, claude7): the USER commit dcf6fc8 (S9 s3) is in
  HEAD. docs/VALIDATION.md has the section of the zkpolicy condition
  (O177, O204). The final S9 gate gives EXIT 0 and the same result as
  the S9 s3 gate (O205). s4 is DONE and STAGED, and S9 is DONE; the row
  with the real verifier stays BLOCKED (O178). The USER commits. The
  next step is S10 (mandate-lang-work/S10-kickoff-PROMPT.md).
- 2026-10-27 (S10 kickoff, claude7): the USER commit 0703e66 (S9 s4) is
  in HEAD. The fresh gate gives EXIT 0 and the same result as the S9 s4
  gate (O208). The S10 plan: the mutant method (O209), the mutants of
  the S8 rows (O210) and of the S9 rows (O211), and the sessions s1 to
  s3 (O212). Q-S10-1 to Q-S10-4 RULED (a). The USER commits. The next
  step is S10 s1 (mandate-lang-work/S10-s1-PROMPT.md).

## 2. The reading of R1

R1 has the same text as in intent-lang and bridge-lang. This plan proposes
the reading that intent-lang ruled on 2026-10-22 (intent-lang Q1 (a), Q2
(a)) and bridge-lang took (bridge-lang Q1 (a)). Here it is RULED Q1 (a)
(USER 2026-10-24).

### 2.1 The ambient structure

| Ambient part | Cubical TT term | Note |
|---|---|---|
| Pi, Sigma | `(x : A) -> B x`, `(x : A) * B x` | the LCC structure |
| identity | `Path A a b`, `PathP`, the interval `I`, `transp`, `hcomp` | Kan operations |
| universe | `U`, `Glue`, `ua` | univalence by Glue |

These are the internal language of the category. A program does not
declare them, and R1 does not limit them.

### 2.2 The admitted type constructors

A type constructor is a declaration with a type parameter, or any map
`U -> U`. R1 admits two classes and no others (O3):

| Class | Definition | Examples in mandate-lang |
|---|---|---|
| CM, cell monad | The free algebra monad of a cell signature. The type parameter occurs in the generator `eta` only. Each other constructor takes closed base data and arguments of the defined type only. | `Option`, `List` (the free monoid: Merkle siblings), `Bag` (the free commutative monoid, a QIT: the cart, 4.4), `‖-‖`, `IO` (the free monad of the payment operations, 4.6) |
| CC, cocell comonad | The cofree coalgebra comonad of a cocell signature: a coinductive record with one observation `eps : D A -> A`; each other field has type `D A -> D A` or `D A -> E -> D A` with `E` closed data. | `Machine` (the checker, 4.7) |

A declaration with no type parameter is not a type constructor. So the
indexed families `Line m s`, `Cart m s`, `Cred s`, `Confirmed s c`,
`PolicyProof m s c` and `Spend m` (index values, no type parameter) are
admitted, as `Pool k` is in
bridge-lang (O14).

`REFUSE_CELL` refuses a parameterized declaration that is not a cell
signature or a cocell signature (as intent-lang S3 and bridge-lang).

## 3. The minimal base signature (R2)

Each name has one of three kinds, as in orbit-lang:

| Kind | Meaning |
|---|---|
| slot | The program gives the type from formers and kit base data. |
| defined | The prelude defines it from slots, formers and kit base data. |
| primitive | Opaque. The kit implements it. Only the listed operations use it. |

Kit base data (tcc-evm-contract): `U256`, `Addr`, `Env` (`now`,
`caller`), `Out` (`pay`, `pull`, `emit`), the contract `State`.
Additions (O12): `Env` gets `chainid` (opcode 0x46) and `self` (opcode
0x30), because the EIP-712 domain needs both. Two host primitives:
`keccak` (the kit has it) and `ecrecover` (precompile 0x01; intent-lang
S7 has the host form). No BN254, no ElGamal, no ring signatures. One more
kit addition for 4.9 (Q10 (b), O12): an external STATICCALL, with words
and calldata bytes in and one word out, for the policy verifier.

| Name | Kind | Reading |
|---|---|---|
| Hash | defined | `U256`, one keccak256 word |
| Sig | defined | `Nat * U256 * U256` (v, r, s); v is the `Nat` of `ecrecover` (O63) |
| signer | defined | `ecrecover` of an EIP-712 digest; the zero address is no signer |
| Mandate | defined | a record: `owner`, `agent`, `viewer`, `vault`, `token`, `cap`, `autoLimit`, `expiry`, `id`, `policyVerifier`, `policyId` (4.1, 4.9) |
| Listing | defined | `(merchant : Addr) * (sku : U256) * (price : U256) * (maxQty : U256)` |
| View m | defined | `(root : Hash) * Signed (viewer m) (root, id m)`: the Merkle root of the listings that the user saw or approved (4.2); in the guest `View d m`, where `d` is the EIP-712 domain word from `Env` (Q-S5-2 (a)) |
| Session m | defined | `(sid : U256) * (merchant : Addr) * View m` |
| Prov v l | defined | `(i : Nat) * (sib : List Hash) * Path Hash (merkle i (listingHash l) sib) (root v)`; `sib` lists the siblings from the root down (4.2; Q-S5-1 (a), Q-S5-4 (a), O70) |
| Line m s | defined | `(l : Listing) * (q : U256) * Prov (view s) l * Path Addr (merchant l) (merchant s) * Le q (maxQty l)` |
| Cart m s | defined | `Bag (Line m s)` (4.4); in the guest the list of lines in the canonical order (Q-S5-6 (a), O83) |
| Cred s | defined | `Signed (vault m) (sid s, merchant s, root (view s))` (4.3) |
| Confirmed s c | defined | `Signed (viewer m) (sid s, cartHash c, claimHash)` (4.5) |
| PolicyProof m s c | primitive | a zkpolicy-lang proof of an approving decision for this spend; its only operation is the verifier call (4.9) |
| PolicyOk m s c | defined | `Unit` when `policyVerifier m == 0`, else `PolicyProof m s c` (4.9) |
| Spend m | defined | the type of the mandate (4.1) |
| Op, IO | defined | the payment operations and their free monad (4.6) |
| Req, Machine | defined | the checker requests and the checker (4.7) |

## 4. Readings of the brief on Cubical TT

### 4.1 A spending mandate is a type

The owner signs a mandate once. The mandate names four keys, because the
brief has four roles:

| Key | Role |
|---|---|
| `owner` | the user account (under EIP-7702, the address of the contract) |
| `agent` | the agent session key; it submits spends |
| `viewer` | the user's display client; it signs what the user saw and the confirmations |
| `vault` | the credential provider; it answers credential lookups |

Two roles can have the same address. The type of the mandate is the type
of its spends:

```text
Spend m = (s : Session m) * (c : Cart m s) * Cred s
        * Le (spent m + total c) (cap m) * Lt (now) (expiry m)
        * Gate m s c * PolicyOk m s c
Gate m s c = if spent m + total c <= autoLimit m then Unit else Confirmed s c
PolicyOk m s c = if policyVerifier m == 0 then Unit else PolicyProof m s c
```

`total c` is the sum of `price l * q` over the lines. A line has no amount
field: the amount comes from the listing that the user saw. `spent m` is
contract state, so `Spend m` is a type over the state of the checker.
`PolicyOk` is the zkpolicy condition (4.9).

### 4.2 What the user saw is a path

The viewer signs the Merkle root of the leaves `hash l` of the listings
that the user saw or approved (Q4). A leaf holds the merchant, the item,
the price and the largest quantity. A cart line holds `Prov`: the index of
the leaf, its siblings, and a path in `Hash` from the recomputed root to the
signed root.

`Hash` is a set with decidable equality (Hedberg). So the path is a
proposition, and the kernel decides it by computation: the path exists if
and only if the two words are equal. A line for a listing that the user
did not see has no `Prov` term, so a program that builds it is a type
error. On the chain the decoder recomputes the root and refuses the call
(4.8).

### 4.3 A credential is indexed by its session

`lookup : (s : Session m) -> IO (Cred s)`. The vault signs the session
number, the merchant and the view root. To use `Cred s` with a cart of
`s'`, a program needs a term of `Path (Session m) s s'`. `Session m` is a
set, so this path exists only when `s` and `s'` are equal. So a credential
from one session cannot pay in another session, or to another merchant.
On the chain the checker compares the three signed words with the session
of the cart.

When the vault key is not the agent key (Q5 (a)), an agent that is steered
or broken cannot make a credential for a session that the vault did not
open.

G1 of the paper (O23, Q-S1-5 (a)) is a lookup of the credential of
another user, not the use of a credential in another session. `lookup`
takes only the session. `Cred s` holds no user identifier. The vault
answers only for the sessions of its own mandate. So a guest program that
asks for the credential of another user is a type error: `lookup` has no
argument for it. On the chain, a credential of another user has another
signer, or another `self` in its domain, and the checker refuses it
(`WRONG_SESSION`).

### 4.4 The cart is a bag

The order of the lines does not change a cart. So `Cart m s` is `Bag`,
the free commutative monoid (a QIT with a `swap` path constructor; in the cell form the swap is `bagComm`, Q-S3-2). Each
map out of `Bag` must respect `swap`. `total` does, because `+` on `U256`
commutes (and the checker refuses an overflow, O17). `cartHash` hashes the
canonical form: the lines in strictly increasing order of `hash l`. The
decoder accepts only this order. So one bag has one byte form, and one
listing cannot occur on two lines.

### 4.5 Confirmation

A false stock claim ("two left, buy now") leaves no trace in the listing,
the cart or the credential. All three are valid. No type can refuse it.
So the language has the operation `confirm`:

```text
confirm : (s : Session m) -> (c : Cart m s) -> Claim -> IO (Confirmed s c)
```

The viewer shows the cart and the merchant claim to the user. The user
approves, and the viewer signs the session number, the cart hash and the
hash of the claim text. The `Gate` of 4.1 makes `Confirmed` necessary when
the spends of the mandate pass `autoLimit` (Q6 (a)). The limit is over all
spends of the mandate, not over one cart, so an agent cannot avoid the
gate by splitting a spend into small carts.

Residual risk (O9, O21, O24): below `autoLimit`, a false claim can still
steer a spend of listings that the user saw, at most `maxQty` each. G2 of
the paper has two more forms of this kind (Q-S1-6 (a)): an unrequested
item, and a promoted or demoted item, when the listing is in the view. The
loss from these attacks is at most `autoLimit` for the mandate.

The A-VIP rule of the paper (O25) asks for a confirmation when the cart
price is more than the cheapest matching item, but not when the intent
states a budget. Each mandate states `cap`, so this plan keeps the
`autoLimit` rule (Q-S1-7 (a)).

### 4.6 IO is the free cell monad of the payment operations

agent-lang has 13 IO operations, among them `confirm`. Its IO is a final
coalgebra (an interaction tree). An interaction tree is neither a CM nor a
CC, so R1 does not admit it (O5). A payment session is finite, so the free
monad of the operation signature is enough. It is a CM:

```text
data IO (A : U)
  eta : A -> IO A
  op  : (o : Op) -> (Resp o -> IO A) -> IO A
```

| Op | Answered by | Response |
|---|---|---|
| `show` | the viewer | `View m` |
| `lookup s` | the vault | `Cred s` |
| `confirm s c claim` | the viewer and the user | `Confirmed s c` |
| `prove s c` | the policy prover (4.9) | `PolicyProof m s c` |
| `submit` | the checker | a receipt or a refusal code |

We take the agent-lang design of IO (the operation signature, the host
interpreter, `confirm`). We do not take its other operations (model, files,
terminal). The guest evaluator answers the operations from a `langc run`
script, which plays the user, the viewer, the vault, the merchant and the
policy prover.

### 4.7 The checker is the dual

```text
codata Machine (A : U)
  eps  : Machine A -> A
  step : Machine A -> Req -> Machine A
```

`Machine` is the cofree comonad over `Req -> -`, a CC. `eps` gives the
state (the mandate, `spent`, the used session numbers, `revoked`). `mStep`
runs one request. The agent program is a CM term and the checker is a CC
term. A run interprets `submit` by one `mStep` and the other operations by
the script. The guest run and the EVM run of one script give the same
state (the differential law of section 5).

### 4.8 The chain fragment

The calldata of a spend is bytes, not a typed term. So the decoder is the
type check at the boundary: it parses the bytes into `Spend m` or refuses.
The guest types help the author of an agent program. The decoder stops an
agent that is steered or broken. Each guest type error has a chain refusal
code:

| Guest type | Chain check | Refusal |
|---|---|---|
| `View m` | `signer (domain, root, id) == viewer` | `NO_VIEW` |
| `Prov v l` | Merkle root recomputed by keccak | `NO_PATH` |
| `Path Addr (merchant l) (merchant s)` | word equality | `WRONG_MERCHANT` |
| `Cart m s` order | strictly increasing `hash l` | `NOT_CANONICAL` |
| `Cred s` | `signer (domain, sid, merchant, root) == vault` | `WRONG_SESSION` |
| `Le (spent + total) cap`, expiry | word compare, no overflow | `OVER_CAP`, `EXPIRED` |
| `Gate` | `signer (domain, sid, cartHash, claimHash) == viewer` | `NEED_CONFIRM` |
| one spend per session | `used sid` is false | `REPLAY` |
| `PolicyOk m s c` | `policyVerifier == 0`, or a STATICCALL of `policyVerifier` on the five public words and the proof returns 1 (4.9) | `NO_POLICY` |

The EIP-712 domain holds `chainid` and `self`. Under EIP-7702 `self` is
the user account, so a signature for one user does not verify for another
user or on another chain.

The contract does the `NO_POLICY` check last. It is the only check that
calls another contract, and it uses the most gas.

### 4.9 The zkpolicy condition

Q10 (b): a slice adds a zkpolicy-lang proof to the spend. zkpolicy-lang
proves that an agent decision followed a policy. mandate-lang proves that
the spend is in the mandate. The ruling says "a zkpolicy proof to `Gate`".
This plan puts the proof in a new factor `PolicyOk` next to `Gate` (4.1),
so the confirmation rule of Q6 (a) does not change. Q-S1-1 (c) is the form
in `Gate`.

```text
PolicyOk m s c = if policyVerifier m == 0 then Unit else PolicyProof m s c
```

A mandate with `policyVerifier == 0` needs no proof. For another mandate,
each spend needs a proof (Q-S1-1 (a)).

`PolicyProof m s c` is a primitive (section 3). Its only operation is the
verifier call. mandate-lang does not read the proof, and it does not take
BN254 (R2 minimum): the pairing runs in the verifier contract of
zkpolicy-lang (its O6, RULED 2026-10-15: Halo2 with KZG on BN254, the
contract made by the snark-verifier crate). `PolicyProof m s c` has index
values and no type parameter, so R1 admits it (2.2, O14).

Proof validity alone does not authorize a spend. In zkpolicy-lang,
`prove` makes a proof for every context, and `Completeness` makes
`verify` true even when the decision rejects it
(`domain/domain.lang`, `PolicySig` and `Completeness`). The verifier for
mandate-lang must also enforce `authorize (eval p context) == true`,
where `authorize` is the approval predicate fixed by the policy instance.
The verifier pins `policyId` to that policy and its verification key; the
prover cannot choose a different policy or approval predicate. The
decision and the cart in that evaluation must be constrained by the same
proof. A valid proof of a denying decision gives `NO_POLICY`.

The public inputs bind the proof to one spend (Q-S1-2):

| Word | Source | A proof for one value does not verify for |
|---|---|---|
| `policyId m` | the mandate | another policy of the same verifier |
| `domain` | the EIP-712 domain (`chainid`, `self`) | another user account or another chain (O30) |
| `id m` | the mandate | another mandate of the user |
| `sid s` | the session | another session |
| `cartHash c` | the cart (4.4) | another cart |

The policy prover makes the proof off the chain. So `IO` gets the
operation `prove s c : IO (PolicyProof m s c)` (4.6, O28). A guest program
has no other way to make a `PolicyProof` term.

On the chain (4.8) the contract does a STATICCALL of `policyVerifier m`
with the five words and the proof bytes from the calldata. It accepts the
spend only if the call succeeds and returns the word 1 (O29). If the call
fails or returns another word, the contract refuses with `NO_POLICY`. A
STATICCALL cannot change state, so `check` stays a view. For the real
verifier, 1 means both a valid proof and an approving decision for the
pinned policy and this spend. An adapter around the upstream verifier
must preserve that requirement.

The zkpolicy-lang side (O27, Q-S1-4). The public part of a zkpolicy-lang
statement is `Field public` of the instance (its N3: `ZKProof : Policy ->
Field public -> Transcript -> Type`). An instance can choose a `Field
public` that holds the five words. Two gaps are open:

1. The field. The circuit of zkpolicy-lang P9 computes over BabyBear, and
   the EVM route is BN254. A 256-bit word does not fit in one element of
   either field, so each word needs limbs.
2. The binding. The proof ties the policy decision to `cartHash c` only
   if the circuit computes `cartHash` from the cart in its context (keccak
   in the circuit). A route that exposes cart lines as additional public
   inputs must also compare them with the decoded cart on the chain;
   merely making them public does not bind them to `cartHash`. No
   zkpolicy-lang slice has this today. Both routes must enforce the
   approval predicate above.

Build route (Q-S1-3). zkpolicy-lang P10 (its EVM verifier) is not started.
It needs zkml-lang Z9 (Halo2). So S9 uses a mock verifier in the style of
the kit mock token. The mock accepts if and only if the proof is one word
equal to `keccak (K, the five words)`, with `K` a fixed mock key. The
guest evaluator runs the same rule, so the differential compares one rule
on the two sides. A missing proof, a changed word, another cart and a
proof of another session give `NO_POLICY` on the two sides. The row with
the real verifier waits for zkpolicy-lang P10 and the mandate instance
that closes the field and cart-binding gaps and enforces approval
(BLOCKED). P10 alone does not close this integration. The fixed-key mock
tests transport and binding only; it gives no evidence of policy
authorization. On the real row the guest side cannot run the check (this
repo has no BN254), so the row compares the `evm` result with the result
that the script states. It needs an approving proof that succeeds, a
valid proof of a denying decision that gives `NO_POLICY`, and a proof
for an approved cart submitted with another cart that gives `NO_POLICY`.

## 5. Laws

| Law | Form in mandate-lang |
|---|---|
| provenance | each line of a spend has `Prov` into the signed view (4.2) |
| shown price | the paid amount is `total c`, from the listings only (4.1) |
| session binding | `Cred s` pays only for `Cart m s` (4.3) |
| budget | `spent` does not decrease, and `spent <= cap` in each state |
| gate | a spend that passes `autoLimit` has `Confirmed` (4.5) |
| policy | a spend of a mandate with `policyVerifier` not 0 has a proof of an approving decision by the pinned policy on this cart, bound to the five public words of the spend (4.9) |
| bag | `total` and `cartHash` respect `swap` (4.4) |
| no replay | a session number spends once |
| IO monad laws | paths by the induction principle of `IO` |
| differential | the guest run and the EVM run of a script give the same state and events (4.7) |

## 6. Kernel route

bridge-lang has the CCHM kernel of orbit-lang (Path, `transp`, `hcomp`,
Glue, `ua`, HITs, QITs, HIITs, QIITs, fold and unfold), the R1 narrowing
and the contract writer. intent-lang S7 (ef5abe8) has the host
`ecrecover`. Both come from the same kit, so their file layout matches
this repo.

Reading (O11, Q8): S2 ports the kernel from bridge-lang and the host
`ecrecover` from intent-lang. It leaves out BN254, ElGamal, the ring
signatures, `Enc`, the pools and the bridge, because R2 asks for the
minimum. The S2 map lists each file that S2 keeps and each file that it
drops.

## 7. The contract

One contract per user: the EIP-7702 delegate of the user account.

| Entry | Caller | Effect |
|---|---|---|
| `grant` | `self` (the user sends to the own account) | stores the mandate (with `policyVerifier` and `policyId`), `spent = 0` |
| `revoke` | `self` | sets `revoked` |
| `check` | any (view) | decodes the spend, returns 0 or the refusal code of 4.8; when `policyVerifier` is not 0, a STATICCALL of the verifier (4.9); no state change |
| `execute` | any (the agent or a facilitator) | `check` (with the verifier call), marks `sid` used, adds `total c` to `spent`, `pay token merchant (total c)`, emits `Spent(sid, cartHash, total)` |

The x402 route (Q3 (a)): the facilitator runs `check` by `eth_call` in its
verify step. Its settle step sends `execute`. So the facilitator needs no
user key, and a facilitator that skips its own check still cannot move
tokens that the mandate does not allow. Size and gas rows per entry
(EIP-170, EIP-3860) come in the contract slice. The Merkle depth bounds
the gas of `check` (O15). The gas row of `check` includes the verifier
call (S9).

## 8. Tests

- Guest files: the mandate example, one refusal row for each guest type
  error of 4.8, evals for each law of section 5.
- `langc run` scripts: one script per attack of the brief (4.2, 4.3, 4.5)
  and one honest spend, on the guest evaluator.
- The differential: the same scripts on the guest evaluator and on geth
  `evm`, with the mock token of the kit.
- The `ecrecover` rows: EIP-712 digests and signatures, host against
  `evm`.
- The policy rows (S9, 4.9): the mock verifier on the guest evaluator and
  on `evm`; the `NO_POLICY` rows; the row with the real verifier after
  zkpolicy-lang P10 and the mandate instance of 4.9, including a valid
  proof of denial that must give `NO_POLICY`.

## 9. Slices

| Slice | Content | Status |
|---|---|---|
| S0 | Seed: the template with the tcc-evm-contract host, the design verbatim, this plan, the kit gate GREEN, the private remote | DONE |
| S1 | USER rulings on the questions of section 11; record them; read arXiv 2609.11757 and check the attack mapping (O4); plan the zkpolicy condition (Q10 (b), 4.9) | DONE |
| S2 | Kernel port (section 6); the gate counts of the source | DONE: from bridge-lang 174f975 and intent-lang ef5abe8; 387 source files: KEEP 291, ADAPT 23, DROP 73, plus 5 new files (field.c/h, secp256k1.c/h, secptool.c); src 36 to 32 files (15600 to 13733 lines), test 295 to 242 (6621 to 5017), examples 53 to 42 (3226 to 2255); gate EXIT 0: examples 52 to 41, check refusals 188 to 168, kit-only refusals 22 to 19, evals 277 to 136, lower refusals 16 to 15, precompile steps 128 to 11, runs 5, mock 13 rows, diff 15 rows; the prove, contract, ring and differential rows are cut; O32 to O56; Q-S2-1 to Q-S2-4 OPEN |
| S3 | R1 in this repo: `REFUSE_CELL`, the former matrix as CM and CC rows, `Bag` with `swap` | DONE (2026-10-24): base 9a1fc6c, tree df9ac214 (O57); `REFUSE_CELL` HAVE (src/front/check.c, test/fronttool.c); formers/FORMERS.md section 5 has the CM row (`Bag`, `FreeMon`) and the CC row (`Stream`); `Bag` HAVE, `bagComm` is the swap (O59); new check row test/check/cart-cons-swap.lang REFUSE_DATA (O61); gate EXIT 0: examples 41, parse refusals 19, check refusals 169 (168 + 1), kit-only refusals 19, evals 136, run refusals 10, builds 3, lower refusals 15, checks 32; O57 to O61; Q-S3-1 and Q-S3-2 OPEN; Q-S2-1 to Q-S2-4 stay OPEN |
| S4 | Base signature: `Hash`, `Sig`, `signer`, EIP-712 digests, `Env` `chainid` and `self`, the byte form of `keccak` (O12) | DONE (2026-10-24): base 68efac0. `Env` `chainid` and `self` (CHAINID, ADDRESS); `hash712`, `hash3` and `hash4` (Q-S4-1 (a), O67); `Hash`, `Sig`, `signer` and `signedAs` (examples/precompile.lang); `mailHash` gives the struct hash of the EIP-712 Mail example by `hash3` and `hash4`; formers/FORMERS.md F16 to F19 and the Fin kit note (Q-S3-1 (a); the bridge-lang section 5 has no F16 to F19 rows); gate EXIT 0: evals 144, precompile 19 steps; O61 stays OPEN; O62 to O67 |
| S5 | `Mandate`, `Listing`, `View`, `Prov` (Merkle path), `Line`, `Cart`, `cartHash`; the provenance refusals | DONE 2026-10-25 (s1 kickoff 2026-10-24; s1 DONE 2026-10-24 without `merkle2V`, gate counts examples 41, check refusals 171, evals 148, precompile 21 steps, the other S4 counts the same; Q-S5-5 RULED (b); s1b DONE 2026-10-25: `flagIf` is the word select (O79), `side` lowers, 3 `merkle2V` rows (O80), gate counts precompile 24 steps, the other s1 counts the same; s2 DONE 2026-10-25: `Mandate`, `View`, `Session`, `Line`, `Cart`, `cartHash` and 4 guest refusals (PATH_END), Q-S5-6 RULED (a) (the sorted `List`), Q-S5-7 RULED (a) (`def Le`), gate counts check refusals 175, evals 154, the other s1b counts the same, O81 to O84): base 65527a8; three sessions: s1 `Listing`, `listingHash`, `merkle`, `Prov`, `Signed`, `View`; s2 `Line`, `Cart`, `cartHash`, `Mandate`; the close; Q-S5-1 to Q-S5-4 RULED (a); O68 to O84; close DONE 2026-10-25: gate EXIT 0 (mandate-lang-work/S5-close-gate.log), the s2 counts: examples 41, parse refusals 19, check refusals 175, kit-only refusals 19, evals 154, runs 6, run refusals 10, asmtool 8 of 8, builds 3, lower refusals 15, checks 32, dispatch 20, evm steps 43, precompile 24 steps, mock 13 rows, diff 15 rows, emit 24 |
| S6 | `Session`, `Cred s`, `Confirmed`, `Gate`, `Spend`; `IO` and its operations; the run scripts | DONE 2026-10-25, STAGED (the close: 8 of 8 mutants KILLED, M1 after the new wrong-OP run row of the USER ruling (a); the host README run output text; gate GREEN, run refusals 14, the other counts the s2 part 3 counts; O106 and O107); s2 part 3 DONE 2026-10-25 (O102 to O105: the answer form of `langc run` (the role ROLE_IO, the code RUN_ANSWER), the IO entries `askWord` and `askConfirm`, the run rows; gate GREEN, runs 6, run refusals 13, the other counts the s2 part 2 counts); s2 part 2 DONE 2026-10-25 (O98 to O101: the Flag elim, the `Sig` response of `confirm`, the guest defs `show`, `lookup`, `confirm` and `submit`; gate GREEN, check refusals 182, evals 165; Q-S6-7 (a) and Q-S6-8 (a) RULED); s2 part 1 DONE 2026-10-25 (O95 to O97: the R1 field rule, `IO` in domain/domain.lang, 3 domain rows; gate GREEN, the s1 counts); s1 DONE 2026-10-25 (O90 to O94; gate GREEN, check refusals 179, evals 163, precompile 27 steps); base 0fb3760 (O85); `Session` HAVE from S5 s2 (O81); probes O86 to O89; Q-S6-1 (a), Q-S6-2 (a), Q-S6-3 (a) and Q-S6-4 (b) RULED; Q-S6-5 (a) and Q-S6-6 (a) RULED in s1; four sessions: s1 the kit op `u256Mul`, `Lt`, `total`, `Cred s`, `Confirmed`, `Gate` (a `Sum`), `Spend`, the test-key mandate, the refusal rows; s2 part 1 the R1 field rule and `IO` in domain/domain.lang; s2 part 2 the Flag elim and the guest defs of the operations; s2 part 3 the answer form of `langc run`, the run rows; the close; kickoff gate EXIT 0 with the S5 counts |
| S7 | `Machine`; the contract of section 7; the decoder; the differential; gas and size rows | DONE 2026-10-26, COMMITTED 11f166e (the close O144: the final gate EXIT 0; the mutants 25 of 25 KILLED in s2, O140): base 17d50a4; the sessions s1 to s4 (O110); Q-S7-1 to Q-S7-4 RULED (a); s1 DONE (O119 to O128); s2 part 1 (O129 to O131); s2 resume 1 (O132 to O133); s2 resume 2 (O134); s2 resume 2b (O135 to O136); s2 resume 2c (O137); s2 resume 2d (O138); s2 resume 2e and 2f (O139); s2 resume 3 to 5 (O140), s2 DONE; Q-S7-9 and Q-S7-10 RULED (a); s3 part 1 (O141) DONE; s3 resume 1 (O142) DONE; s3 resume 2 (O143), s3 DONE; s4 the close (O144), S7 DONE |
| S8 | The attack corpus: the three attacks of the paper (G1 in the paper form, Q-S1-5; one row for each of the five forms of G2, Q-S1-6; G3 below and above `autoLimit`, Q-S1-7), the honest spend, the residual of 4.5; the x402 route | DONE 2026-10-26, STAGED (the close O170: the final gate EXIT 0, O169; base fb2e68e; s1 DONE 2026-10-26, COMMITTED 5bde71b, O152 to O158, Q-S8-5 RULED (a); s2 DONE 2026-10-26, COMMITTED fb2e68e, O159 to O165; s3 DONE 2026-10-26, O166 to O170; kickoff 2026-10-26: the sessions s1 to s3, O146; Q-S8-1 to Q-S8-4 RULED (a)) |
| S9 | zkpolicy condition (4.9): `PolicyOk`, `PolicyProof`, the `prove` operation, the STATICCALL kit op (O12), the mock verifier, the `NO_POLICY` refusal rows, the differential rows with the mock; the row with the real verifier is BLOCKED on zkpolicy-lang P10 and the mandate instance of 4.9 (field encoding, cart binding, approving decision) | DONE 2026-10-26, STAGED (the close O206: the final gate EXIT 0, O205; base dcf6fc8; kickoff 2026-10-26: O171 to O179, Q-S9-1 to Q-S9-4 RULED (a); the sessions s1 to s4, O179; s1 DONE 2026-10-26, COMMITTED f972a4f, O180 to O188; s2 DONE 2026-10-26, COMMITTED 97c8a8a, O189 to O194, Q-S9-5 and Q-S9-6 RULED (a); s3 DONE 2026-10-26, COMMITTED dcf6fc8, O195 to O202, Q-S9-7 RULED (a), Q-S9-8 to Q-S9-13 default (a) taken; s4 DONE 2026-10-26, O203 to O206, Q-S9-14 and Q-S9-15 default (a) taken; the row with the real verifier BLOCKED, O178) |
| S10 | Mutants and close | IN PROGRESS (kickoff 2026-10-27: O207 to O213, the fresh gate EXIT 0, O208; base 0703e66; Q-S10-1 to Q-S10-4 RULED (a); the sessions s1 to s3, O212; the row with the real verifier BLOCKED, O178) |

## 10. Open items

- O1: the name mandate-lang. Builder call.
- O2: the kit hosts/tcc-evm-contract; `pay` is an ERC-20 `transfer` with
  the contract as the sender. Builder call.
- O3: the reading of R1 (section 2), as intent-lang ruled it. Q1. RULED
  (a) 2026-10-24.
- O4: the attack model. S1 read arXiv 2609.11757 v1 (Y. Louck, A. Dvir,
  A. Stulman, "Signing the Transaction but Not the Decision: Whisper
  Attacks and a Binding Defense for AP2", 2026-09-10): the abstract page
  and the HTML text, characters 0 to 100000 of 166062 (S1 did not read
  the rest). The defense of the paper, A-VIP, binds each credential lookup
  to the session that asked for it and each cart line to the listing that
  the user saw. It shows the third attack to the user for a confirmation.
  This agrees with the brief. The paper says that the three rates do not
  form a ranking on one base: G3 uses another model, and on G3 the model
  of G1 and G2 scored 23.3%. Builder call.

  | Attack (paper) | Mechanism | Rate (setting) | PLAN |
  |---|---|---|---|
  | G1 Vault Whisper | Merchant text makes the agent call the payment-method lookup with the email of another user. The payment alias of that user enters the agent context, before a cart exists. | 90% (95% CI 78.6 to 95.7), gemini-2.5-flash-lite, 50 trials, measured at the tool call | 4.3 session credential (O23) |
  | G2 Branded Whisper | Merchant text makes the agent build a cart with lines, prices or a payee that the user did not see (five forms: promote, demote, add an unrequested item, increase a price, change the payee). The merchant signs the cart, and it stays valid. | 56% (95% CI 42.3 to 68.8), gemini-2.5-flash-lite, 50 trials, measured at the signed cart | 4.2 provenance (O24) |
  | G3 Selection Whisper | A factual claim (the cheaper item is discontinued) makes the agent select the more expensive item from listings that the user saw. The cart agrees with the listing, so it has no structural trace. | 73.3% (95% CI 63.4 to 81.4), gemini-3.1-flash-lite, 90 trials | 4.5 confirm (O25) |

  The paper differs from the brief in O23 to O26. Q-S1-5 to Q-S1-7 are
  RULED (a) 2026-10-24, and 4.3 and 4.5 record them.
- O5: IO is the free CM of the payment operations, not the interaction
  tree of agent-lang (4.6). Q2. RULED (a) 2026-10-24.
- O6: the target: one EIP-7702 delegate with `check` for x402
  facilitators (section 7). Q3. RULED (a) 2026-10-24.
- O7: the view: one Merkle root over the listings that the user saw or
  approved, with `maxQty` in each leaf (4.2). Q4. RULED (a) 2026-10-24.
- O8: the credential: a vault key apart from the agent key (4.3). Q5.
  RULED (a) 2026-10-24.
- O9: the gate: `autoLimit` over all spends of the mandate (4.5). Q6.
  RULED (a) 2026-10-24.
- O10: the token: one ERC-20 per mandate. Q7. RULED (a) 2026-10-24.
- O11: the kernel route (section 6). Q8. RULED (a) 2026-10-24.
- O12: kit additions: `Env` `chainid` and `self`; a byte form of
  `keccak`, because the EIP-712 digest hashes the two bytes 0x19 0x01
  before two words. Q9. RULED (a) 2026-10-24. S1 adds one more (Q10 (b),
  4.9): an external STATICCALL for the policy verifier, with words and
  calldata bytes in and one word out. Today the kit calls only the token
  (`pay`, `pull`).
- O13: zkpolicy-lang proves that an agent followed a policy. Q10. RULED
  (b) 2026-10-24: section 4.9 adds a zkpolicy-lang proof as the factor
  `PolicyOk` of `Spend`, and slice S9 builds it.
- O14: the indexed families have no type parameter, so R1 does not limit
  them (2.2). Builder call.
- O15: the Merkle depth is at most 8 (256 listings in one view). S7
  measures the gas and can change the bound. Builder call. S7 s3
  (O143): the bound 8 stays.
- O16: one spend per session number (`used` is a `Map U256 U256`).
  Builder call.
- O17: `price * q`, `total` and `spent + total` refuse an overflow; `cap`
  stays below `2^128`. Builder call.
- O18: an x402 route in which the token calls ERC-1271
  `isValidSignature` on the user account (EIP-3009 with a contract
  signature) is NOT verified for any token. S8 checks it. Until then the
  x402 route is `check` plus `execute`. Builder call.
- O19: `.gitignore` ignores `.kanon-exec/` and `.kanon-wait/`
  (bridge-lang O19). Builder call.
- O20: "your EVM toolkit" is read as the tcc-evm-contract kit, the geth
  `evm` differential and the host `ecrecover`. kan-evm (Lean) is not
  used. Builder call.
- O21: residual of A1: steering among listings that the user saw, within
  `maxQty`, is not refused. The `autoLimit` bounds it (4.5). Builder call.
- O22: the Chainalysis figures of the brief are context. The builder did
  not check them. Builder call.
- O23 (paper, G1): G1 is a lookup of the credential of another user (by
  the email of that user), measured at the tool call, before a cart
  exists. 4.3 reads attack 1 as the use of a credential in another
  session. The paper form is also stopped if `lookup` takes only the
  session (no user identifier) and the vault answers only for the
  sessions of its own mandate. A-VIP binds a single-use token to the
  session, the cart hash, the merchant, a nonce and an expiry, at the
  credentials provider. `Cred s` binds the session, the merchant and the
  view root. One spend per session (O16) makes it single-use. `Cred s`
  does not hold the cart hash: the checks of 4.2 limit the cart. Q-S1-5.
  RULED (a) 2026-10-24.
- O24 (paper, G2): G2 has five forms. 4.2 refuses three of them: a
  changed price (the price comes from the leaf), a changed payee
  (`WRONG_MERCHANT`) and a listing that is not in the view (`NO_PATH`).
  It does not refuse an unrequested item, or a promoted or demoted item,
  when the listing is in the view (Q4 (a): the view holds the listings
  that the user saw or approved). `autoLimit` and `maxQty` limit the loss,
  as in O21. So for these two forms the brief ("the paper's two fixable
  attacks into type errors") holds only when the view holds no
  unrequested listing. Q-S1-6. RULED (a) 2026-10-24.
- O25 (paper, G3): the A-VIP rule asks for a confirmation when the cart
  price is more than the price of the cheapest catalog item that meets
  the category and the hard constraints. It asks for no confirmation when
  the intent states a budget. 4.5 (Q6 (a)) asks above `autoLimit`. Each
  mandate states a budget (`cap`), so the paper rule would never ask in
  mandate-lang. The paper says that its rule "mitigates the attack but
  does not eliminate it", as O21 says for 4.5. Q-S1-7. RULED (a)
  2026-10-24.
- O26 (paper): AP2 signs its mandates with ECDSA P-256. mandate-lang
  signs its own EIP-712 forms with secp256k1 (`ecrecover`). It does not
  verify AP2 mandates. Builder call.
- O27 (Q10 (b)): the public part of zkpolicy-lang. Its N3 (RULED
  2026-10-15): `ZKProof : Policy -> Field public -> Transcript -> Type`,
  and an instance chooses `Field public`. The two gaps of 4.9 (the field:
  BabyBear in P9, BN254 on the EVM; the binding of `cartHash` to the
  context) need a zkpolicy-lang slice. Q-S1-4. RULED (a) 2026-10-24: the
  request stays in this plan, and zkpolicy-lang does it in its own slice.
  That instance must also enforce an approving decision by the pinned
  policy (4.9); accepting a valid proof alone is insufficient.
- O28 (Q10 (b)): the fifth IO operation `prove s c`, answered by the
  policy prover (4.6, 4.9). Without it a guest program cannot make a
  `PolicyProof` term. Builder call.
- O29 (Q10 (b)): the call form of the real verifier (a function selector
  or none, the return data, a revert on a bad proof) is NOT checked. The
  mock fixes one form: no selector, the five words and then the proof
  bytes; it accepts if the call succeeds and returns the word 1. The real
  row changes the kit op if the zkpolicy-lang P10 verifier has another
  form. Builder call.
- O30 (Q10 (b)): the public inputs hold `domain` (`chainid` and `self`)
  in addition to the four words of the S1 draft, so that a proof for one
  user account or one chain does not verify for another. Q-S1-2. RULED
  (a) 2026-10-24.
- O31 (Q10 (b)): the state at S1 (2026-10-24). zkpolicy-lang HEAD
  1d263fb, with two untracked paths of another session (S1 read it only);
  its P10 is not started (its docs/STATUS.md). zkml-lang HEAD 2f53fd4 has
  10 staged files of another session (the Halo2 work of its Z9), not
  committed. Builder call.
- O32 (S1 commit): the USER edit in 7a2dcaa. docs/PLAN.md +36 -10 against
  the staged S1 tree 0794773c: a valid proof alone does not authorize a
  spend; the verifier must also enforce an approving decision of the
  pinned policy (4.9, 5, 8, the S9 row, O27). USER.
- O33 (S2, Q8 (a)): the leave-outs. S2 drops ElGamal (elgamal.c/h,
  elgamaltool.c), `Enc` and the encrypted tally, the pools (test/pool) and
  the bridge domain (test/bridge): 11 examples, 20 check files and their
  rows in all. Q8. RULED (a).
- O34 (S2): the contract writer is dropped: writer.c/h, writertool.c,
  test/contract/, test/prove/, `langc prove`, `langc contract` and
  `prove_command`. Its cast is `zkVerify ring` (bLSAG), so it needs the
  leave-outs. The mandate contract writer comes in S7. Q-S2-1.
- O35 (S2): the kit S0 sample files examples/inventory.lang and
  test/check/domain-name.lang are removed. The bridge domain has no kit
  sample (sealed-lang S2 R21), so they cannot pass. S2 does not put their
  rows back. Builder call.
- O36 (S2): the ZK surface of orbit-lang S8 B2b is dropped: `OP_ZK_*`,
  `RULE_ZK_*`, `ZKWitness`, `proveZK`, `verifyZK`, `Ballot_priv`,
  `castPrivate` and the kernel/zk.lang splice. The policy proof surface
  comes in S9 (4.9). Q-S2-2.
- O37 (S2): the BN254 precompile ops `ecAdd`, `ecMul` and `ecPairing` are
  dropped: core.h `OP_EC_*`, eval.c `ec_op` and `closed_point`, lower.c
  `is_curve` and the pairing list, the base-ec and pairing check files,
  test/lower/pairing-open.lang. `lower_curve` lowers `ecrecover` only
  (precompile address 1). Builder call.
- O38 (S2, Q8 (a)): bLSAG is dropped: blsag.c/h, blsagtool.c, the ring
  contracts and examples/ring3.lang. Q8. RULED (a).
- O39 (S2): the field split. src/front/field.c/h hold the generic `Fe`,
  `Modulus` and `ec0` layer of intent-lang ef5abe8 bn254.c (`G1` is now
  `EcPoint`, `BN_LIMBS` is now `FE_LIMBS`, `fe_from_u64` stays).
  bn254.c/h are gone. secp256k1.c needs this layer only. Builder call.
- O40 (S2, Q8 (a)): the host `ecrecover` of intent-lang ef5abe8:
  secp256k1.c/h, test/secptool.c, the Makefile `SECP_TOOL`, and eval.c
  `recover` (closed arguments by `secp_recover`). Q8. RULED (a).
- O41 (S2): an error in the builder prompt S2-s3 (item 2): the ef5abe8
  hunks check.c +18, the 2 kit.txt lines and fronttool.c +12 are
  `ZKProof` and one-hot rows, not `ecrecover`. S2 does not port them.
  Builder call.
- O42 (S2): fronttool.c `law_guest` keeps its test-local sealed family
  (`Enc`, `decrypt`). It tests the law checker, not the `Enc` surface.
  Builder call.
- O43 (S2): lowertool.c loses its 2 precompile-failure rows (`ecAdd`).
  Precompile 1 does not make the STATICCALL fail, so no surface op gets
  to the revert path of lower.c. Q-S2-3.
- O44 (S2): the ef5abe8 `ecrecover` tests are ported: `signedBy`,
  `recoverGood` and `recoverBad` in examples/precompile.lang and 2 expect
  rows. precompile.lang goes from 83 to 54 lines (the BN254 views are
  cut). Builder call.
- O45 (S2): the header comments of examples/precompile.lang and
  test/precompile.sh no longer name the BN254 ops. Builder call.
- O46 (S2): test/gate.sh goes from 314 to 135 lines: the prove, contract,
  ring and guest differential blocks are cut. test/precompile.sh goes
  from 214 to 75 lines: the curve, `zkcast`, contract and EVM
  differential blocks are cut. The differential of section 8 comes in S7.
  Builder call.
- O47 (S2): test/run.sh goes from 117 to 71 lines: the host differential
  (14 host runs at the source) is cut. Builder call.
- O48 (S2): test/abi.expect loses the usage lines of `langc prove` and
  `langc contract` (main.c lost both commands, O34). Builder call.
- O49 (S2, trap): a stale build/domain.c (its mtime newer than
  domain/domain.lang, with a domain that has `lineTotal` and `natMul`)
  made each `langc` call fail with `NAME_UNKNOWN`. `rm build/domain.c`
  and a build fixed it. The cause is not known. A build with EXIT 0 does
  not show it, so run one `langc` call after each build. Builder call.
- O50 (S2): examples/ring3.lang (a private bLSAG ballot ring) was not in
  the borderline list of the builder prompt S2-s3. S2 drops it (O38).
  Builder call.
- O51 (S2): the `REFUSE_SIG` rows of the ZK names `ZKWitness` and
  `proveZK` went with the surface (O36), so the check files
  sig-primitive, sig-primitive-op and zk-redefine have no refusal to
  show. Builder call.
- O52 (S2): S2 drops 5 check files (sig-primitive, sig-primitive-op,
  zk-redefine, zk-flip with `Ballot_priv`, attest-wrong with a Schnorr
  check on `ecMul`) and examples/ring3.lang, with their rows: the eval
  rows `dao w0`, `dao c0`, `ring3 w` and `ring3 c`. Builder call.
- O53 (S2): examples/dao.lang keeps the DAO prelude (`Config`,
  `Constitution`, `Aggregation`, `Tally`, `gov`, `amend`, `Orbit`) as
  kernel text, without the private ballot (`b0`, `w0`, `c0`,
  `complete`). Q-S2-4.
- O54 (S2): the open word of test/lower/path-word.lang is now
  `addrToU256 (ecrecover x 27 x x)` in place of an `ecAdd` word. The row
  is still `REFUSE_LOWER` (K4c does not lower `hcomp` at a word
  position). Builder call.
- O55 (S2): the gate time. `make -j 2 check` takes 89 s (S2 s7) and
  170 s (S2 s8, other work on the machine), against 450 s at the source.
  The build checks go from 33 to 32; S2 did not find which check went.
  Builder call.
- O56 (S2): test/gate.sh had two refusal loops over test/pool and
  test/bridge (0 rows after O33) that named the dropped examples
  pool.lang and bridge.lang. S2 cuts them. Builder call.
- O57 (S3 Step 0): the USER S2 commit 9a1fc6c has the tree df9ac214, not
  the staged tree e6ceed7e. 6 files are different: src/front/check.c
  (INTERVAL_TYPE: I is a separate sort, rule R9), src/front/eval.c
  (val_isubst_mode: a Glue line keeps its presentation under a face map),
  test/pathtool.c (82 new lines), test/fronttool.c (33 new lines),
  test/check/expect.txt (face-sort.lang gives INTERVAL_TYPE) and
  test/gate.sh (the dash scan has no DESIGN.md exclusion). The bridge,
  intent, orbit, virtu, resolve, restrict and agent kits have the same
  fix. The gate gives EXIT 0 on HEAD. USER ruling 2026-10-24: accept.
- O58 (S3): formers/FORMERS.md has F1 to F15 only. bridge-lang has F16 to
  F19 (dependent eliminator, Glue and univalence, HIIT, QIIT) and a Fin
  kit note, and the port has these parts of the kernel. Q-S3-1.
- O59 (S3): PLAN 4.4 names a `swap` path constructor. In a cell
  signature the type parameter occurs in the generator only, so a list up
  to a swap (`swap x y xs`) is not a cell signature. The swap of the cell
  form is `bagComm` (`bagOp x y = bagOp y x`). Q-S3-2.
- O60 (S3): the CC row names `Stream` only. `Machine` (PLAN 4.7) is not in
  domain/domain.lang. It comes with the checker slice.
- O61 (S3): a program cannot declare a family (REFUSE_DATA), so
  REFUSE_CELL occurs only for domain text. test/check/cart-cons-swap.lang
  gives REFUSE_DATA. A test/fronttool.c row with this cart in domain text
  would give REFUSE_CELL. S3 did not add it. Builder call.
- O62 (S4): the guest run has no script field for `chainid` and `self`.
  make_env uses the `evm run` defaults: the chain 1337 and the address of
  the bytes "receiver". The chain gate test/precompile.sh uses the
  prestate config of test/evmchain.sh, which sets the chain id 1; the
  receiver is the same address. Each side compares with its own constant
  (test/run/precompile.out 1337u, test/precompile.sh 1). A script
  directive can come later.
- O63 (S4): the v of `Sig` is a `Nat` (the v of the kit `ecrecover`), not
  a `U256`. Section 3 now says `Nat * U256 * U256`.
- O64 (S4): the EIP-712 domain separator and the struct hashes of 4.8
  need keccak256 of 3 or 4 words; `hash` takes 2, and `hash (hash a b) c`
  is a different word. Q-S4-1 RULED (a): `hash3` and `hash4` (S4 s3).
- O65 (S4): KECCAK712 writes 2 bytes past the 2-word scratch into the
  first PRECOMPILE output block; src/evm.c saves and restores that word.
  A 3-word scratch moves every output block (the byte gates change).
- O66 (S4): no doc lists the guest ops (`rg -n -w hash docs` finds
  docs/PLAN.md only). S4 adds `hash3` and `hash4` and does not add an op
  list. A later slice can add the list to docs/host/README.md.
- O67 (S4): the IR ops are binary. `hash3` lowers to IR_OP_KECCAK3 with an
  IR_OP_PAIR right operand, and `hash4` lowers to IR_OP_KECCAK4 with 2
  IR_OP_PAIR operands. A PAIR leaves 2 words on the stack and is not a
  value. KECCAK3 and KECCAK4 write 1 and 2 words past the 2-word scratch;
  they save these words and store them again after the SHA3 (as O65).
- O68 (S5): the kit has no U256 div, mod or shift. The word ops are
  `u256Add`, `u256Sub`, `u256Eq` and `u256Le`. `natDiv` and `natMod` are
  on `Nat`. Q-S5-1 RULED (a): the `Prov` index is `i : Nat`.
- O69 (S5): `elim` on `Nat` is refused (TYPE_MISMATCH: the motive must be
  on `Sum A B`, `Unit` or a domain family). The side bit of a Merkle step
  uses the `Nat` fold: `fold (fun (x : Hash) => hash s h) (hash h s) b`
  gives `hash h s` when `b` is 0 and `hash s h` when `b` is 1.
- O70 (S5): the `List` fold does the end of the list first: `fold f z
  (cons a (cons b nil))` is `f a (f b z)`. So `sib` of `Prov` lists the
  siblings from the root down, and the sibling of the leaf is the last
  element. The probe: mandate-lang-work/S5-merkle-probe.lang.
- O71 (S5): the checker decides `Path Hash` by computation. `refl` checks
  when the two words are equal. A wrong sibling gives PATH_END ("the path
  at i1 is X, but the type needs Y"). So the guest refusal of a `Prov` for
  a listing that the user did not see is PATH_END.
- O72 (S5): section 3 calls `Mandate` a record, but a program cannot
  declare a family (REFUSE_DATA). So `Mandate` is a right-nested `Prod` of
  the 11 fields, with accessor defs (`owner`, `agent` and the others) by
  `first` and `second` (s2).
- O73 (S5): a map out of `Bag` must respect `bagComm` (4.4). `cartHash`
  hashes the lines in strictly increasing order of `listingHash l`. The
  guest form of this map is open for s2 (a Q-S5-n if the PLAN does not fix
  it).
- O74 (S5 s1): the S5 defs are in examples/precompile.lang, the
  contract of test/precompile.sh, next to `Hash`, `Sig`, `signer` and
  `signedAs`. There is no examples/mandate.lang in s1.
- O75 (S5 s1): `Mandate` comes in s2, so s1 has `ViewAt d a n` with the
  viewer `a` and the mandate id `n` as words. In s2, `View d m` is `ViewAt
  d (viewer m) (id m)`. The kit has no implicit arguments, so `root` and
  `Prov` also take `d a n`: `Prov d a n v l = ProvAt (root d a n v) l`.
- O76 (S5 s1): test/check has no prelude (test/gate.sh `refusals
  test/check check`). So prov-wrong-sibling.lang and view-wrong-viewer.lang
  repeat the S4 and S5 defs (lines 88 to 103 of examples/precompile.lang
  and the S5 block).
- O77 (S5 s1): `merkle2V` gives REFUSE_LOWER (K4c does not lower the Nat
  fold of `side` at a word position). The kit has no word select and no
  word multiply. Q-S5-5 RULED (b): a word select op in s1b.
- O78 (S5 s1): the precompile gate runs with the chain id 1 (`chainWord`),
  and the guest run of the checker uses 1337 (src/front/check.c). So
  `demoDomain` uses 1337 and the `domainWord` row uses 1.
- O79 (S5 s1b): the kit has a word select. `flagIf` takes any result
  type (rule_flag_if, src/front/check.c), and lower_if_value
  (src/lower.c) lowers it at a word position as an IF that sets one
  local in each branch (the arms are lazy). So s1b adds no op: `side b h
  s = flagIf (natEq b 0) (hash h s) (hash s h)` replaces the Nat fold of
  O69. O77 is wrong on the select; the kit has no word multiply. The
  eval rows demoListingHash, demoRoot, demoRoot2 and demoSigner do not
  change. The two test/check files of O76 have the new `side`.
- O80 (S5 s1b): `merkle2V` is back in examples/precompile.lang and has
  3 rows in test/precompile.sh (21 to 24 steps): the index 1, the index
  2 and the demo leaves (WANT = demoRootHex). The WANT words are from
  direct evm keccak runs (mandate-lang-work/S5-s1-vectors.txt). Gate log
  mandate-lang-work/S5-s1b-gate.log EXIT 0. O66: s1b adds no guest op.
- O81 (S5 s2): `Listing` has the accessor `merchant`, so the `Session`
  accessors are `sid`, `smerchant` and `sview` (section 3 says `merchant`
  and `view`). The kit has no implicit arguments, so `View d m`, `Session
  d m`, `Line d m s` and `Cart d m s` take the domain word `d` (as O75).
  The second part of a Sigma is `payload` (`lineQty`).
- O82 (S5 s2): the kit has no `Le` or `Lt` former and no `u256Lt`.
  Q-S5-7 RULED (a): `def Le a b` is `Path Flag (u256Le a b) flagYes` in
  examples/precompile.lang. A q over `maxQty` has no path (PATH_END,
  test/check/line-over-max.lang). A strict less is `flagIf (u256Eq k p)
  flagNo (u256Le k p)` (`canonStep`). `Spend` (4.1) also needs `Lt now
  (expiry m)`; a later slice can add `def Lt` in the same form.
- O83 (S5 s2): Q-S5-6 RULED (a). The guest `Cart d m s` is a `List` of
  lines and a path from `canonical` to `flagYes`: the listing hashes
  strictly increase. The `Bag` of 4.4 is the quotient, and this list is
  its one form. The guest text has no map out of `Bag`: the fold over the
  `Bag` block needs a case for `bagAssoc`, `bagComm`, `bagUnitL` and
  `bagSquash`, and the checker decides a `Path` by computation only, so a
  commutative step on open words has no path. The wrong order and one
  listing on two lines give PATH_END (test/check/cart-not-canonical.lang,
  test/check/cart-same-listing.lang), NOT_CANONICAL on the chain. A wrong
  merchant gives PATH_END (test/check/line-wrong-merchant.lang),
  WRONG_MERCHANT on the chain.
- O84 (S5 s2): `lineHash x` is `hash (listingHash l) q`, and `cartHash c`
  is the `List` fold of `hash` over the line hashes from `0u`. The fold
  does the end first (O70), so the cart of the lines x1 and x0 gives
  `hash (lineHash x1) (hash (lineHash x0) 0u)`. The decoder of the
  contract slice must use the same byte form. `cartHash` takes a `Cart`
  (lines with proofs), not words, so test/precompile.sh has no `cartHash`
  row (24 steps). The evals `demoLineHash` and `demoCartHash` are equal to
  direct evm keccak runs (mandate-lang-work/S5-s2-vectors.txt). Gate log
  mandate-lang-work/S5-s2-gate.log EXIT 0. O66: s2 adds no kit op; the
  new guest defs use `pack`, `witness`, `payload`, `fold`, `flagIf`,
  `u256Le`, `u256Eq`, `natAdd`, `natEq` and `hash`.
- O85 (S6 kickoff): the USER commit 0fb3760 (subject `Add the S5
  mandate, provenance, view, line and canonical cart`, parent 65527a8)
  has the tree 26b848f1, not the staged tree 41e518be. The one change: the
  last blank line of this plan is not in the commit. The USER accepted
  0fb3760 as the S5 base. Gate mandate-lang-work/S6-step0-gate.log EXIT
  0, the same 48 sorted lines as the S5 close log.
- O86 (S6 kickoff, probe a): a program cannot declare a family
  (REFUSE_DATA), so `IO` goes in domain/domain.lang. In a scratch copy of
  the repo, the first-order `io3Op (o : Op) (k : IO3 A)` is admitted
  (probe a3). The field `Op -> IO1 A` gives REFUSE_CELL (probe a1): a field
  that holds the family must be the family at its own parameters. Probe
  a2 (`Resp o -> IO2 A`) did not run, because make kept the a1 binary (the
  mtime trap); its field has the form of a1. domain/domain.lang cannot
  name a guest type such as `Cred s` or `View d m`. R1 admits a field into
  closed data (OrbitN has `Pos onSize -> Sum Unit Unit`). Q-S6-1 RULED (a).
- O87 (S6 kickoff, probe b): `Cred d m s` is `Signed d (vault m) (hash4
  credType (sid d m s) (addrToU256 (smerchant d m s)) (root d (viewer m)
  (id m) (sview d m s)))`. The S5 trick holds: with demoSig the vault is
  the recovered address 0xb795772b56ccec30569ccbabb05d58e77c652241, and
  `pack demoSig refl` checks. The same credential at sid 10u gives
  PATH_END (WRONG_SESSION on the chain). The probe `credType` is a
  placeholder word. The probes use `langc --kit`, because
  examples/precompile.lang has `State` and `Nat` (REFUSE_KIT in the guest
  mode).
- O88 (S6 kickoff, probe c): `Confirmed d m s c k` is `Signed d (viewer
  m) (hash4 confirmType (sid d m s) (cartHash d m s c) k)`. A Flag-select
  `Gate` (one Sig and a path of `flagIf (u256Le (u256Add spent total)
  (autoLimit m)) flagYes (signedAs ...)` to `flagYes`) checks below the
  limit with any Sig, and gives PATH_END above it (demoMandate, autoLimit
  100u). The kit has `u256Add`, `u256Sub`, `u256Eq` and `u256Le`, but no
  `u256Mul`, so the probe `total` adds only the prices (350u, not 450u). A
  closed `Confirmed` needs a viewer key: the viewer of demoView has no
  known key, and one address cannot sign two digests by the S5 trick.
  Q-S6-2 (a), Q-S6-3 (a) and Q-S6-4 (b) RULED.
- O89 (S6 kickoff, probe d): `langc run PROG SCRIPT` reads contract calls
  `NOW CALLER NAME ARGS` (test/run/basic.script). The .out file has a line
  `K NAME ok`, `revert` or `trap` for each call, the `pay`, `pull` and
  `event` lines of the call, and a last `state` line. No script form
  answers an IO operation. S6 s2 adds one (Q-S6-1 (a)). The probe files
  are mandate-lang-work/S6-probe-*.lang, not in the repo.
- O90 (S6 s1, Q-S6-2 (a)): `u256Mul` is a kit op: src/front/core.h,
  src/front/check.c, src/front/eval.c (u256_mul, a trap on an overflow)
  and src/lower.c (IR_OP_MUL_TRAP, which evm.c and test/emittool.c have
  from before). docs/host/README.md has the row. formers/FORMERS.md has
  no kit word table, thus it has no note. Rows: the evals mulGood and
  mulZero (O94), and 3 precompile steps of mulV. A view trap
  on the chain gives the result `trap`, not `revert`.
- O91 (S6 s1): examples/precompile.lang adds `Lt` (Q-S6-6 (a)), `total`,
  `credType` and `confirmType` (`cast keccak` of the type strings),
  `Cred`, `Confirmed`, `Gate` (a `Sum` with `inl` and `inr`, Q-S6-4 (b))
  and `Spend d m spent now k`. The eval of demoTotal is 450u.
- O92 (S6 s1, Q-S6-3 (a)): tMandate has anvil account 0 as the viewer
  and the vault (id 2u, autoLimit 100u). The signatures come from `cast
  wallet sign --no-hash` on tViewDigest, tCredDigest and tConfirmDigest,
  and each signer evals to the test address. tGate is the Confirmed
  side, tGateLe is the Le side (tCartSmall, total 100u), and tSpend
  checks. test/check has 4 new PATH_END rows (cred-other-session,
  confirm-wrong-claim, spend-over-cap, spend-after-expiry). Each repeats
  the part of examples/precompile.lang from `Hash` to the end without
  the views on State or Env (about 21 kB).
- O93 (S6 s1): `PolicyOk` is not in the S6 `Spend` (S9 adds it with
  `prove`, Q-S6-5 (a)). The used session id (O16) is a chain check
  (S7). The claim hash k is an argument of `Gate` and `Spend`.
- O94 (S6 s1): `langc eval` of the closed mulOver prints `trap` with
  exit 0 and no EVAL_OVERFLOW line, thus it has no eval row (the gate row
  of a trap needs that line). test/check/pruned-op.lang named u256Mul.
  It names u256Div now (not a kit op) and stays NAME_UNKNOWN.
- O95 (S6 s2, Q-S6-1 (a)): src/front/check.c admits a strictly positive
  field `D -> F params` in a cell signature. D is closed data: no
  parameter, no earlier field, no universe, and F does not occur in D
  (`self_uses` is 1). FieldInfo has the flag `arrow` (src/front/core.h).
  Such a field is not a recursive field: the fold code gives it as a
  plain field, with no induction hypothesis. No row folds an `IO` yet. A
  field with F to the left of the arrow and a D with a parameter stay
  REFUSE_CELL. The rows are 3 domain rows in test/fronttool.c (`Ask`
  admitted, `NegAsk` and `ParAsk` REFUSE_CELL). The gate prints one line
  for all domain rows, thus the counts do not change.
- O96 (S6 s2): domain/domain.lang has `family IO (A : Type 0)` with
  `ioPure` and the operations `ioShow`, `ioLookup`, `ioConfirm` and
  `ioSubmit`, each with the fields `(xOf : U256) (xNext : U256 -> IO A)`.
  A scratch guest def `ioShow U256 5u (fun (w : U256) => ioPure U256
  (u256Add w 1u))` checks, and `langc --kit eval` prints it (not a row).
  The gate is GREEN with the s1 counts (mandate-lang-work/S6-s2-gate.log).
- O97 (S6 s2): `Sig` is `Prod Nat (Prod U256 U256)` (three words), thus a
  word response cannot hold the signature that `confirm` gets (Q-S6-7).
  The builtin names `Prod` and `Sum` are VIS_GUEST, `Nat` is VIS_INTERNAL.
  A guest def of an operation must also get a path such as `Path Flag
  (signedAs ...) flagYes` from a response that is not closed. s2 part 2
  finds the form (for example a dependent case on the Flag value).
- O98 (S6 s2 part 2, Q-S6-8 (a)): `elim` takes a motive on Flag: the yes
  case, the no case, then the scrutinee. src/front/check.c: elim_case,
  elim_domain (a printed motive: the Flag at the argument position 3) and
  rule_elim. src/front/eval.c reduce_elim: FIELD 0 and INST 2, as at Sum.
  src/lower.c has no `elim` (no change). docs/host/README.md has no
  `elim` row (no note). Rows: the evals flagElimYes (1) and flagElimNo
  (0); the check refusals flag-elim-case.lang and elim-nat-motive.lang
  (TYPE_MISMATCH, kit mode).
- O99 (S6 s2 part 2, Q-S6-7 (a)): the `ioConfirm` field is `confirmNext :
  Prod Nat (Prod U256 U256) -> IO A`. The R1 field rule admits it.
  test/fronttool.c has the domain row `SigAsk` (NULL).
- O100 (S6 s2 part 2): examples/precompile.lang has the guest defs
  `show`, `lookup` and `submit` (`B`, a word `w`, `next : U256 -> IO B`)
  and `confirm R d a g next` (`next : Signed d a g -> IO (Option R)`).
  `confirm` asks for the digest `hash712 d g`. The elim on `signedAs d g
  x a` with the motive `Path Flag (signedAs d g x a) f -> IO (Option R)`,
  applied to `refl`, gives `next (pack x p)` or `ioPure (Option R) none`
  (a revert). A `Confirmed` is a `Signed`. Only `confirm` checks its
  response. The check refusal confirm-no-case.lang (the no case calls
  next) gives TYPE_MISMATCH (kit mode).
- O101 (S6 s2 part 2): `langc run` has no answer form yet (s2 part 3).
  Gate: mandate-lang-work/S6-s2p2-gate.log EXIT 0, 48 sorted lines; check
  refusals 182, evals 165; the other counts are the s1 counts. DONE in s2
  part 3 (O102).
- O102 (S6 s2 part 3, Q-S6-1 (a)): src/front/check.c: the role ROLE_IO is
  an entry with the result `IO (Option (Prod State (List Out)))`. run_call
  evaluates it. io_step prints `K NAME OP WORD` at ioShow, ioLookup,
  ioConfirm or ioSubmit and keeps the operation open. The next script line
  is the answer `OP WORDS` (run_answer: one U256 word, or `confirm V R S`,
  built as `pair V (pair R S)`). The run applies the next field to it. At
  ioPure the entry steps apply (trap, revert, ok and the Out lines). The
  new code RUN_ANSWER (docs/host/README.md): a different OP, a wrong word
  count, or the script ends at an open operation.
- O103 (S6 s2 part 3): examples/precompile.lang has the IO entries
  `askWord` (show, lookup, submit; the receipt goes into the state) and
  `askConfirm` (confirm on the parts of tConfirmDigest with the test-key
  viewer). test/run/precompile.script has the calls 3 to 5. The digest
  that the run shows is the word of `langc eval tConfirmDigest`.
  tConfirmSig gives ok; the same r and s with v 27 give revert.
  test/run.sh has 3 RUN_ANSWER rows.
- O104 (S6 s2 part 3): the run finds the IO operations by the constructor
  names (io_ops in src/front/check.c). A bad answer word gets the code of
  entry_arg, as an entry argument does; no row. The lowering does not
  lower the IO entries (precompile 27 steps and emit 24, the same), so
  the EVM side of IO is open.
- O105 (S6 s2 part 3): gate mandate-lang-work/S6-s2p3-gate.log EXIT 0, 48
  sorted lines. The one change from S6-s2p2-gate.log: run refusals 10 to
  13. Runs 6 (precompile.script has the calls 3 to 5), check refusals
  182, evals 165, the other counts the same.
- O106 (S6 close): mutants in a scratch tree (`make -k -B -j 2 check`),
  8 of 8 KILLED. M1: the OP check of run_answer (the new row of
  test/run.sh, USER ruling (a); the first wrong-OP row ends at an open
  operation, so the end check hid M1). M2: the confirm word count 3u to
  1u (precompile.script). M3: the end check of run_command (the
  open-operation row). M4: ROLE_IO in role_of (EVAL_ENTRY askWord). M5:
  r and s change places in the confirm answer (precompile.script). M6:
  the Flag cases of reduce_elim change places (flagElimYes, flagElimNo).
  M7: u256Mul to OP_U256_ADD (37 rows; the first is PATH_END tGateLe).
  M8: the closed-data test of the arrow field (the ParAsk domain row).
  M8b: CORE_PI to CORE_LAM in the arrow field (412 rows).
- O107 (S6 close): gate mandate-lang-work/S6-close-gate.log EXIT 0, 48
  sorted lines. The one change from S6-s2p3-gate.log: run refusals 13
  to 14. The other counts the same. docs/host/README.md: an IO call has
  one line for each operation, before the line of its result.
- O108 (S6 staged review): the normal form of
  `fun (f : Flag) => elim (fun (x : Flag) => Unit) unit unit f` was
  refused with TYPE_NOT_FUNCTION: the bare motive inferred Unit from
  its second case before inspecting the Flag scrutinee. The checker
  now tries the Flag interpretation first when these positions overlap,
  with fallback for shorter eliminations returning functions. Five C
  roundtrip regressions cover Unit and one-constructor-family results,
  functional Flag results, and applied Unit and family eliminations.
- O109 (S6 staged review): the old `show` and `lookup` passed only raw
  words. An honest `lookup` with a Session and a Cred continuation was
  TYPE_MISMATCH, so neither operation implemented the typed response
  of 4.3 and 4.6. They are now `showWord` and `lookupWord`; the typed
  `show R d m root next` and `lookup R d m session next` assemble a Sig
  from three word responses. Requests are `hash digest tag`, with tag
  0u, 1u and 2u for v, r and s. The digest binds the root and mandate id
  for show, or sid, merchant and view root for lookup. Only v = 27u or
  28u is valid. `checkSig` shares the dependent Flag check with confirm;
  failed recovery reverts before the typed continuation. Five run cases
  cover honest View and Cred responses, a changed root, a changed sid
  and an invalid v. The fifteen request words match independent
  `cast keccak` vectors. Raw constructors remain the wire interface;
  the chain decoder remains the boundary check of 4.8.
- O110 (S7 kickoff): the sessions of S7.
  - s1: `Machine` and `Req` in domain/domain.lang (Q-S7-3), the cocell
    rows and the evals of the guest terms (`eps`, `mStep`, a machine from
    a step function by unfold). When Q-S7-2 is (a): the kit change for an
    entry argument of type `List U256`, its lowering, the `langc run`
    script form, the lower and the build rows.
  - s2: the contract of section 7 (Q-S7-1): the state, `grant`,
    `revoke`, the decoder, the view `check` and `execute`. One refusal
    row for each chain refusal of 4.8 and of O115, but not `NO_POLICY`
    with a verifier call (S9, O117). `langc build` of the contract.
  - s3: the differential (Q-S7-3), the gas rows and the size rows
    (O114), docs/host/CAPABILITY.md and docs/host/README.md.
  - s4: the S7 close: the mutants of the decoder and of each refusal
    row, the gate, the commit message.
- O111 (S7 kickoff, step 0): HEAD 17d50a4 (the USER S6 commit, tree
  4e66bc61, Signed-off-by), the status clean. The fresh gate
  (mandate-lang-work/S7-kickoff-step0-gate.log): EXIT 0, the 48 sorted
  lines the same as S6-close-gate.log. The 8 files of the staged review
  do not change the counts. The USER accepted 17d50a4 as the S7 base.
- O112 (S7 kickoff, survey): the kit contract form. A contract is a
  guest program: a `state` declaration and entries `def e : (env : Env)
  -> (s : State) -> ARGS -> Option (Prod State (List Out))`
  (examples/contract.lang). A view gives one word (C-K4-10). `langc
  build` lowers them (src/lower.c, src/evm.c) with the ABI selector
  dispatch (src/evm.c:97 and :463). The contract writer of bridge-lang
  is dropped (O34, Q-S2-1). examples/precompile.lang has its own state
  (`makeState (sigs : List U256)`) and the entry `sign`. The contract
  prelude (`Env`, `Out`) loads after domain/domain.lang
  (src/front/contract.c:1), thus domain/domain.lang cannot name `Env`.
- O113 (S7 kickoff, survey): an entry argument is a word only (Nat,
  Flag, U256, Addr; src/lower.c:29 and :214), at most 32 of them
  (ENTRY_PARAMS_MAX, src/front/check.h:8). The state can hold a `List`
  and a `Map` of words (FORM_LIST and FORM_MAP, src/lower.c:35 and :36).
  A spend with 1 cart line and a Merkle path of depth 2 needs about 21
  words (the session 3, three signatures 9, the claim hash 1, the line
  8); each more line needs about 8 more words, and more at depth 8. Thus
  a cart of 3 lines, or 1 line at depth 8, does not fit in 32 word
  arguments (Q-S7-2).
- O114 (S7 kickoff, survey and builder call): the size limits exist:
  ASM_RUNTIME_MAX 24576 (EIP-170) and ASM_CAPACITY 49152 (EIP-3860) in
  src/asm.h:13 and :14. `langc build` refuses with EVM_SIZE
  (src/lower.c:163), and test/buildtool.c checks the runtime limit. The
  gas rows of the kit use `evm run --statdump` (C-K4-19 of
  docs/host/CAPABILITY.md). The S7 rows: the gas of `check` and of
  `execute` for the honest spend at Merkle depth 1, 2, 4 and 8 and for
  carts of 1, 2 and 4 lines; the size of the runtime and of the creation
  code. O15: the bound 8 stays, unless the gas gives a reason; the
  builder records the values.
- O115 (S7 kickoff, builder call): the refusal codes are words. 0 is
  ok. Then the rows of 4.8 in order: NO_VIEW 1, NO_PATH 2,
  WRONG_MERCHANT 3, NOT_CANONICAL 4, WRONG_SESSION 5, OVER_CAP 6,
  EXPIRED 7, NEED_CONFIRM 8, REPLAY 9, NO_POLICY 10. Two more codes:
  BAD_CALLDATA 11 (the calldata does not decode) and NO_MANDATE 12 (no
  `grant`, or a `revoke`). The order of the checks: NO_MANDATE,
  BAD_CALLDATA, then 4.8, with NO_POLICY last (4.8). `check` gives the
  code. `execute` reverts on a code that is not 0.
- O116 (S7 kickoff, gap): the zero signer. Before `grant` the stored
  `viewer` and `vault` are 0, and a failed `ecrecover` gives the address
  0. Thus a bad signature matches a zero key. The decoder must refuse a
  zero signer (NO_VIEW, WRONG_SESSION, NEED_CONFIRM) and a call with no
  mandate (NO_MANDATE, O115). Each case gets a refusal row in s2. The
  guest side reverts on a failed recovery (O109).
- O117 (S7 kickoff, builder call): `NO_POLICY` in S7. `grant` stores the
  `policyVerifier` and `policyId` fields of `Mandate`. S7 has no
  STATICCALL kit op (O12, S9), thus the S7 `check` gives NO_POLICY when
  `policyVerifier` is not 0 (fail closed). S9 replaces this with the
  verifier call of 4.9.
- O118 (S7 kickoff, builder call): `grant` and `revoke` revert when
  `caller env` is not `self env` (section 7). `execute` sets `used sid`
  (a `Map U256 U256`, O16, O93), adds the total to `spent`, does `pay
  token merchant total` and emits `Spent(sid, cartHash, total)`. The
  builder checks that `langc build` lowers `emit`: examples/contract.lang
  says that `langc build` refuses it (C-K4c-2), but test/lower/emit.lang
  and the emit rows exist.
- O119 (S7 s1 part 1, builder call): the cofield of `Machine` is `mStep`,
  not `step`. `step` is a field of test/check/state-fun-field.lang, and a
  domain def with that name gives REFUSE_NAME (R4). Section 4.7 and O110
  say `mStep`; the Q-S7-3 text stays as the USER ruled it.
  domain/domain.lang, after `sDuplicate`: `def Req : Type 0 := List U256`
  and `cofamily Machine (A : Type 0) := mCorec (eps : A) (mStep : Req ->
  Machine A)`. The cocell shape check unfolds `def Req` (cocell_kind
  takes the normal form, then cell_closed in src/front/check.c).
- O120 (S7 s1 part 1, builder call): R1 refuses `nil` and `cons` in a
  guest program outside the kit. Thus the counter row is in a new kit
  example, examples/machine.lang (a line in examples/kit.txt): `counter :
  Machine Size` by `mCorec`, and `counterAt2`. test/eval/expect.txt:
  `machine counterAt2 => szS (szS sz0)`. examples/cocell.lang does not
  change. test/fronttool.c: a `List U256 -> Mach A` label (accepted) and
  a `List A -> Mach A` label (REFUSE_CELL). Gate S7-s1-part1-gate.log:
  EXIT 0, 48 lines; evals 165 to 166, examples 41 to 42. Open: a mutant
  for the `List A` row (`cell_closed(t->a, 0u)` to `1u` in check.c).
- O121 (S7 s1 resume 2, builder call): a `List U256` argument has at most
  256 words. `ENTRY_LIST_MAX 256u` (src/front/check.h) and
  `IR_LIST_WORDS_MAX 256u` (src/ir.h; src/evm.c does not include
  check.h). A `_Static_assert` in src/lower.c makes the two copies equal.
  The IR has `IR_SCALAR_U256_LIST` and `IR_EXPR_CALLDATA`.
- O122 (S7 s1 resume 2, builder call): a `List U256` argument must be the
  last argument. When a Pi follows it, `role_of` sees a helper (thus
  `langc run` gives EVAL_ENTRY), and `residualize` gives REFUSE_LOWER "a
  List U256 argument must be the last argument"
  (test/lower/list-not-last.lang).
- O123 (S7 s1 resume 2, builder call): the list argument lowers only as
  the list of a `fold` (`lower_fold_arg`). Q-S7-2 (a) says a CALLDATALOAD
  loop, thus there is no memory copy. Item j is the call data word at 4 +
  32 N + 32 + 32 j. The scan reads item n - 1 first: p := 4 + 32 N + 32 n,
  then n times x := CALLDATA(p), acc := F x acc, p := p - 32 (the right
  fold of `lower_fold`). The address uses IR_OP_ADD and IR_OP_MUL with no
  trap: `emit_list_head` checks n <= 256 first. `emit_list_head` reverts
  with empty data when the offset word is not 32 N, when n > 256, or when
  CALLDATASIZE < 4 + 32 N + 32 + 32 n. A list outside a fold gives
  REFUSE_LOWER (O127).
- O124 (S7 s1 resume 2, builder call): `langc eval` and `langc run` take
  the list as the words after the other arguments (`list_arg` makes the
  `cons` chain from the end). A bad count gives EVAL_ARGS "the call takes
  N words and a list of at most 256 words, found M words". The word cap
  of a script line is `ENTRY_PARAMS_MAX + ENTRY_LIST_MAX + 3u`.
- O125 (S7 s1 resume 3, gap; fixed): `evm_abi_line` (src/evm.c) gave
  each ABI type name at most 7 bytes (`name + 3 + 8 * count`), but
  `uint256[]` has 9. `signature_of` returned 0, thus `langc abi` and
  `langc build` of a list entry gave REFUSE_LOWER (EVM_BUILD_IR). Now 10
  bytes for each type; `event_topic` keeps 8 (an event field is never a
  list). The resume 2 build had no list row, thus it did not see the gap.
  test/abi.expect: `0x3a428dd3 payList(uint256,uint256[]) entry` and
  `0x1ff7b81c lastSeen() view` (`cast sig` gives the same selectors).
- O126 (S7 s1 resume 3, facts): examples/listarg.lang (a kit example)
  has the entry `payList (tag : U256) (xs : List U256)` and the view
  `lastSeen` (`pay` and `seen` are domain names, R4). It stores `fold
  (fun x acc => u256Add x (u256Add acc acc)) tag xs`.
  test/run/listarg.script: 8 calls; lastSeen gives 5, 17, 25 and 19. A
  scan from the head gives 19, not 25, for call 5. test/run.sh: 2
  EVAL_ARGS rows (no words; 1u and 257 list words). test/evm.sh: the
  listarg chain, 3 revert rows (offset, length, short) and the `--text`
  abi block. test/evmchain.sh `input` writes a `uint256[]` last
  parameter. test/lower: list-not-last.lang and list-outside-fold.lang.
- O127 (S7 s1 resume 3, gap; Q-S7-4): the lower.c check for a list
  argument outside a fold is defensive. No typed program gets to it:
  `makeState tag xs` and `cons tag xs` as a List field get to the List
  field check, and a fold over a List accumulator fold of xs gets to
  "fold at a word position". list-outside-fold.lang is the `makeState tag
  xs` probe. Its text called the list argument "the Env or the state as
  one value". Q-S7-4 (a): `value_name` gives "a List U256 argument"
  (`is_list_arg` moved before it), and the defensive text is "outside a
  fold".
- O128 (S7 s1 resume 4, facts): Q-S7-4 (a) is in src/lower.c
  (test/lower/expect.txt checks the code only, thus no row changes).
  examples/kit.txt has listarg.lang: the resume 3 gate stopped at
  REFUSE_KIT, because test/gate.sh checks an example in guest mode when
  kit.txt does not list it. docs/host/README.md: the `List U256`
  argument, its script form, EVAL_ARGS above 256 words, `uint256[]` and
  the list head checks. Gate S7-s1-gate.log: EXIT 0, 48 sorted lines.
  The only differences from S7-s1-part1-gate.log: examples 42 to 43, runs
  6 to 7, run refusals 14 to 16, lower refusals 15 to 17, checks 32 to
  34, evm steps 43 to 54 (8 calls and 3 reverts). Mutants (test/evm.sh,
  `make -B` for each), each KILLED: M1 (the offset check EQ, ISZERO,
  JUMPI to EQ, POP) fails the offset row; M2 (the bound 256 + 1) fails
  the length row; M3 (the size check without the length word) fails the
  short row; M4 (a scan from the head: p := 4 + 32 N + 32, ADD 32) fails
  listarg.script calls 5 to 8 (lastSeen 19, not 25). After the restore,
  `git diff | shasum` is equal and test/evm.sh has 0 failures.
- O129 (S7 s2 part 1, builder check, O118): `langc build` refuses the
  `emit` op of the prelude. `build/langc --kit build test/lower/emit.lang`
  gives REFUSE_LOWER "emit has no EVM form; use a named event", rc 1
  (C-K4c-2). A named event lowers (the abi event row of
  examples/contract.lang). Thus examples/mandate.lang declares `event
  Spent (spentSid : U256) (spentCart : U256) (spentTotal : U256)`, and
  `execute` gives `Spent` as an Out.
- O130 (S7 s2 part 1, facts and builder calls): examples/mandate.lang
  part 1 (288 lines, a kit example, the last line of examples/kit.txt).
  The state: the 11 words of the mandate as the fields `mOwner` to
  `mPolicyId` (the copy has the accessors `owner` to `policyId`),
  `spent`, `used : Map U256 U256` and `revoked : Flag`. `init` is all 0
  with `revoked` = flagYes, thus no `grant` and a `revoke` give the same
  NO_MANDATE check (O115). Then the event Spent (O129), the lines 99 to
  344 of examples/precompile.lang (Hash to Spend) between the comment
  lines BEGIN COPY and END COPY (Q-S7-1 (a)), `stMandate`, the 13 codes
  `codeOk` to `codeNoMandate` (O115), and the entries `grant` (11 words;
  `spent` 0, `revoked` flagNo, `used` stays) and `revoke`. Both revert
  when `caller env` is not `self env` (O118). `langc check` without
  `--kit` gives REFUSE_KIT, rc 1; with `--kit` it gives ok. `langc --kit
  build` gives rc 0, 1813 bytes. The ABI: grant 0xb080f3a3, revoke
  0xb6549f75, the Spent topic 0xee58d782...d791, each equal to `cast
  sig` and `cast sig-event`. The copy also gives the views domainWord,
  listingHashV and merkle2V. No `check` and no `execute` yet (O131).
- O131 (S7 s2 part 1, gap; Q-S7-5): the kit lowers the `List U256`
  argument only as the list of a `fold` (O123), and K4c does not lower
  `first` or `second` at a word position. Thus a `fold` with a Prod
  accumulator gets REFUSE_LOWER. Three probes: a view with a `Prod Nat
  U256` accumulator, an entry with that accumulator and a `mapSet` of
  the state, an entry with a three-word accumulator, a `pay` and an
  event. Each `langc --kit check` gives ok; each `langc --kit build`
  gives rc 1. A word accumulator cannot hold the position, the root, the
  line fields and the cart sums of the decoder. The USER RULED Q-S7-5
  (a) (2026-10-25).
- O132 (S7 s2 resume 1, Q-S7-5 (a)): the kit change in src/lower.c. A
  `fold` over the `List U256` argument takes a right-nested Prod of
  words as the accumulator, with at most 32 words (ENTRY_PARAMS_MAX).
  New functions before `lower_expr`: `step_must_trap`, `step_words` (the
  step words in slot order; a step must be a nested `pair` or a `flagIf`
  with pair arms, else REFUSE_LOWER "(a fold step that is not a pair)"),
  `acc_value` (slot i is the local base + i), `lower_fold_arg` (it gives
  the REPEAT stmt and the base; the step sets temporary locals, then the
  slots) and `lower_slot` (`first` and `second` of the fold lower to the
  slot local; one loop for each fold Value, memo as `lower_curve`). More
  than 32 words: REFUSE_LOWER "(a fold accumulator of more than 32
  words)". A word fold keeps the old local layout (acc, p, x, counter),
  thus the old bytes do not change. The rows:
  test/lower/fold-pair-wide.lang (33 words, REFUSE_LOWER, the last line
  of test/lower/expect.txt), examples/listarg.lang view `pairFold` (3
  words; the model of a shared fold: `(fun (r : T) => ... first r ...
  second r) (fold F Z xs)`), test/run/listarg.script lines 9 to 11 (0u,
  21u, 17u; the evm chain runs them too) and test/abi.expect `0x651b3c42
  pairFold(uint256[]) view` (equal to `cast sig`). The gate
  mandate-lang-work/S7-s2-resume1-gate.log: EXIT 0, 48 lines; against
  S7-s2-part1-gate.log, lower refusals 17 to 18, checks 34 to 35, evm
  steps 54 to 57.
- O133 (S7 s2 resume 1, gap; Q-S7-6): eval keeps a trap in one part of
  a pair (`reduce_op` OP_PAIR has no trap check), but the evm loop
  reverts at the first trap of a slot. Thus `second (fold ...)` can give
  a value on `langc run` and a revert on evm. The USER RULED Q-S7-6 (a)
  (2026-10-25): src/front/eval.c gets `pair_trap` and `fold_acc`, and
  `reduce_fold_list` puts Z and each step through `fold_acc` (a pair
  accumulator with a trapped part is that trap). src/lower.c then checks
  `step_must_trap (F x trap)` for a word or a pair accumulator. The
  three probes of O131 ($TMPDIR/s7s2-p1.lang to p3) now give `langc
  --kit build` rc 0.
- O134 (S7 s2 resume 2, gap; Q-S7-7): the kit has no U256 to Nat op.
  `ecrecover` takes v as a Nat (src/front/check.c, SHAPE_NAT), and the
  copy `merkle` and `side` take the leaf index as a Nat (`natDiv`,
  `natMod`). The calldata is `List U256`, and `toU256` goes only from
  Nat to U256 (eval keeps a Nat as a uint64). The USER RULED Q-S7-7 (a)
  (2026-10-25): no kit change. The decoder changes the v word to the
  Nat 27 or 28 by `flagIf` (another word gives 0, thus the address 0,
  thus the zero signer refusal of O116). Each line gives one direction
  word for each sibling in place of the leaf index: 0u gives `hash h s`
  and 1u gives `hash s h`, as `side` with the bits of the leaf index
  from the leaf up; another word gives BAD_CALLDATA. The depth counter
  is a U256. The decoder hashes with its own word step; the copy does
  not change (Q-S7-1 (a)).
- O135 (S7 s2 resume 2b, Q-S7-8): two gaps of the decoder. (i) `pay`
  takes `payTo : Addr`, the calldata gives words, and the kit has no
  U256 to Addr op. The USER RULED (b) (2026-10-25): the state keeps the
  merchant address `mMerchant` (one merchant for each grant; `grant`
  takes it as the last argument, after `pi`). No kit change. The header
  merchant word must be `addrToU256 (mMerchant s)`, and the merchant
  word of each line must be the header word, else WRONG_MERCHANT. (ii)
  PLAN 4.8 has no code for qty more than `maxQty` (the `Le q (maxQty l)`
  part of `Line`). The USER RULED (a) (2026-10-25): NO_PATH (the line is
  not a `Line` of the view).
- O136 (S7 s2 resume 2b, the decoder layout): `check` and `execute` read
  the calldata `List U256` with one fold. The fold reads the end of the
  list first (O70). The 13 header words are at the end: sid, the
  merchant word, root, the view sig (v, r, s), the cred sig (v, r, s),
  the claim hash k, the confirm sig (v, r, s). Then the lines, the last
  line of the cart first (as the copy folds): the merchant word, sku,
  price, maxQty, qty, the depth n (8 or less), then n pairs (a direction
  word, a sibling) from the leaf up. The accumulator is a right-nested
  Prod of 30 words: pos, bad, the 13 header words, lp, lm, lk, lpr,
  lmq, lq, ld, lh, ldir, ch, tot, ck, cn, err, ovf. err starts at 5u (no
  line error) and keeps the smallest line code (NO_PATH 2,
  WRONG_MERCHANT 3, NOT_CANONICAL 4). The key of a line is
  `listingHash` (the Merkle leaf); the cart hash is the fold of `hash
  (hash key qty) ch` from 0u. No slot can trap (Q-S7-6 (a)): price and
  qty must each be 2^128 - 1 or less and the sum must fit, else ovf
  (OVER_CAP); the depth counter subtracts from a clamped word.
  BAD_CALLDATA: the bad flag (a depth over 8, a direction word that is
  not 0u or 1u), fewer than 13 words, or a list that stops in a line. A
  cart with no lines is not refused (the copy folds nil).
- O137 (S7 s2 resume 2c, the EVM size limit; Q-S7-1 (a), guest first):
  with the O136 decoder, `--kit build` gave EVM_SIZE (the runtime code
  was more than 24576 bytes). The probes: a lambda application of a word
  lowers in a view body and in a fold step. But the bound form and the
  inline form have the same size (1140 and 1140 bytes in a view, 1242
  and 1242 bytes in a fold step), thus the lowerer copies the argument
  at each use and a guest binder does not make the code smaller. Two
  changes of algebra that keep each code: (1) PQ is `flagIf OKPQ
  (u256Mul lpr lq) 0u` (one copy of OKPQ, not two; the else value is 0u
  as before). (2) err starts at 0u. Each line adds the weight of its
  first failed check: NO_PATH 2^128, WRONG_MERCHANT 2^64, NOT_CANONICAL
  1. The code chain gives NO_PATH when err is 2^128 or more,
  WRONG_MERCHANT when err is 2^64 or more, NOT_CANONICAL when err is not
  0u. The chain gets to a test only when the tests before it are false,
  thus each code is the same as with the smallest line code of O136. The
  list has fewer than 2^64 lines, thus the sum cannot overflow and the
  weights do not mix. Each step now has one copy of the line code (O136
  had two). The runtime code is 22457 bytes: check only 8646, execute
  only 14723, grant, revoke and the dispatcher 912 (8646 + 14723 - 912 =
  22457). The margin is 2119 bytes. No kit change; no ruling.
- O138 (S7 s2 resume 2d, the run, abi and copy rows; Q-S7-1 (a)):
  test/run/mandate.script and .out (30 rows) run examples/mandate.lang
  with `langc run`. grant from self stores tMandate and the merchant 0xaa.
  grant and revoke from another caller revert. The honest spend is tSpend
  of examples/precompile.lang (the total 450u). `check` gives 0u. `execute`
  pays 450u of the token 0x05 to 0xaa and gives the event Spent. Then the
  session is used: `check` gives REPLAY (9u) and `execute` reverts. Each
  code from 1u to 12u has a row with one fault. A second root (root2)
  holds demoL0 and a listing of the merchant 0xbb (sku 5u, price 10u,
  maxQty 5u). The anvil key 0 (the viewer
  0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266) signs the view of root2. The
  O137 rows: a line of 0xbb (WRONG_MERCHANT) read first and demoL0 with a
  bad sibling (NO_PATH) next give 2u. A line of 0xbb read first and demoL0
  (NOT_CANONICAL) next give 3u. Note: `canonical` orders the listing
  hashes, not the sku. In read order the hashes go down. With sku 3u,
  demoL0 is in order and the row tests only WRONG_MERCHANT, thus sku 5u.
  The abi rows: test/evm.sh and test/abi.expect hold the `langc abi --text`
  lines of examples/mandate.lang. Each selector equals `cast sig`:
  check(uint256[]) 0x1b365701, execute(uint256[]) 0x8ef16cd9 and
  grant(address,address,address,address,address,uint256,uint256,uint256,uint256,address,uint256,address)
  0xb17962e1. The copy row: test/precompile.sh compares the lines between
  BEGIN COPY and END COPY of examples/mandate.lang with lines 99 to 344 of
  examples/precompile.lang (`cmp`). A cart with no lines: the copy does not
  refuse it. `canonical` of nil is flagYes and the total 0u is not over the
  autoLimit (`inl refl`). `check` also gives 0u (row 25), thus no Q-S7-10.
  Item 4 of resume 2d (the Q-S7-6 trap row) is NOT done.
- O139 (S7 s2 resume 2e and 2f, the Q-S7-6 trap row and the evm rows of
  examples/mandate.lang; Q-S7-6, Q-S7-1 (a)): test/run/listarg.script row
  12 `pairFold 0xff...ffu 1u` (64 f) gives trap. The right fold reads 1u
  first, then x + 2 acc = (2^256 - 1) + 2 overflows u256Add in the fold
  slot. The evm chain of listarg replays the row (the evm gives trap).
  The evm rows of examples/mandate.lang: test/evm.sh runs `chain` on
  test/mandate-evm.script (30 rows), that is test/run/mandate.script with
  the token 0x..ee in each grant. The chain id: `langc run` signs the view
  sig with the chain id 1337 (the domain of the view sig), and
  test/evmchain.sh sets the chain id 1. With the chain id 1 the view
  digest is different and ecrecover gives another signer: each check row
  that needs a good view sig gave NO_VIEW (a trial: 19 failures in 30
  steps). A trial with the chain id 1337 gave 6 failures, all in rows 26
  to 30. Thus the mandate chain uses the chain id 1337, and the other
  chains keep the chain id 1. The token: 0x..05 is the modexp precompile
  and a precompile ignores alloc code, thus the pay CALL of execute
  failed. Choice (a): a second script with the token 0x..ee, and the mock
  token of test/diff.sh (`asmtool mock`, mode 0) in `alloc`. Reason: each
  row goes through `chain`, also REPLAY and the execute revert after the
  pay, with the check of the result, the storage and the logs of each
  step. Choice (b) (rows 1 to 25 and one hand step for execute) does not
  check the rows after the pay. When alloc is set, `chain` keeps only the
  storage of the receiver (step puts the storage of all accounts in
  tmp/raw), and `wantlogs` adds the line of the Transfer LOG3 of the mock
  for each pay line. `langc run` gives the same codes for the two
  scripts; only the pay line and the state line (the token) differ. A
  trial of the new block: 30 steps, 0 failures. The evm steps of the
  gate go from 58 to 88.
- O140 (S7 s2 resume 3 to 5, the mutants of s2; s2 DONE, 2026-10-25,
  claude7). The 25 mutants: c0 and the 12 code mutants, G, V, X0, W2
  and W3 KILLED by `langc run`; L1 KILLED by test/build.sh; O1 and O2
  KILLED by test/evm.sh. Resume 3: PQ (COUNT 6), F1, S1 and S2
  SURVIVED. Resume 4 added rows for F1, S1 and S2:
  test/lower/fold-discard.lang (the step `flagIf (u256Eq x 0u) 1u
  (u256Add x acc)` discards acc at x = 0; the expect.txt row
  `fold-discard.lang REFUSE_LOWER`) and the view countFold of
  examples/listarg.lang (rows 13 and 14 of test/run/listarg.script,
  the ABI line `0x05c46e82 countFold(uint256[]) view`). F1 KILLED
  (`FAIL run test/run/listarg.script`). S2 KILLED (`FAIL lower
  fold-discard.lang`). S1 (`||` in a `&&` chain) stopped the
  check-clang build (-Werror, -Wlogical-op-parentheses): a build stop,
  not a kill. S1p (the `||` in parentheses) KILLED (`FAIL lower
  fold-discard.lang`). Resume 5: PQ changes the guard Q <= 2^128 - 1
  before each u256Mul (6 sites) to Q <= 2^256 - 1. The `ovf` guard
  gives OVER_CAP without the product, thus only a u256Mul trap shows
  PQ. Rows 31 (grant from self again) and 32 (the honest spend with
  the quantity 2^255 of demoL1) of test/run/mandate.script: the
  original gives `32 check = 2u` (NO_PATH: the quantity is more than
  maxQty 1u), PQ gives `32 check trap`. PQ KILLED (`FAIL run
  test/run/mandate.script`). The state line of mandate.out changes:
  spent 450u to 0u, revoked flagYes to flagNo. test/mandate-evm.script
  does not have rows 31 and 32. All 25 mutants are KILLED (S1 as
  S1p). The final gate (S7-s2-gate.log): EXIT 0, the same as the
  resume 4 final gate. The count changes of s2: lower refusals 18 to
  19, checks 35 to 36, evm steps 88 to 90; the PQ rows change no
  count. TRAP for later mutants: a `||` mutant in a `&&` chain needs
  parentheses, else the clang -Werror build stops it.
- O141 (S7 s3, the plan of s3, 2026-10-25, claude7): O110 s3 is the
  differential (Q-S7-3), the gas rows and the size rows (O114),
  docs/host/CAPABILITY.md and docs/host/README.md. Q-S7-9 and Q-S7-10
  RULED (a). The parts:
  - s3 part 1: test/diff.sh part 2 also runs test/mandate-evm.script
    on examples/mandate.lang, with the chain id 1337 (the domain of
    the view sig, O139) and the mock in mode 0 at the token 0x..ee.
    Each step must give the result of `langc run`. At the end, the
    contract storage must equal the state of `langc run`, and the
    mock balances must equal the pay sums (the merchant 0x..aa has
    450u, self has -450u mod 2^256). test/evm.sh keeps its mandate
    chain. The size rows: the runtime and the creation code of `langc
    --kit build examples/mandate.lang`, against ASM_RUNTIME_MAX 24576
    and ASM_CAPACITY 49152. Then the gate.
  - s3 resume 1, the gas ladder (Q-S7-10 (a)): closed honest spends
    as guest terms, at the Merkle depth 1, 2, 4 and 8 (a cart of 1
    line) and with carts of 1, 2 and 4 lines (depth 2). The words come
    from `langc eval`, the sigs from `cast wallet sign --no-hash`, as
    for tSpend. One grant; each spend has a new session; mCap is large
    enough. The call script test/run/mandate-gas.script and its .out
    (test/run.sh). A runner in the work dir measures the gas of
    `check` and of `execute` for each spend with `evm run --statdump`.
  - s3 resume 2: docs/host/CAPABILITY.md (the gas table and the size
    rows, as C-K4-19), docs/host/README.md, and the O15 bound 8 (it
    stays, unless the gas gives a reason).
  - s3 part 1 results (2026-10-25, the runner S7-s3-p1.sh, the result
    S7-s3-p1.txt): the size rows of examples/mandate.lang: the
    creation code is 22482 bytes (the limit is 49152), the runtime is
    22457 bytes (the limit is 24576: 2119 bytes free, 91.4 percent).
    Thus a large change to the contract can go over EIP-170.
    test/diff.sh alone: `diff gate: 16 rows, 0 failures` (15 to 16),
    36 s. The gate (S7-s3-gate.log, 334 s): EXIT 0; the only change
    from the s2 final gate is the diff gate line, 15 to 16 rows.
- O142 (S7 s3 resume 1 and 1b, the gas ladder, 2026-10-26, claude7):
  Q-S7-11 RULED (a) for its 3 parts. The closed gas spends are guest
  terms in examples/precompile.lang, after `def tGateLe` (as tSpend
  is): gMandate (tMandate with the token 0x..ee and the cap 1000000u),
  then for each spend the listings, Root, ViewSig, CredSig,
  ConfirmSig, View, Session, Prov and Line of each line, Cart, Cred,
  Confirmed, Gate and Spend (205 lines). Each spend has a new session,
  the total 200u, the claim hash 77u, the merchant 0x..aa, qty 1u and
  maxQty 5u. The autoLimit is 100u (as tMandate), thus each spend
  needs the confirm sig (3 ecrecover calls, the worst case, as
  tSpend). The spends:
  - gd1Spend: sid 101u, 1 line, Merkle depth 1 (index 1, 21 words).
  - gd2Spend: sid 102u, 1 line, depth 2 (index 2, 23 words).
  - gd4Spend: sid 104u, 1 line, depth 4 (index 5, 27 words).
  - gd8Spend: sid 108u, 1 line, depth 8 (index 85, 35 words).
  - gc2Spend: sid 202u, 2 lines, depth 2 (33 words).
  - gc4Spend: sid 204u, 4 lines, depth 2 (the cart has the tree
    leaves in the order 1, 0, 3, 2; 53 words).
  The call script test/run/mandate-gas.script (22 lines) has 3 header
  comments, the grant from self, then for each spend a comment, check
  and execute (the caller 0x..bb, as row 26 of
  test/run/mandate.script). NOW of check and execute is 2 and 3, 4
  and 5, to 12 and 13. Before each spend, the spent amount is 0u,
  200u, to 1000u. Its .out has 26 lines. test/run.sh removes the
  script name from the first dash, thus test/run/NAME-PART.script
  runs examples/NAME.lang (Q-S7-11 (a) part 2). The generator
  mandate-lang-work/S7-s3-r1-gen.pl (it writes no repo file) made the
  3 files; resume 1b copied them into the repo.
  - resume 1 results (2026-10-26): `langc --kit eval` of each Spend
    exits 0 (the guest checks each Merkle path, the 3 sigs, the cap,
    the expiry and the gate). `langc --kit run examples/mandate.lang`
    on the script exits 0: 6 `check = 0u` and 6 `execute ok`, each
    with a pay of 200u from the token 0x..ee to 0x..aa and an event
    Spent. `langc --kit build examples/precompile.lang`: the creation
    code is 1725 bytes and the runtime is 1705 bytes (O143 corrects
    5215), before and after (the closed defs do not go in the code).
  - resume 1b, the gas runner mandate-lang-work/S7-s3-r1b.sh: a copy
    of test/diff.sh runs only the gas script on `evm` (the chain id
    1337, the mock in mode 0 at 0x..ee). Each step also runs `evm run
    --statdump` on the same prestate. Then test/precompile.sh and the
    gate.
  - resume 1b results (2026-10-26, the runner S7-s3-r1b.sh, the
    result S7-s3-r1b.txt, the log S7-s3-r1b-gas.log): the gas copy
    gives `diff gate: 1 rows, 0 failures` (37 s). Thus each step
    gives the result of `langc run`, and the end storage and the mock
    balances are correct. The gas is the `evm run` value (the
    intrinsic gas of a transaction, 21000 and the calldata, is not in
    it). The grant is 233442. The spends:
    - gd1Spend (1 line, depth 1): check 152881, execute 364952.
    - gd2Spend (1 line, depth 2): check 164484, execute 336774.
    - gd4Spend (1 line, depth 4): check 187521, execute 382848.
    - gd8Spend (1 line, depth 8): check 233533, execute 474914.
    - gc2Spend (2 lines, depth 2): check 223120, execute 454130.
    - gc4Spend (4 lines, depth 2): check 340571, execute 688948.
    Each extra Merkle level adds about 11500 gas to check (11603,
    then 11519 and 11503 for each level) and about 23000 to execute
    (from gd2: 23037 and 23017 for each level). Each extra line adds
    about 58700 gas to check (58636, then 58726 for each line) and
    about 117400 to execute (117356, then 117409 for each line). The
    execute of gd1 is more than the execute of gd2, probably because
    it is the first pay: it writes storage slots that are zero (the
    spent amount and the mock balances). test/precompile.sh:
    `precompile gate: 0 failures`. The gate (S7-s3-r1b-gate.log, 650
    s): EXIT 0; the only change from the s3 part 1 gate is the run
    count, 8 to 9 runs. The git diff sha is the same before and after
    the runner.
- O143 (S7 s3 resume 2, the gas and size docs, 2026-10-26, claude7):
  docs/host/CAPABILITY.md C-K4-19 has the mandate gas table of O142
  (the grant, the check and execute of the 6 spends, the step of each
  Merkle level and each line, the `evm run` note) and the size rows.
  docs/host/README.md `## The mandate contract (slice S7)` has short
  gas and size lines and a pointer to C-K4-19.
  - The size of examples/precompile.lang: `langc --kit build` gives
    the creation code 1725 bytes and `langc --kit build --runtime`
    gives the runtime 1705 bytes. Resume 1 recorded the runtime 5215
    in error. 5215 is the PUSH2 value at byte 11 of the creation code
    (probably the method of the s3 part 1 runner). That byte holds
    the runtime length only when the constructor writes a slot, as in
    examples/mandate.lang. O142 has the correct value now.
    examples/mandate.lang: creation 22482, runtime 22457 in the two
    modes (the same as s3 part 1).
  - O15: the bound 8 stays (no Q). Depth 8 costs 233533 for check and
    474914 for execute (less than 2 percent of a block of 30000000
    gas). Depth 16 would add about 92000 to check and about 184000 to
    execute. The cost of each level is small and linear, thus the gas
    gives no reason to change the bound.
  - No gate step reads the 2 docs (the Makefile names README.md only
    in a comment), thus resume 2 runs no gate. s4 runs the final gate.
- O144 (S7 s4, the S7 close, 2026-10-26, claude7): the final gate.
  The runner mandate-lang-work/S7-s4.sh (the result S7-s4.txt, the
  log S7-s4-gate.log) runs test/precompile.sh (`precompile gate: 0 failures`), then `make
  -j 2 check`: EXIT 0 in 478 s. After a filter of the build lines
  and a sort, the lines are the same as the lines of the s3 resume 1b
  gate (S7-s3-r1b-gate.log). The diff gate line is `diff gate: 16 rows, 0 failures`. The git
  diff sha did not change during the run.
  - The definition of done (the S7 row and O110), item by item:
    - `Machine`: `Machine` and `Req` in domain/domain.lang, with the
      cofield `mStep` (O119), and the kit example
      examples/machine.lang (O120). The `List U256` entry argument
      (Q-S7-2 (a)): the CALLDATALOAD fold (O121 to O124), the
      `uint256[]` ABI fix (O125), examples/listarg.lang and its rows
      (O126). The Prod fold accumulator (Q-S7-5 (a), O132) and the
      trap of a part (Q-S7-6 (a), O133).
    - The contract of section 7: examples/mandate.lang with `grant`,
      `revoke`, the view `check` and `execute` (O130), the build and
      the run rows (O137, O138), the evm rows (O139). One refusal row
      for each chain refusal of 4.8 and of O115, but not `NO_POLICY`
      (S9, O117).
    - The decoder: the layout of O136 and the rulings of Q-S7-7 (O134)
      and Q-S7-8 (O135).
    - The differential: part 2 of test/diff.sh runs
      test/mandate-evm.script on examples/mandate.lang (Q-S7-9 (a),
      O141).
    - The gas rows: test/run/mandate-gas.script and its .out (Q-S7-10
      (a), Q-S7-11 (a), O142). The size rows: the runtime is 22457
      bytes (the limit is 24576), the creation code is 22482 bytes
      (the limit is 49152) (O141, O143).
    - The docs: docs/host/CAPABILITY.md C-K4-19 and
      docs/host/README.md (O143).
    - The mutants of the decoder and of each refusal row: O110 put
      them in s4, but s2 resume 3 to 5 ran them (O140): 25 of 25
      KILLED (S1 as S1p). Thus s4 runs no mutant loop.
    - The gate and the commit message: this O.
  - The files: 35 (21 modified, 14 new). Modified: docs/PLAN.md,
    docs/host/CAPABILITY.md, docs/host/README.md, domain/domain.lang,
    examples/kit.txt, examples/precompile.lang, src/evm.c,
    src/front/check.c, src/front/check.h, src/front/eval.c, src/ir.h,
    src/lower.c, test/abi.expect, test/diff.sh, test/eval/expect.txt,
    test/evm.sh, test/evmchain.sh, test/fronttool.c,
    test/lower/expect.txt, test/precompile.sh, test/run.sh. New:
    examples/listarg.lang, examples/machine.lang,
    examples/mandate.lang, test/lower/fold-discard.lang,
    test/lower/fold-pair-wide.lang, test/lower/list-not-last.lang,
    test/lower/list-outside-fold.lang, test/mandate-evm.script,
    test/run/listarg.out, test/run/listarg.script,
    test/run/mandate-gas.out, test/run/mandate-gas.script,
    test/run/mandate.out, test/run/mandate.script.
  - The 35 files are staged in the main checkout. The commit message
    file is mandate-lang-work/S7-commit-msg.txt. The USER commits
    (`git commit -s -F`). The next slice is S8
    (mandate-lang-work/S8-PROMPT.md).
- O145 (S8 kickoff, Step 0, 2026-10-26, claude7): the USER commit
  11f166e on 17d50a4 (subject "Add S7 mandate contract and dynamic list
  folds", not the subject of mandate-lang-work/S7-commit-msg.txt) has
  the tree e4f66d5d of the S7 close: 35 files, 2119 insertions and 42
  deletions, Signed-off-by. The fresh gate
  mandate-lang-work/S8-k0-gate.log gives EXIT 0, and its filtered final
  lines are the same as the S7 s4 gate (mandate-lang-work/S8-k0.txt).
- O146 (S8 kickoff, the sessions of S8): Q-S8-1 to Q-S8-4 RULED (a).
  - s1: the honest spend and the G1 and G3 rows. The call scripts
    test/run/mandate-honest.script, mandate-g1.script and
    mandate-g3.script with their .out files (Q-S8-1 (a)), the G1 type
    refusal row in test/check (Q-S8-2 (a)), the IO script of the honest
    spend (O149), and the three call scripts in part 2 of test/diff.sh.
  - s2: the five G2 rows in test/run/mandate-g2.script (O148,
    Q-S8-3 (a)), and the residual of 4.5 in the docs: a table of each
    attack form, its row, and its refusal code or its bound.
  - s3: the x402 route (O150, Q-S8-4 (a)): the call script
    test/run/mandate-x402.script in the facilitator order, the source
    read of O18, the doc section, and the S8 close (the final gate, the
    S8 row DONE). The mutants of the S8 rows come in S10 (section 9).
- O147 (S8 kickoff, the test state): test/run.sh runs each
  test/run/NAME.script or NAME-PART.script with `build/langc --kit run
  examples/NAME.lang` and compares the output with the .out file byte
  for byte. So a new script test/run/mandate-g1.script runs on
  examples/mandate.lang with no change to test/run.sh.
  test/run/mandate.script has the honest spend (tSpend of
  examples/precompile.lang: the session 11u, the merchant 0xaa, the
  claim hash 77u, the lines demoL0 (quantity 2u) and demoL1 (quantity
  1u), the total 450u) and one row for each of the 13 codes of `check`:
  0 (ok), NO_VIEW 1, NO_PATH 2, WRONG_MERCHANT 3, NOT_CANONICAL 4,
  WRONG_SESSION 5, OVER_CAP 6, EXPIRED 7, NEED_CONFIRM 8, REPLAY 9,
  NO_POLICY 10, BAD_CALLDATA 11 and NO_MANDATE 12. Part 2 of
  test/diff.sh runs each call script on `langc run` and on geth `evm`
  (test/evmchain.sh) with the mock token at 0x..ee and the chain id
  1337 (O139, O141); the mock balances must equal the pay sums of
  `langc run`. A new spend needs new words and sigs: the digest words
  come from `langc eval` of the guest terms, and the sigs come from
  `cast wallet sign --no-hash` with the anvil keys (O142,
  test/run/mandate-gas.script).
- O148 (S8 kickoff, the attack forms and their rows; each code is a
  hypothesis that the session of the row checks):
  - G1 (O23, Q-S1-5 (a), Q-S8-2 (a)): a cred sig by another vault key
    (the credential of another user) and a cred sig of another session
    from the same vault give WRONG_SESSION (5u). A guest `lookup` with
    a user argument does not type check (4.3).
  - G2 (O24, Q-S1-6 (a)): a changed price changes the leaf hash
    (NO_PATH, 2u); a changed payee gives WRONG_MERCHANT (3u); a listing
    that is not in the view gives NO_PATH (2u). An unrequested item and
    a promoted or demoted item, when the listing is in the view, are
    the residual of 4.5: the rows of Q-S8-3 (a).
  - G3 (O25, Q-S1-7 (a)): a cart over the price of the cheapest
    matching listing is the residual of 4.5: the rows of Q-S8-3 (a).
  - The residual rows (Q-S8-3 (a)) for each of the three forms: a
    total at or below `autoLimit` gives 0u (the loss is at most
    `autoLimit` for the mandate); a total above `autoLimit` with no
    valid confirm sig gives NEED_CONFIRM (8u); a total above
    `autoLimit` with the confirm sig gives 0u (the user approved).
  - The honest spend: `check` gives 0u, `execute` pays, and a second
    spend of the same session gives REPLAY (9u) (O16).
- O149 (S8 kickoff, the IO-to-chain row, Q-S7-3 (a), Q-S8-1 (a)):
  `submit` of `IO` stays one word (Q-S7-3 (a)). s1 adds an IO script of
  the honest spend on `langc run`: the agent program (view, lookup,
  confirm, submit) with the answers of the script, where the answer of
  `submit` is the result of `check` on the chain (0u). Gap: no IO
  script of a spend exists yet; s1 finds the form of the link from the
  answer form of `langc run` (O101 to O104).
- O150 (S8 kickoff, the x402 route, Q3 (a), O18, Q-S8-4 (a)): the
  facilitator runs `check` by `eth_call` in its verify step and sends
  `execute` in its settle step (section 7). s3 adds a call script in
  this order: `check` gives 0u and moves no tokens, `execute` pays, and
  a second `execute` of the same session is refused (REPLAY). For O18,
  s3 reads the source of the USDC token (FiatTokenV2_2: does
  `transferWithAuthorization` accept an ERC-1271 contract signature?)
  and records the answer in an O item. No row and no new entry.
- O151 (S8 kickoff, the open O items): S7 closed none of O55, O60, O61,
  O66, O67 to O100 and O102 to O107 (no CLOSED or DONE mark from S7);
  they stay open. O117 (`NO_POLICY` with a verifier call) goes to S9.
- O152 (S8 s1, O148, Q-S8-1 (a)): the honest spend,
  test/run/mandate-honest.script on examples/mandate.lang. Row 1 is
  grant from self (row 4 of test/mandate-evm.script: tMandate with the
  token 0x..ee and the cap 1000u). Row 2 is check (row 5): 0u (codeOk).
  Row 3 is execute (row 26): ok, a pay of 450u from the token 0x..ee to
  0x..aa and the event Spent. Row 4 is check (row 27): 9u (REPLAY).
  test/run.sh runs the script on `langc run` (the .out file). Part 2 of
  test/diff.sh runs it on `evm` (the chain id 1337, the mock at the
  token 0x..ee). mandate-lang-work/S8-s1-gen.pl made the six files of
  test/run/ (RFC 6979 sigs, thus a new run gives the same bytes).
- O153 (S8 s1, O148, Q-S8-2 (a)): G1. test/run/mandate-g1.script has two
  check rows with a wrong credential. The cred sig is the words 25, 26
  and 27 (s, r, v) of the check calldata. Row 2: the sig of the anvil
  key 1 (not the viewer: the credential of another user) on tCredDigest
  gives 5u. Row 3: the sig of the anvil key 0 (the viewer) on the cred
  digest of the session 12u gives 5u. The key 0 sig of the generator on
  tCredDigest is the same as the cred sig of row 5 of
  test/mandate-evm.script (a check of the word places). The type row is
  test/check/lookup-user.lang: lookup gets an Addr (a user) in the place
  of the Session, and `langc --kit check` stops at `bad` with
  TYPE_MISMATCH. The gate checks it in the kit mode: it is a line of
  test/check/kit.txt, as cred-other-session.lang (in the guest mode it
  stops at REFUSE_KIT, because Hash is U256). The file has the defs of
  cred-other-session.lang (without oSession and bad) and lookupWord,
  checkSig, readSig and lookup of examples/precompile.lang.
- O154 (S8 s1, O148, Q-S8-3 (a)): G3, test/run/mandate-g3.script. The
  view s8hRoot has the depth 2 and the leaves s8hC (the sku 41u, the
  price 40u: the cheapest match), s8hA (41u, 90u), s8hB (41u, 150u) and
  the word 9u, all of the merchant 0xaa. s8hSpendA: the sid 301u, s8hA
  at the index 1. s8hSpendB: the sid 302u, s8hB at the index 2. Row 1
  is the grant of row 1 of test/run/mandate-gas.script (gMandate: the
  token 0x..ee, the cap 1000000u, the autoLimit 100u). Row 2: A with the
  confirm v word changed (55 - v) gives 0u (90u is not more than the
  autoLimit: the loss is at most the autoLimit). Row 3: B with the
  confirm v word changed gives NEED_CONFIRM (8u). Row 4: B with the
  confirm sig gives 0u. examples/precompile.lang has the guest terms
  s8hSpendA and s8hSpendB (58 lines after gc4Spend; each Gate is `inr
  Confirmed`). `langc --kit eval` gives rc 0 for each.
- O155 (S8 s1, O149, Q-S8-5 (a)): the IO-to-chain row. The entry
  askSpend of examples/precompile.lang (after askLookup) is one agent
  program: `show` demoRoot, `lookup` the session `pair 11u (pair 0x..aa
  tView)`, `confirm` (the viewer 0xf39f.., `hash4 confirmType 11u
  demoCartHash 77u`), then `submit` the sid word 11u. It gives some only
  when the submit answer is codeOk (0u). test/run/precompile-spend.script
  uses the answers of the rows 6, 8 and 4 of test/run/precompile.script.
  Row 1 with `submit 0u` (row 2 of test/run/mandate-honest.out) gives
  ok. Row 2 with `submit 9u` (REPLAY, row 4) gives revert. The link is
  by value: the IO answer form cannot refer to the result of a call
  script, and `submit` stays one word (Q-S7-3 (a)).
- O156 (S8 s1, O143): the code sizes. The sizes of
  examples/precompile.lang do not change: the creation code is 1725
  bytes and the runtime is 1705 bytes (`--runtime`), the same as at
  11f166e. Thus `langc build` does not put askSpend or the G3 guest
  terms in the code. examples/mandate.lang stays at the creation 22482
  and the runtime 22457 bytes.
- O157 (S8 s1, the gate): mandate-lang-work/S8-s1.sh (from S8-k0.sh)
  gives EXIT 0 in 578 s, and the git diff sha is the same before and
  after the run. FINAL DIFFERS from the gate log of the S8 kickoff only
  in three counts: the check refusals 182 to 183 (lookup-user.lang), the
  diff gate rows 16 to 19 (the three call scripts) and the runs 9 to 13
  (the three call scripts and precompile-spend.script). The first run
  stopped at lookup-user.lang (REFUSE_KIT in the guest mode); a line in
  test/check/kit.txt fixed it.
- O158 (S8 s1, the open O items): S8 s1 closed none of O55, O60, O61,
  O66, O67 to O100 and O102 to O107; they stay open. O117 goes to S9.
- O159 (S8 s2, O148, O24, Q-S1-6 (a), Q-S8-3 (a)): G2,
  test/run/mandate-g2.script on examples/mandate.lang. The view s8gRoot
  has the depth 2 and the leaves s8gA (the sku 41u, the price 90u),
  s8gU (42u, 60u), s8gP (43u, 70u) of the merchant 0xaa and s8gM (41u,
  50u) of the merchant 0xbb, at the indexes 0 to 3. Each listing has
  the maxQty 5u. Row 1 is the grant of row 1 of
  test/run/mandate-gas.script (gMandate: the cap 1000000u, the autoLimit
  100u). Each check row has the session 401u: `check` does not use the
  session, thus one cred sig is sufficient.
- O160 (S8 s2, O148): the three refused forms of G2. Row 2: the line of
  s8gA with the price 95u gives NO_PATH (2u) (the leaf hash changes).
  Row 3: s8gM at the index 3 (the path is valid) gives WRONG_MERCHANT
  (3u): the merchant of the line is 0xbb, not the merchant 0xaa of the
  session. Row 4: s8gX (41u, 30u), not in the view, with the path of
  s8gA gives NO_PATH (2u). Each total is not more than the autoLimit,
  thus each row gets to only its own check. The codes of O148 are
  correct.
- O161 (S8 s2, O148, Q-S8-3 (a)): the two residual forms of G2. Rows 5
  to 7 (an unrequested item, s8gU): the quantity 1u (60u) with a
  confirm sig that is not valid (the v word changed to 55 - v) gives
  0u, the quantity 2u (120u) with that sig gives NEED_CONFIRM (8u), and
  the quantity 2u with the confirm sig gives 0u. Rows 8 to 10 (a
  promoted item, s8gP: 70u and 140u) give 0u, 8u and 0u. The quantity
  sets the total, thus one listing gives the three rows of each form.
- O162 (S8 s2, the generator): mandate-lang-work/S8-s2-gen.pl computes
  the hashes with `langc --kit eval` and signs with the anvil key 0
  (RFC 6979: the same bytes in each run). It copies the script and the
  .out file to test/run/ only when each code is the code of O160 and
  O161. O146 asks for no guest terms in s2, thus
  examples/precompile.lang does not change.
- O163 (S8 s2, the docs, O146): O146 names no file for the residual of
  4.5. s2 adds the section "The attack corpus (S8)" at the end of
  docs/VALIDATION.md (the template text stays): a table of the honest
  spend and each attack form, its row, and its refusal code or its
  bound, then the residual of 4.5 (the bound of the `Gate` of 4.1).
- O164 (S8 s2, the gate): mandate-lang-work/S8-s2.sh. `make -j 2 check`
  gives EXIT 0 (mandate-lang-work/S8-s2-gate.log). The compare with the
  S8 s1 gate log gives FINAL DIFFERS, as expected: the 4 GATE DIFF
  lines (mandate-lang-work/S8-s2.txt) are the new G2 rows and the
  counts. The git diff sha is the same before and after the run.
- O165 (S8 s2, the open O items): S8 s2 closed none of O55, O60, O61,
  O66, O67 to O100 and O102 to O107; they stay open. O117 goes to S9.
- O166 (S8 s3, O150, Q3 (a), Q-S8-4 (a)): the x402 rows,
  test/run/mandate-x402.script on examples/mandate.lang, in the
  facilitator order of section 7. Row 1 is the grant of tMandate from
  self (the token 0x..ee, the mock of test/diff.sh, and the merchant
  0xaa). The spend is tSpend of examples/precompile.lang (the session
  11u, the total 450u). Rows 2 and 3 (the verify step: `check` by
  `eth_call`) give 0u and no pay line; the second `check` shows that
  `check` does not use the session. Row 4 (the settle step: `execute`)
  pays 450u of the token 0x..ee to the merchant 0xaa and emits Spent.
  Row 5, a second `execute` of the same session, reverts, and no tokens
  move. Row 6 (`check`) gives REPLAY (9u). The .out file has one pay
  line. mandate-lang-work/S8-s3-gen.pl (rows 1 to 3 from
  test/run/mandate-honest.script) gives GEN OK on the first run. Part 2
  of test/diff.sh runs the script on `evm`, after the mandate-g2 line,
  in the chain id 1337 wrapper.
- O167 (S8 s3, O18, O150): the source read of FiatTokenV2_2
  (circlefin/stablecoin-evm, the master branch at the commit
  fc85788bc7c2 of 2026-08-12), by WebFetch (curl is DENIED by a
  permission rule). `transferWithAuthorization` with a `bytes`
  signature (contracts/v2/FiatTokenV2_2.sol line 116) calls
  `_transferWithAuthorization` (contracts/v2/EIP3009.sol line 118),
  which calls `_requireValidSignature` (line 277), which calls
  `SignatureChecker.isValidSignatureNow` (line 283;
  contracts/util/SignatureChecker.sol lines 39 to 48). When the signer
  address has code (`extcodesize` more than 0, line 84), it does a
  STATICCALL of `isValidSignature` (ERC-1271, lines 60 to 76); else it
  uses ECDSA. The answer: YES, the token accepts an ERC-1271 contract
  signature. The consequence is a reading, NOT tested: a user account
  with the EIP-7702 delegate has code, and the contract of section 7
  has no `isValidSignature` entry; thus we expect that the token
  refuses an EIP-3009 signature of that user. The notes:
  mandate-lang-work/S8-s3-o18.txt. No row (Q-S8-4 (a)). O18 is CLOSED
  by this read.
- O168 (S8 s3, the docs, O146): the section "The x402 route (S8)"
  after "The attack corpus (S8)" in docs/VALIDATION.md: the verify
  step (`check` by `eth_call`), the settle step (`execute`), the table
  of the six rows of O166, and the O18 answer of O167.
- O169 (S8 s3, the final S8 gate): mandate-lang-work/S8-s3.sh. `make
  -j 2 check` gives EXIT 0 (mandate-lang-work/S8-s3-gate.log). The
  compare with the S8 s2 gate log gives FINAL DIFFERS, as expected: the
  4 GATE DIFF lines (mandate-lang-work/S8-s3.txt) are the new x402
  row and the counts. The git diff sha is the same before and after
  the run.
- O170 (S8 s3, the S8 close): S8 is DONE. The repo has the rows of the
  honest spend and of the three attacks (s1, s2), the residual of 4.5
  (s2) and the x402 route (s3). O18 is CLOSED (O167). S8 closed none of
  O55, O60, O61, O66, O67 to O100 and O102 to O107; they stay open.
  O117 goes to S9. The mutants of the S8 rows come in S10 (section 9).
  The next slice is S9 (mandate-lang-work/S9-kickoff-PROMPT.md).
- O171 (S9 kickoff, the reading of 4.9 for S9): `PolicyProof m s c`
  is a primitive with the index values m, s and c and no type
  parameter (2.2, O14). A guest program gets a term of it only from
  a verified answer of `prove s c` (O28); the term holds the proof
  bytes. The prover response is untrusted bytes until the verifier
  of O173 accepts it for the pending request's verifier address and
  all five public words. Only then may the handler construct the
  indexed term and pass it to the IO continuation. A failed check
  refuses the answer without calling the continuation or making a
  `PolicyProof` term.
  `PolicyOk m s c` is a new factor of `Spend` next to `Gate`
  (Q-S9-3 (a)): `Unit` when `policyVerifier m` is 0, else
  `PolicyProof m s c`. In S9 the verifier is the mock of 4.9: the
  proof is one word equal to `keccak (K, policyId m, domain, id m,
  sid s, cartHash c)`, with K the fixed mock key. The mock tests the
  transport and the binding of the five words only; it gives no
  evidence of policy authorization (4.9).
- O172 (S9 kickoff, the fresh gate): mandate-lang-work/S9-k.sh (the
  copy of S8-s3.sh). `make -j 2 check` gives EXIT 0
  (mandate-lang-work/S9-k-gate.log, 417 s). The compare with the S8
  s3 gate log gives FINAL SAME: there is no repo edit after the s3
  gate. The git diff sha is the same before and after the run.
- O173 (S9 s1, the STATICCALL kit op, O12, O29): a new kit op for the
  policy verifier: the verifier address, the five words and the proof
  bytes in, one word out. The lowering (src/lower.c, src/evm.c,
  src/ir.h) writes the five words and then the proof bytes after the
  scratch, does one STATICCALL to the address, and gives 1 only when
  the call succeeds, the return data is 32 bytes and the word is 1;
  else it gives 0. A failed call does not revert (the precompile path
  reverts). The call form is the mock form of O29 (no selector). On
  `langc run` the op runs the mock rule at the mock address and gives
  0 at another address (Q-S9-2 (a)). The mock verifier is a new
  `asmtool` runtime: it reverts when the calldata is not 192 bytes,
  and it returns the word 1 or 0 by the mock rule. A second new
  `asmtool` verb gives the mock proof of five words (Q-S9-4 (a)). The
  kit rows on `evm` against `langc run`: a correct proof (1), a wrong
  proof (0), the mock reverts (0), and an address with no code (the
  call succeeds with no return data: 0). The last two are the
  failing-call row of Q-S2-3 (a). The op name, the mock key K and the
  mock address (next to the token mock 0x..ee) are builder calls.
- O174 (S9 s2, the guest side, Q-S6-5 (a), O28, O93): `PolicyProof`,
  `PolicyOk` and the fifth `Op` `prove` in domain/domain.lang,
  examples/mandate.lang and examples/precompile.lang. One perl
  generator adds `PolicyOk` to each copy of the prelude in test/check
  (12 files have `policyVerifier`). For `policyVerifier == 0`,
  `PolicyOk` reduces to `Unit`, so the old rows keep their results.
  An IO script answers `prove` with a literal proof word from the
  `asmtool` verb of O173. The handler validates the response as O171
  requires; the response cannot supply replacement public inputs.
  Run rows must show that the correct proof reaches the continuation,
  while a wrong proof word, another cart's proof, another session's
  proof, a verifier address with no code and a malformed answer are
  refused before the continuation receives a `PolicyProof`. A new
  check row: a guest program that makes a `PolicyProof` term without
  `prove` is REFUSED.
- O175 (S9 s3, the contract, O117): the decoder of `check` and
  `execute` takes the proof as a `bytes` tail (the offset word, the
  length word, the data; Q-S9-1 (a)). The mock reads one word (length
  32). When `policyVerifier` is not 0, `check` calls the kit op of
  O173 with the five words of 4.9 and the proof bytes; it gives
  NO_POLICY (10u) when the op gives 0. This replaces the S7
  fail-closed NO_POLICY of O117. When `policyVerifier` is 0 there is
  no call. The gas and size rows of S7 change; s3 records the new
  numbers.
- O176 (S9 s3, the rows): the S7 rows "NO_POLICY (10u): grant with a
  policy verifier" (test/run/mandate.script, test/mandate-evm.script)
  become a spend with a correct mock proof (ok, one pay line) and the
  NO_POLICY refusal rows: no proof (length 0), a changed word, the
  proof of another cart, the proof of another session, and a verifier
  address with no code. test/diff.sh deploys the mock verifier, as it
  deploys the token mock, and runs the rows on `evm` against `langc
  run` (the differential rows with the mock).
- O177 (S9 s4, the docs and the close): the section "The zkpolicy
  condition (S9)" in docs/VALIDATION.md: the mock rule, the rows of
  O173, O174 and O176, and the BLOCKED row (O178). The final S9 gate. The
  mutants of the S8 and S9 rows come in S10 (section 9).
- O178 (S9 kickoff, the BLOCKED row, Q-S1-3 (a)): the row with the
  real verifier waits for zkpolicy-lang P10 (its EVM verifier; not
  started, it waits for zkml-lang Z9) and for the mandate instance of
  4.9 (the words in limbs, the cart binding by keccak in the circuit,
  the approving decision). P10 alone does not close it. The row needs
  an approving proof that succeeds, a valid proof of a denying
  decision that gives NO_POLICY, and the proof of an approved cart
  with another cart that gives NO_POLICY. If the P10 verifier has
  another call form, the kit op changes (O29). S9 closes without this
  row (Q-S9-4 (a)).
- O179 (S9 kickoff, the sessions, Q-S9-4 (a)): s1 the kit op and the
  mock verifier (O173); s2 the guest side (O174); s3 the contract and
  the rows (O175, O176); s4 the docs, the final gate and the close
  (O177). Each session runs its own gate. The kickoff closed none of
  O55, O60, O61, O66, O67 to O100 and O102 to O107; they stay open.
  O117 is S9 s3 work (O175). The next step is S9 s1
  (mandate-lang-work/S9-s1-PROMPT.md).
- O180 (S9 s1, the base): the Step 0 of s1 found HEAD c5b0114 (the
  USER S9 kickoff commit on 3074cd1) with the tree c785e6c8, not the
  tree 7ed369a7 of the kickoff stage: the USER commit edits O171, O174
  and O177. The USER RULED (a): c5b0114 is the S9 base.
- O181 (S9 s1, D2b, the proof form): the S7 `List U256` argument
  lowers to a calldata loop (src/lower.c: `ir_calldata` at `head + 32
  k`). The IR has no store of a word at a computed memory offset, thus
  a list cannot go into the call data of the STATICCALL. The proof p
  is one U256 word, and the call data is always 192 bytes (the five
  words, then p). The op cannot make a call of another length; the
  wrong-length row is a direct `evm run` of 160 bytes to the mock.
- O182 (S9 s1, D1, the op): `policyVerify v a b c d e p : Flag`
  (VIS_INTERNAL, OP_POLICY_VERIFY next to OP_ECRECOVER, the arity 7,
  the RULE_FIXED row of src/front/check.c). v : Addr is the verifier;
  a to e : U256 are policyId, domain, id, sid and cartHash of 4.9;
  p : U256 is the proof word. The result is flagYes or flagNo.
- O183 (S9 s1, D3 and D4, the mock key and the mock rule): K is
  0x6d616e646174652d6d6f636bu (the ASCII bytes "mandate-mock",
  right-aligned in the word). The proof word is correct when it equals
  keccak256 of the 192 bytes K, a, b, c, d, e. The mock runtime
  reverts when CALLDATASIZE is not 192; else it returns the word 1
  (correct) or 0.
- O184 (S9 s1, D5 and D6, the address and the asmtool verbs): the
  mock verifier is at 0x00000000000000000000000000000000000000ef (next
  to the token mock 0x..ee). `asmtool verifier` prints the mock runtime
  (asm.h has no CALLDATACOPY, thus five CALLDATALOAD and MSTORE pairs).
  `asmtool proof A B C D E` prints the mock proof word of the five
  words (hex, 0x optional). `asmtool proof 1 2 3 4 5` gives
  dc8004ddf654dce8070ef349963c6c9651b39f78359bf96b519811e811f03060.
- O185 (S9 s1, D7, the IR statement): IR_STMT_VERIFY (before
  IR_STMT_PRECOMPILE): local := 1 or 0. lower_verify (src/lower.c) has
  no memo: each use is one call. src/evm.c writes the six words at
  e->data, sets the return word to 0 first, and does STATICCALL with
  all the gas. The result is the AND of the success bit, RETURNDATASIZE
  EQ 32 and the return word EQ 1. There is no jump to e->revert: a
  failed call gives 0 (Q-S2-3 (a)). block_may_trap and block_words
  have no edit.
- O186 (S9 s1, D8, explicit host execution): `langc run` and `langc eval`
  use a separate definition cache. When all 7 arguments are closed, the
  host computes the result: flagYes when v is 0x..ef and p equals the
  mock proof of a to e, else flagNo (another address has no code, or
  code that the rule does not know). Checking and lowering keep every
  call opaque, including closed calls and cached helpers, so neither
  conversion checking nor compiled code can trust the mock rule.
- O187 (S9 s1, D9, the rows): examples/precompile.lang has the view
  `verifyPolicy v a b c d e p` after line 344 (the copy check of lines
  99 to 344 does not change). test/precompile.sh puts the mock
  verifier at 0x..ef in the alloc: the proof of the words 1 to 5 gives
  1, the word 9 gives 0, the address 0x..ab (no code) gives 0, and a
  direct `evm run` of 160 bytes to the mock reverts (31 steps, 0
  failures). test/run/precompile.script has the first three rows on
  `langc run` (flagYes, flagNo, flagNo); precompile.out changes by
  these 3 lines only.
- O188 (S9 s1, the gate): mandate-lang-work/S9-s1.sh (the copy of
  S9-k.sh; it also builds build/asmtool). `make -j 2 check` gives EXIT
  0 (mandate-lang-work/S9-s1-gate.log, 445 s). The compare with the
  S9 kickoff gate log gives FINAL DIFFERS: 2 GATE DIFF lines
  (mandate-lang-work/S9-s1.txt). The new rows add lines and change
  counts, thus a difference is expected. The git diff sha is the same
  before and after the run.
- O189 (S9 s2, D1, Q-S9-5 (a)): the s2 base is the USER S9 s1 commit
  f972a4f (tree bdf26bfa: the 12 s1 files and test/emittool.c,
  test/fronttool.c and test/lowertool.c, USER confirmed 2026-10-26).
  `policyCheck d m s c p : Flag` is `policyVerify (policyVerifier m)
  (policyId m) d (id m) (sid d m s) (cartHash d m s c) p`. `PolicyProof
  d m s c := (p : U256) * Path Flag (policyCheck d m s c p) flagYes` is
  a guest def in the model of `Signed`. The index values are d, m, s and
  c, with no type parameter; the term holds the proof word (D2b of
  O181). The five words come from the guest values, never from a
  response (O171). With open values a forged `pack w refl` is REFUSED;
  with closed values at gMandate the checker keeps `policyVerify`
  unreduced (trial: `pack 0u refl` gives PATH_END), thus a term comes
  from `prove` at run time; turn B checks the mock word at 0x..ef.
  Turn B result (2026-10-26): `langc --kit check` keeps `policyVerify`
  opaque at 0x..ef, also with the proof word of `asmtool proof` (PATH_END
  with p = 0x8902..6aa2). Thus a PolicyProof term at pMandate comes only
  from `prove` at run time. examples/precompile.lang has no static
  pMandate Spend term.
- O190 (S9 s2, D2, Q-S9-6 (a)): `PolicyOk d m s c := elim (fun (f :
  Flag) => Type 0) Unit (PolicyProof d m s c) (addrEq (policyVerifier m)
  0x00..00)`. The checker accepts the Flag elim to `Type 0` (trial
  2026-10-26), and `unit` checks at gMandate (the verifier 0). The `Sum`
  fallback is not necessary.
- O191 (S9 s2, D3): `Spend` ends `* (g : Gate d m s c spent k) *
  PolicyOk d m s c`. Each Spend term changes its last part G to `pack G
  unit` (9 terms in examples/precompile.lang, 8 in 6 test/check rows).
  The three defs of O189 and O190 go in the copy region before `Spend`
  (12 lines), thus the copy check of O187 covers the lines 99 to 356. No
  contract entry of examples/mandate.lang decodes a Spend.
- O192 (S9 s2, D4): the domain family `IO` adds `ioProve (proveOf :
  U256) (proveNext : U256 -> IO A)` (five operations).
  src/front/check.c: `IO_OP_COUNT = 5, IO_PURE = 5, IO_NOT = 6`, and
  io_ops adds `{"ioProve", "prove", 1u}`. `langc run` answers `prove`
  with one word (ARG_TYPE_U256).
- O193 (S9 s2, D5): examples/precompile.lang, after `show`: `proveWord`,
  `checkProof` (the model of checkSig, with `policyCheck`) and `prove R
  d m s c next`. The request word is `hash (sid d m s) (cartHash d m s
  c)`; the response is only p. flagNo gives `ioPure (Option R) none`: no
  continuation and no `PolicyProof` term.
- O194 (S9 s2, D6, the rows, turn B): pMandate (gMandate with the
  verifier 0x..ef) and nMandate (0x..ab, no code); the IO entry
  askProof; test/run/precompile-proof.script: the correct word (ok,
  some), a wrong word, the proof of another cart, of another session,
  nMandate (all none), and malformed responses (`prove 0xzz`, `prove 1u
  2u`: RUN_ANSWER or EVAL_ARGS before the continuation). PolicyOk rows:
  gMandate takes `unit`, pMandate does not.
  test/check/policy-proof-forged.lang: `pack 0u refl` at open d m s c is
  REFUSED.
  Turn B result (2026-10-26): DONE. examples/precompile.lang ends with
  pMandate, nMandate, gd1PolicyOk, askProof and askProofN (outside the
  copy region 99 to 356). test/run/precompile-proof.script: the correct
  word gives ok; the word 1u, the word of the sid 102u, the word of the
  cart hash plus 1 and askProofN at nMandate give revert. The two check
  rows use tMandate (the mandate of the model row
  cred-other-session.lang): policy-proof-forged.lang PATH_END,
  policy-ok-verifier.lang TYPE_MISMATCH; test/check/kit.txt lists
  both. run_refused: `prove 1u 2u` RUN_ANSWER (exit 1), `prove 0xzz` EVAL_ARGS (exit 2). test/run.sh: 16
  runs, 18 refusals, 0 failures. The s2 gate: EXIT 0, FINAL DIFFERS
  (expected).
- O195 (S9 s3, turn A, the decoder, O175, Q-S9-7 (a), Q-S9-8 (a), Q-S9-9
  (a)): mandate-lang-work/s3a/code.pl (counted `repn` edits;
  `split_expr` for the nested pair edits) changes `check` and `execute`
  of examples/mandate.lang. The fold Prod has 32 words: pl (the length
  word L, fold position 0, `first (second^30 ...)`) and pp (the proof
  word p, position 1, `second^31 ...`) go after ovf (now `first
  (second^29 ...)`). The header tests `(first a) Nu` go from 0..12 to
  2..14; the line test and the BAD_CALLDATA bound go from 12u to 14u.
  BAD_CALLDATA when L is not 0u and not 32u. NO_POLICY stays at the S7
  place: the verifier is not 0 and (L is 0u or `policyVerify
  (mPolicyVerifier s) (mPolicyId s) (domainOf env) (mId s) sid ch pp` is
  flagNo). ` 0u 0u` goes at the end of 77 check and execute rows of the
  8 mandate scripts. The copy region of test/precompile.sh does not
  change (copy EQUAL); no test/check file has a copy of `check`.
- O196 (S9 s3, turn A, the rows, O176, Q-S9-11 (a)):
  mandate-lang-work/s3a/rows.pl. test/run/mandate.script goes from 32 to
  40 rows, test/mandate-evm.script from 30 to 38 rows: a grant with the
  verifier 0x..ef, then the correct mock proof (0u); NO_POLICY (10u) for
  L 0u, a changed proof word, the proof of the cart hash plus 1 and the
  proof of the session 12u; BAD_CALLDATA (11u) for L 31u; a grant with
  0x..ab (no code), then the correct proof (10u). A grant with 0x..ef
  goes before the honest execute, which has the correct proof tail: the
  same pay line and Spent event. test/run/mandate.out is made again from
  `langc --kit run` (first the plain run was EQUAL to the old .out).
  test/run.sh: 16 runs, 18 refusals, 0 failures (no new run files).
- O197 (S9 s3, turn B, the allocs, Q-S9-10 (a)):
  mandate-lang-work/s3b/alloc.pl. test/diff.sh: `ver=` (0x..ef) after
  `token=`; after the mock line, `build/asmtool verifier >"$tmp/ver"`
  and `valloc`; `$valloc` at the end of the part 2 alloc. The part 1
  alloc has no verifier: part 1 runs examples/contract.lang (deposit,
  withdraw), with no policy call. test/evm.sh also runs
  test/mandate-evm.script on a chain: the verifier line after the mock
  line, and `ver=` and the alloc before `chain examples/mandate.lang`.
  Without this alloc the evm side gives 10u at the ok rows.
- O198 (S9 s3, the label cap, Q-S9-12 (a)): after O197, test/diff.sh
  gave 6 failures and test/evm.sh 2, with one cause: `langc --kit build
  examples/mandate.lang` gave EVM_SIZE. The EVM_SIZE text also covers
  the assembler tables. A scratch langc with raised caps and an ASMSTAT
  line in asm_finish (s3b/m1.sh, s3b/m2.sh): HEAD 1015 labels and 1077
  jumps; s3 1047 labels and 1109 jumps. ASM_LABELS (src/asm.h, 1024)
  trips; the byte limits and the jump cap (4096) do not. src/asm.h:
  `ASM_LABELS = 2048`. Asm is on the heap (src/evm.c:606, calloc): +12
  KB for each. src/evm.c:560 `uint64_t hits[ASM_LABELS]` is on the
  stack: 8 KB to 16 KB. src/evm.c:561 uses the same cap;
  test/asmtool.c:183 loops to ASM_LABELS. Then (s3b/b2.sh): the build
  EXIT 0 (creation 23388), test/asm.sh 8 of 8, test/run.sh 16 runs, 18
  refusals, 0 failures, test/diff.sh 21 rows, 0 failures, test/evm.sh 98
  steps, 0 failures.
- O199 (S9 s3, the gas and size, O142, O143): s3b/b3.sh runs the S7 gas
  copy (mandate-lang-work/S7-s3-r1b-gas.pl) with the new langc on the
  HEAD files (`git show HEAD:`) and on the s3 files. The HEAD run is
  EQUAL to the S7 table, thus the two runs use one measure. The grant:
  233442 (the same). check, HEAD to s3: gd1 152881 to 166592, gd2 164484
  to 178459, gd4 187521 to 202024, gd8 233533 to 249092, gc2 223120 to
  238415, gc4 340571 to 358506. execute, HEAD to s3: gd1 364952 to
  392282, gd2 336774 to 364632, gd4 382848 to 411762, gd8 474914 to
  505940, gc2 454130 to 484628, gc4 688948 to 724726. With no policy
  call (the gas script grants the verifier 0), depth 1 with 1 line adds
  13711 (check) and 27330 (execute); each extra level adds 264 and 528
  more, each extra line 1320 and 2640 more (probably each fold step
  copies the 2 more words). Depth 8: 249092 and 505940 (less than 2
  percent of 30000000; the O15 bound 8 stays). Sizes (`langc --kit build
  FILE`, `langc --kit build FILE --runtime`; the flag goes after the
  file): examples/mandate.lang creation 22482 to 23388, runtime 22457 to
  23363; examples/precompile.lang 1881 and 1861 (S9 s2 changed it from
  1725 and 1705).
- O200 (S9 s3, a bound for s4 onward): the runtime of
  examples/mandate.lang has 1213 bytes to the EIP-170 limit 24576 (95.1
  percent) and 1001 labels to the cap 2048. Before a change to
  examples/mandate.lang, measure both with a scratch langc (O198).
- O201 (S9 s3, the docs, Q-S9-13 (a)): mandate-lang-work/s3b/docs.pl
  (counted `repn` edits). docs/host/CAPABILITY.md C-K4-19: the headings
  "(slice S9 s3, ...)", the s3 gas table, the S7 values in one line, the
  cost of the 2 words, the size table and a label row.
  docs/host/README.md `## The mandate contract (slice S7)`: the proof
  tail of xs, a NO_POLICY row, the Prod of 32 words (pl, pp), rows 1 to
  38 and rows 39 and 40, the mock verifier at 0x..ef, and the gas and
  size lines. The S7 values stay in O142 and O143.
- O202 (S9 s3, the gate): mandate-lang-work/S9-s3.sh (log
  S9-s3-gate.log, S9-s3.txt): EXIT 0 in 766 s, FINAL DIFFERS (expected:
  new rows), the repo diff sha is the same after the gate. The lines
  that differ from the S9 s2 gate (< s2, > s3): < evm steps: 90 checked;
  > evm steps: 98 checked.
- O203 (S9 s4, the base): the Step 0 of s4 found HEAD dcf6fc8 (the USER
  S9 s3 commit on 97c8a8a) with the tree e6934e69 of the s3 stage, and
  an empty `git status --short`. dcf6fc8 is the s4 base.
- O204 (S9 s4, the docs, O177, Q-S9-14 (a), Q-S9-15 (a)):
  mandate-lang-work/s4/docs.pl (counted `repn` edits, a backup in
  s4/bak/) adds the section "The zkpolicy condition (S9)" at the end of
  docs/VALIDATION.md: the mock rule (O183, O184, O186), one table of 15
  rows (4 rows of O173, 6 rows of O174 and 5 rows of O176), the place of
  the runs, and the BLOCKED row of O178. After the final gate,
  mandate-lang-work/S9-s4-plan.pl writes the section 1 bullets of S9 s2,
  S9 s3 and S9 s4, the S9 row of section 9, O203 to O206, Q-S9-14 and
  Q-S9-15, because these lines give the gate result.
- O205 (S9 s4, the final S9 gate): mandate-lang-work/S9-s4.sh (log
  S9-s4-gate.log, S9-s4.txt): EXIT 0 in 893 s, FINAL SAME AS S9 S3
  FINAL: each result line is the same as in the s3 gate (s4 changes only
  docs). The repo diff sha is the same after the gate.
- O206 (S9 s4, the S9 close): S9 is DONE (O171 to O206): the kit op
  `policyVerify` and the mock verifier (s1), `PolicyProof`, `PolicyOk`
  and `prove` (s2), the proof tail and the NO_POLICY rows (s3), and the
  docs (s4). The row with the real verifier stays BLOCKED (O178): it
  waits for zkpolicy-lang P10 and the mandate instance of 4.9. The bound
  of O200 stays for each change to examples/mandate.lang. The next step
  is S10 (section 9: the mutants of the S8 and S9 rows, O177),
  mandate-lang-work/S10-kickoff-PROMPT.md.
- O207 (S10 kickoff, the base): the Step 0 of the kickoff found HEAD
  0703e66 (the USER S9 s4 commit on dcf6fc8) with the tree 0d91511a of
  the s4 stage, and an empty `git status --short`. 0703e66 is the S10
  base.
- O208 (S10 kickoff, the fresh gate): mandate-lang-work/S10-k.sh (log
  S10-k-gate.log, S10-k.txt): EXIT 0 in 723 s, FINAL SAME AS S9 S4
  FINAL: each result line is the same as in the S9 s4 gate. The repo
  diff sha is the same after the gate. The S9 s4 counts are the S10 base
  counts.
- O209 (S10 kickoff, the mutant method, O106, O140, Q-S10-1 (a), Q-S10-2
  (a)): each mutant runs in a scratch tree under $TMPDIR (a `git
  archive` copy of HEAD, or a copy of the working tree when the session
  has new rows); the main checkout does not change. A mutant is one `sd
  -F` edit of one site, with the count 1 checked before the edit and a
  copy of the original file. Before each edit, build the unmodified
  scratch tree and run the killing script: both must exit 0. The build
  is `make -B -j 2 build/langc build/asmtool build/slottool` (make 3.81
  compares mtimes to the second, thus -B); test/evm.sh and test/diff.sh
  need build/slottool through test/evmchain.sh. After the edit, repeat
  the build and the killing script. KILLED: a FAIL line for a reachable
  result row that passed on the unmodified tree. A missing tool or a
  setup failure is inconclusive, not a kill. When the script does not
  kill the mutant, `make -k -B -j 2 check` runs, and a FAIL line of
  another result row is a kill by that row after the same row passes on
  the unmodified tree. Any other nonzero exit is investigated before a
  KILLED or SURVIVED result is recorded. A
  build stop is not a kill (the TRAP of O140: a `||` mutant in a `&&`
  chain needs parentheses). A mutant of examples/mandate.lang that goes
  over the bound of O200 (EIP-170 or 2048 labels) is a build stop:
  change the mutant. After each mutant, the original file goes back and
  `cmp` checks it. A SURVIVED mutant gets a new row in the same session,
  then the mutant runs again (the model of S7 s2 resume 4).
- O210 (S10 kickoff, the mutants of the S8 rows, O148, O150, O166): each
  site is a hypothesis that s1 checks in examples/mandate.lang (the defs
  `check` and `execute`). G1a: the session compare of the cred check
  (WRONG_SESSION, 5u) goes out; killing row test/run/mandate-g1.script.
  G2a: the price goes out of the leaf hash; killing row the
  changed-price row (NO_PATH, 2u) of test/run/mandate-g2.script. G2b:
  the payee compare (WRONG_MERCHANT, 3u) goes out; killing row the
  changed-payee row of test/run/mandate-g2.script. G3a: the `autoLimit`
  compare changes from at or below to below; killing row a residual row
  of test/run/mandate-g3.script with the total at `autoLimit` (s1 checks
  that the row exists, else a new row). G3b: the confirm sig check
  (NEED_CONFIRM, 8u) goes out; killing row the residual row above
  `autoLimit` with no valid confirm sig. R1: the spent check (REPLAY,
  9u) goes out; killing row row 4 of test/run/mandate-honest.script. X1:
  the payer and the payee of the pay in `execute` change places; killing
  row test/run/mandate-x402.script (test/run.sh and part 2 of
  test/diff.sh).
- O211 (S10 kickoff, the mutants of the S9 rows, O173, O176, O182 to
  O187, O192 to O198, Q-S10-3 (a)): each site is a hypothesis that s2
  checks. L1: src/lower.c, the STUCK value of policyVerify: two input
  words change places; killing row the correct-proof kit row of O187
  (test/precompile.sh). L2: src/evm.c, IR_STMT_VERIFY: a failed
  STATICCALL reverts instead of returning flagNo. s2 first adds a
  reverting verifier alloc and a verifyPolicy call that expects 0 in
  test/precompile.sh, then uses that row as the killing row. The direct
  `evm run` of the mock with 160 input bytes only tests the mock's
  revert; it does not exercise policyVerify's handling of a failed
  call. The policy path in lower.c has no revert to remove (O173).
  E1: src/evm.c, IR_STMT_VERIFY: the final EVM_OP_AND of the three-way
  success, return-length and return-word test changes to EVM_OP_OR;
  killing row the wrong-proof kit row. This path has no ISZERO after
  STATICCALL. E2: src/evm.c, the input
  length of the STATICCALL is one word less; killing row the
  correct-proof kit row. H1: src/front/eval.c, the host rule of O186:
  the address test of 0x..ef goes out; killing row the NO_POLICY row
  with an address with no code (test/run/mandate.script, O196). H2: the
  host rule: the proof compare goes out; killing row the NO_POLICY row
  with a changed word. H3: src/front/eval.c, policy_verify: the
  `!m->policy_mock` guard goes out, so a closed call converts in
  checking; killing row a closed-call PATH_END refusal that s2 finds
  (else a new row). P1: the `prove` handler of `langc run`: the
  RUN_ANSWER refusal goes out; killing row run_refused `prove 1u 2u`
  (exit 1) of test/run.sh. P2: the EVAL_ARGS refusal goes out; killing
  row run_refused `prove 0xzz` (exit 2). D1: examples/mandate.lang, the
  decoder proof tail (O195): the length word L is not read; killing row
  the ok rows 39 and 40 of test/run/mandate.script. D2: the offset of
  the proof tail is one word more; killing row the ok rows 39 and 40.
  N1: the NO_POLICY test: the policyVerify result is not used; killing
  row the NO_POLICY row with a changed word. N2: the test of the
  verifier 0 (no call) inverts; killing row rows 1 to 38 of
  test/run/mandate.script. A1: test/diff.sh, the alloc of the mock
  verifier at 0x..ef goes out; killing row the ok rows of the
  differential (O197: the evm side gives 10u). A2: test/evm.sh, the same
  alloc; killing row the ok rows of test/mandate-evm.script. K1: the
  asmtool mock verifier (O183, O184): the mock rule changes one word of
  the proof; killing row the differential and the kit rows.
- O212 (S10 kickoff, the sessions, Q-S10-4 (a)): s1 the mutants of O210
  and the rows for SURVIVED mutants; s2 the mutants of O211 and their
  rows; s3 the docs (the section "The mutants (S10)" in
  docs/VALIDATION.md), the final gate and the close of the plan. The row
  with the real verifier stays BLOCKED (O178) after the close; a later
  slice can open the plan again for it. Each session has a gate. A
  session with new rows gives FINAL DIFFERS, and each GATE DIFF line
  must be a new row.
- O213 (S10 kickoff, the PLAN lines): mandate-lang-work/S10-k-plan.pl
  writes the section 1 bullet, the S10 row of section 9, O207 to O213
  and Q-S10-1 to Q-S10-4 after the fresh gate, because these lines give
  the gate result. The kickoff changes only docs/PLAN.md.

## 11. Questions for the USER (S1)

- Q1 (O3): reading of R1. (a) as intent-lang ruled: ambient Pi, Sigma,
  Path, U unlimited; declared constructors only CM and CC; the syntactic
  cell criterion. RECOMMENDED. (b) another reading. RULED (a).
- Q2 (O5): IO. (a) the free CM of the payment operations; the checker is
  the CC `Machine`. RECOMMENDED. (b) port the agent-lang interaction tree;
  R1 then needs a third class. RULED (a).
- Q3 (O6): the target. (a) one EIP-7702 delegate with `execute`, plus
  `check` that an x402 facilitator calls by `eth_call` before it relays
  `execute`. RECOMMENDED. (b) EIP-7702 only. (c) a facilitator check
  only; nothing on the chain enforces the mandate. RULED (a).
- Q4 (O7): the view. (a) the viewer signs one Merkle root over the
  listings that the user saw or approved, with `maxQty` per leaf; one view
  serves many sessions (the user present or not present). RECOMMENDED.
  (b) one view per session (the user present only). RULED (a).
- Q5 (O8): the credential. (a) a vault key apart from the agent key signs
  `Cred s`. RECOMMENDED. (b) the agent key signs it; the binding then
  holds only for an agent that is steered, not for a broken one. RULED
  (a).
- Q6 (O9): confirmation. (a) `autoLimit` over all spends of the mandate;
  above it each cart needs `Confirmed`. RECOMMENDED. (b) a limit per cart
  (an agent can split a spend). (c) confirm each cart. RULED (a).
- Q7 (O10): the token. (a) one ERC-20 per mandate (for x402 on Base, USDC)
  by the kit `pay`. RECOMMENDED. (b) native ETH too. RULED (a).
- Q8 (O11): the kernel route. (a) port from bridge-lang, plus the host
  `ecrecover` of intent-lang ef5abe8; leave out BN254, ElGamal, the ring
  signatures, `Enc` and the pool and bridge domain. RECOMMENDED. (b) port
  from intent-lang. RULED (a).
- Q9 (O12): kit additions. (a) add `chainid`, `self` and the byte form of
  `keccak` in mandate-lang. RECOMMENDED. (b) add them to the lang-template
  kit first (a USER commit there), then port. RULED (a).
- Q10 (O13): zkpolicy-lang. (a) no link in this plan. RECOMMENDED. (b)
  plan a slice now that adds a zkpolicy proof to `Gate`. RULED (b).

Q1 to Q10 are RULED 2026-10-24 (section 1). New questions (S1), RULED
2026-10-24 (section 1):

- Q-S1-1 (4.9): when a mandate needs a policy proof. (a) per mandate:
  `policyVerifier == 0` means none; for another mandate each spend needs
  one. RECOMMENDED. (b) each spend of each mandate needs one. (c) only
  above `autoLimit`, in place of `Confirmed` in `Gate`. RULED (a).
- Q-S1-2 (O30): the public inputs. (a) `policyId`, `domain`, mandate
  `id`, `sid`, `cartHash`. RECOMMENDED. (b) the same without `domain`
  (the S1 draft). (c) `cartHash` only. RULED (a).
- Q-S1-3 (4.9): the build route. (a) the mock verifier in S9 now; the row
  with the real verifier after zkpolicy-lang P10 (BLOCKED). RECOMMENDED.
  (b) S9 waits for zkpolicy-lang P10. RULED (a).
- Q-S1-4 (O27): the change in zkpolicy-lang (the limbs and the `cartHash`
  binding of 4.9). (a) record the request here; zkpolicy-lang does it in
  its own slice. RECOMMENDED. (b) mandate-lang wraps the proof: a wrapper
  contract changes the five words into the public part that zkpolicy-lang
  has. RULED (a).
- Q-S1-5 (O23): G1 of the paper. (a) 4.3 adds: `lookup` takes only the
  session, `Cred s` holds no user identifier, and the vault answers only
  for the sessions of its own mandate; S8 adds a run script for the paper
  form. RECOMMENDED. (b) keep 4.3 as it is. RULED (a).
- Q-S1-6 (O24): G2 of the paper. (a) keep Q4 (a); the residual of 4.5
  (O21) adds the unrequested item and the promoted or demoted item from
  the view; S8 adds a row for each of the five forms. RECOMMENDED. (b)
  the viewer signs only the listings that the user approved for the
  request; then the two forms give `NO_PATH`, but a view for a user who
  is not present must list the approved items in advance. RULED (a).
- Q-S1-7 (O25): G3 of the paper. (a) keep the `autoLimit` rule of Q6
  (a): the paper rule asks for no confirmation when the intent states a
  budget, and each mandate states `cap`; S8 adds a G3 row below
  `autoLimit` (the residual) and one above it (`NEED_CONFIRM`).
  RECOMMENDED. (b) add the paper rule too: each leaf gets `floor` (the
  lowest price of a listing for the same need, from the viewer), and
  `Gate` also needs `Confirmed` when a line has `price l > floor l`.
  RULED (a).

New questions (S2 and S3): all RULED (a) 2026-10-24 (section 1). S2 applied the (a) option where the text says
"applied". A ruling (b) undoes that part in S3.

- Q-S2-1 (O34): the contract writer of bridge-lang. (a) drop it now; the
  mandate contract writer comes in S7. RECOMMENDED; applied. (b) keep the
  writer and change its cast (the cast needs bLSAG, a Q8 (a) leave-out).
- Q-S2-2 (O36): the ZK surface of orbit-lang S8 B2b. (a) drop it now with
  bLSAG; the policy proof surface comes in S9 (4.9). RECOMMENDED;
  applied. (b) keep it for S9.
- Q-S2-3 (O43): the failed-STATICCALL revert path of lower.c has no test
  now. (a) keep it without a test in S2; the S9 STATICCALL policy
  verifier op (4.9, O12) adds a failing precompile row. RECOMMENDED. (b)
  add a test-only failing precompile now.
- Q-S2-4 (O53): examples/dao.lang. (a) keep the DAO prelude as kernel
  text without the private ballot defs `b0`, `w0`, `c0` and `complete`.
  RECOMMENDED; applied. (b) drop dao.lang and dao3.lang with their eval
  and check rows.
- Q-S3-1 (O58): F16 to F19 in formers/FORMERS.md. (a) port the four
  sections, the Fin kit note and their matrix rows from bridge-lang in S4
  Step 0 as a docs change. RECOMMENDED. (b) keep F1 to F15 and the CM and
  CC rows only.
- Q-S3-2 (O59): the name of the swap. (a) keep `bagComm` as the swap of
  4.4; PLAN 4.4 names it. RECOMMENDED; applied. (b) rename `bagComm` to
  `swap` in domain/domain.lang, the examples and the eval rows.

New questions (S4), RULED (a) 2026-10-24 (section 1):

- Q-S4-1 (O64): keccak256 of 3 or 4 words for the EIP-712 domain
  separator and the struct hashes of 4.8. (a) fixed-arity `hash3` and
  `hash4` with the plumbing of `hash` and the save and restore of
  KECCAK712 for the words past the scratch. RECOMMENDED; RULED. (b) one
  `hashWords : List U256 -> U256` that lowers only a literal list.

New questions (S5), RULED (a) 2026-10-24 (section 1):

- Q-S5-1 (O68): the type of the `Prov` index. (a) `i : Nat`; `natDiv` and
  `natMod` work end to end, and a `Nat` is one word on the chain.
  RECOMMENDED; RULED. (b) new `u256` div and mod ops, to keep `i : U256`.
- Q-S5-2: the EIP-712 domain of `Signed` in `View m`. (a) `Signed d a g =
  (x : Sig) * Path Flag (signedAs d g x a) flagYes` and `View d m = (root
  : Hash) * Signed d (viewer m) (hash3 viewType root (id m))`, where `d`
  is `hash3` of the domain type hash, `chainid` and `self` from `Env`.
  RECOMMENDED; RULED. (b) a 12th `Mandate` field `domain m`.
- Q-S5-3: the EVM rows of `merkle`. (a) fixed-depth views (`merkle2 i leaf
  s1 s0` by 2 `mstep` calls) in test/precompile.sh with WANT from a direct
  evm run, and an eval row that shows that `merkle` on a 2-element list
  gives the same word; the `List` form comes on the chain in S7 by the
  decoder (O15). RECOMMENDED; RULED. (b) a `List` calldata argument in the
  kit in S5.
- Q-S5-4: the leaf hash. (a) `listingHash l = hash4 (addrToU256 (merchant
  l)) (sku l) (price l) (maxQty l)`; the viewer signs only the root, so a
  leaf is not a signed struct. RECOMMENDED; RULED. (b) an EIP-712 struct
  hash of a `Listing` type hash and the 4 words.
- Q-S5-5 (O77): the EVM rows of `merkle`. (a) one view for each side bit
  (`hashL`, `hashR`), no kit change. (b) a word select op (for example
  `u256If : Flag -> U256 -> U256 -> U256`), so that `side` lowers and the
  chain runs `merkle2`. RECOMMENDED; RULED (s1b: `flagIf` is the select, O79). (c) K4c lowers a Nat fold at a
  word position as a loop. (d) no Merkle EVM rows in S5.

New questions (S6), kickoff 2026-10-25 (section 1):

- Q-S6-1 (O86): the form of `IO`. (a) extend the R1 cell check to admit
  a strictly positive field `D -> F params` (D closed data); `IO` in
  domain/domain.lang with a word response; the guest defs of the typed
  operations check the response at run time; `langc run` gets a form
  that answers the operations (s2). (b) a first-order `IO`. (c) move `IO`
  after S7. RULED (a).
- Q-S6-2 (O88): the product in `total`. (a) a kit op `u256Mul` (a trap on
  overflow). (b) repeated `u256Add`. RULED (a).
- Q-S6-3 (O88): the key of a closed `Confirmed`. (a) a public test key
  (anvil account 0) is the viewer of a second demo mandate; `cast wallet
  sign --no-hash` signs off line; the S5 demo terms stay. (b) sign demoView
  again with the test key. (c) refusal rows only. RULED (a).
- Q-S6-4 (O88): the form of `Gate`. (a) a Flag select (one Sig). (b) `Sum
  (Le (spent + total) autoLimit) (Confirmed s c k)`. RULED (b).
- Q-S6-5: the `prove` operation of `Op`. (a) S9 adds it with
  `PolicyProof`; S6 has `show`, `lookup`, `confirm` and `submit`. (b) S6
  adds it with a placeholder response. RULED (a).
- Q-S6-6 (O82): the form of `Lt now (expiry m)`. (a) `def Lt a b` is
  `Path Flag (flagIf (u256Eq a b) flagNo (u256Le a b)) flagYes`, the form
  of `canonStep`. (b) `Le (now + 1) (expiry m)`. RULED (a).
- Q-S6-7 (O97): the response of `confirm`. (a) the field `confirmNext`
  takes the closed data `Prod Nat (Prod U256 U256)` (the form of `Sig`);
  the R1 field rule admits it; a script answer line has three words. (b)
  three word responses: v, then r, then s (three `ioConfirm` steps). (c)
  the response word is a handle, and `lookup` gives the parts.
  RECOMMENDED (a). RULED (a).
- Q-S6-8 (O98): the form that gives `confirm` the path of a `Signed`
  from a response that is not closed (`flagIf` is not dependent; `elim`
  took Sum, Unit and domain families only). (a) a dependent `elim` on
  Flag; `confirm` uses the inspect form, and the no case reverts. (b) a
  kit op `flagAssert b : Path Flag b flagYes` (a trap on flagNo). (c) no
  kit change; `confirm` gives the raw Sig. RECOMMENDED (a). RULED (a).

New questions (S7), kickoff 2026-10-25 (section 1):

- Q-S7-1 (O112): the source of the contract. (a) a guest contract in a
  new file examples/mandate.lang: a `state` (the mandate words, `spent`,
  `used`, `revoked`), the entries `grant`, `revoke` and `execute`, and
  the view `check`, built by `langc build` with the kit lowering. It
  copies the defs from `Hash` to `Spend` of examples/precompile.lang,
  and a gate row compares the two copies. No C writer (Q-S2-1).
  RECOMMENDED; RULED. (b) a C writer of the four entries, as the writer of
  bridge-lang. (c) the mandate state and the entries go into
  examples/precompile.lang (no copy; the S4 `sign` entry and its rows
  change).
- Q-S7-2 (O113): the calldata of `check` and `execute`. (a) a kit
  change: an entry argument of type `List U256` (the ABI `uint256[]`),
  lowered by a CALLDATALOAD loop to the list form. A `langc run` script
  gives the list as words. The guest decoder reads the spend from the
  list; a short or a bad list gives BAD_CALLDATA (O115). Carts of all
  lengths, and the Merkle depth to 8 (O15). RECOMMENDED; RULED. (b) word
  arguments only: a cart of 1 line at Merkle depth 2, at most 32 words,
  no kit change; more lines after S7.
- Q-S7-3 (O110, 4.7): `Machine`, `Req` and the differential. (a)
  `cofamily Machine (A : Type 0) := mCorec (eps : A) (step : Req ->
  Machine A)` in domain/domain.lang (the S4 cocell check: a labelled
  cofield over closed data). `Req` is `List U256`: the four words of the
  `Env` (O112: domain/domain.lang cannot name `Env`), the selector and
  the arguments. `step` is the guest decoder and the entry. The
  differential runs each call script on `langc run` and on `evm`
  (test/evmchain.sh), as part 2 of test/diff.sh. `submit` of `IO` stays
  one word; the rows from an IO script to the chain come in S8.
  RECOMMENDED; RULED. (b) as (a), but `submit` sends the calldata list and
  takes the code, thus one IO script drives the guest and `evm` in S7
  (the run law of 4.7 in S7). (c) `Req` is a family of typed calls, and
  the decoder is outside of `Machine`.
- Q-S7-4 (O127): the text of the List field refusal for the `List U256`
  argument (src/lower.c `value_name`). It said "the Env or the state as
  one value". (a) `value_name` gives "a List U256 argument" when
  `is_list_arg` (one change; the list-outside-fold text is then correct).
  RECOMMENDED; RULED (2026-10-25). (b) Keep the text; an O item only.
- Q-S7-5 (O131): the lowering of the decoder fold. (a) a kit change in
  src/lower.c: a `fold` over the `List U256` argument with a right-nested
  Prod of words as the accumulator (at most 32 words, as
  ENTRY_PARAMS_MAX); `first` and `second` of the accumulator lower to its
  slots. The decoder is one guest fold, as Q-S7-2 (a): all cart lengths,
  the Merkle depth to 8, the same term on `langc run` and on `evm`
  (Q-S7-3). RECOMMENDED; RULED (2026-10-25). (b) a kit op `listAt xs i`
  (one CALLDATALOAD, 0 past the end) and folds with a word accumulator
  only: the decoder reads the header words by index and unrolls the
  Merkle path to depth 8 and the cart to a fixed bound, thus the cart
  length gets a bound.
- Q-S7-6 (O133): a trap in one part of a Prod fold accumulator. (a)
  src/front/eval.c `pair_trap` and `fold_acc`: `reduce_fold_list` puts
  Z and each step through `fold_acc`, thus a pair accumulator with a
  trapped part is that trap, as in the evm loop; src/lower.c checks
  `step_must_trap (F x trap)` for a word or a pair accumulator.
  RECOMMENDED; RULED (2026-10-25). (b) Keep eval; a REFUSE_LOWER of a
  pair fold that can trap, plus kit ops that do not trap. (c) Every pair
  with a trapped part is a trap.
- Q-S7-7 (O134): the decoder and the missing U256 to Nat op. (a) Guest
  only, no kit change: the v word to the Nat 27 or 28 by `flagIf`
  (another word gives the address 0, O116), one direction word for each
  sibling in place of the leaf index (0u or 1u, else BAD_CALLDATA), a
  U256 depth counter. RECOMMENDED; RULED (2026-10-25). (b) A kit op
  `toNat : U256 -> Nat` (an eval trap over 2^64 - 1, an evm range revert
  for parity, lower rows, mutants); the layout keeps the leaf index.
- Q-S7-8 (O135): (i) the merchant Addr for `pay`. (a) A kit op `toAddr
  : U256 -> Addr` (a trap when the high 96 bits are not 0, the same
  check on evm, lower rows, mutants). RECOMMENDED. (b) The merchant
  address in the mandate state (one merchant for each grant). RULED (b)
  (2026-10-25). (ii) The code for qty more than maxQty. (a) NO_PATH.
  RECOMMENDED; RULED (2026-10-25). (b) BAD_CALLDATA.
- Q-S7-9 (O141): the mandate differential. (a) test/diff.sh part 2
  also runs test/mandate-evm.script (the chain id 1337; the end
  storage and the mock balances); test/evm.sh keeps its mandate chain
  (each step: the result, the storage, the logs). The gate takes
  about 3 minutes more. RECOMMENDED; RULED (2026-10-25). (b) Move the
  mandate chain from test/evm.sh to test/diff.sh (evm steps 90 to
  60). (c) Keep it in test/evm.sh only, with a mock balance check at
  the end.
- Q-S7-10 (O141): the spends of the gas ladder (O114). (a) A call
  script test/run/mandate-gas.script and its .out (test/run.sh checks
  them); a runner in the work dir measures the gas once with `evm run
  --statdump`; the values go in docs/host/CAPABILITY.md, as C-K4-19.
  RECOMMENDED; RULED (2026-10-25). (b) As (a), and test/diff.sh part
  2 also runs the gas script on `evm`. (c) The spends stay in the work
  dir; only the table goes in docs/host/CAPABILITY.md.
- Q-S7-11 (O142): the closed gas spends. Part 1, the file of the
  guest terms. (a) examples/precompile.lang, after `def tGateLe` (as
  tSpend); the closed defs do not go in the code. RECOMMENDED. (b) A
  new example file for the gas spends. RULED (a) (2026-10-26). Part
  2, the program of the call script. (a) test/run.sh removes the
  script name from the first dash, thus test/run/NAME-X.script runs
  examples/NAME.lang (no script name has a dash now). RECOMMENDED.
  (b) A map of script names to programs in test/run.sh. RULED (a).
  Part 3, the path of each spend. (a) The confirm path: the autoLimit
  100u (as tMandate) and each total 200u, thus each spend needs the
  confirm sig (3 ecrecover calls, the worst case, as tSpend).
  RECOMMENDED. (b) The auto path: each total at or below the
  autoLimit (no confirm sig). RULED (a).
- Q-S8-1 (O146, O149, section 8): the form of the attack corpus. (a)
  one call script per attack and one for the honest spend
  (test/run/mandate-honest, mandate-g1, mandate-g2 and mandate-g3, the
  NAME-PART form on examples/mandate.lang), each on `langc run` and on
  `evm` (part 2 of test/diff.sh), plus one IO script of the honest
  spend whose `submit` links to the result of `check` on the chain
  (Q-S7-3 (a)). RECOMMENDED. (b) one call script
  test/run/mandate-attacks.script with all rows; the IO-to-chain rows
  go to S9. RULED (a) (2026-10-26).
- Q-S8-2 (O148, O23, Q-S1-5 (a)): the rows of G1 in the paper form. (a)
  two check rows, a cred sig by another vault key (the credential of
  another user) and a cred sig of another session from the same vault,
  both WRONG_SESSION (5u), and one refusal row in test/check: a guest
  `lookup` with a user argument does not type check. RECOMMENDED. (b)
  the two check rows only; the type side stays a note in 4.3. RULED (a)
  (2026-10-26).
- Q-S8-3 (O148, O24, O25, 4.5): the residual rows (G2: an unrequested
  item and a promoted or demoted item, when the listing is in the view;
  G3: a price over the cheapest matching item). (a) for each of the
  three forms, a row at or below `autoLimit` that `check` accepts (0u;
  the loss is at most `autoLimit`), a row above `autoLimit` with no
  valid confirm sig (NEED_CONFIRM, 8u) and a row above `autoLimit` with
  the confirm sig (0u); the three refused forms of G2 get one refusal
  row each. RECOMMENDED. (b) only the row at or below `autoLimit` for
  each form. RULED (a) (2026-10-26).
- Q-S8-4 (O150, O18, Q3 (a)): the x402 route. (a) the route stays
  `check` by `eth_call` plus `execute`; s3 adds a call script in the
  facilitator order (`check`, `execute`, a second `execute` of the same
  session) on `langc run` and on `evm`, and a doc section; O18 is a
  source read of the USDC token code, recorded in an O item, with no
  row. RECOMMENDED. (b) as (a), plus an ERC-1271 `isValidSignature`
  entry in the contract and rows with a mock EIP-3009 token. RULED (a)
  (2026-10-26).
- Q-S8-5 (O149, Q-S8-1 (a), Q-S7-3 (a)): the IO-to-chain row. The IO
  answer form cannot refer to the result of a call script, and `submit`
  stays one word, thus the link is by value. (a) a new entry askSpend in
  examples/precompile.lang: one agent program `show`, `lookup`,
  `confirm`, then `submit` of the sid word; it gives some only when the
  submit answer is codeOk (0u). An IO script gives the answers of the
  honest spend with `submit 0u` (ok) and with `submit 9u` (REPLAY,
  revert). (b) the existing entries askView, askLookup 11u, askConfirm
  and askWord in one IO script (4 steps, the link in a comment). (c)
  defer the row to S9. RULED (a) (2026-10-26).

S9 kickoff (2026-10-26, claude7): the USER RULED Q-S9-1 to Q-S9-4 by
AskUserQuestion: all (a).

- Q-S9-1 (O175): the proof in the calldata of `check` and `execute`.
  (a) a `bytes` tail (the offset word, the length word, the data); the
  mock reads one word; the real proof needs no decoder change.
  RECOMMENDED. (b) one fixed word now; the real row changes the
  decoder and the gas and size rows. RULED (a) (2026-10-26).
- Q-S9-2 (O173): `langc run` for the kit op, and the mock failures.
  (a) `langc run` runs the mock rule at the mock address and gives 0
  at another address; the mock returns 0 for a wrong proof and reverts
  on a wrong calldata length; the rows: ok, wrong proof, revert, no
  code. RECOMMENDED. (b) the run script states the answer of the call
  (the rule on one side only). RULED (a) (2026-10-26).
- Q-S9-3 (O174): the place of `PolicyOk`. (a) a factor of `Spend` next
  to `Gate` (4.9); one perl generator updates each prelude copy in
  test/check. RECOMMENDED. (b) `PolicySpend`, the S6 `Spend` with
  `PolicyOk`; the S6 `Spend` does not change. RULED (a) (2026-10-26).
- Q-S9-4 (O179): the sessions and the answer of `prove`. (a) four
  sessions (s1 the kit op, s2 the guest side, s3 the contract and the
  rows, s4 the close); the IO script answers `prove` with a literal
  word from a new `asmtool` verb; the real row stays BLOCKED and S9
  closes without it. RECOMMENDED. (b) three sessions (s1 the kit op
  and the guest side). RULED (a) (2026-10-26).
- Q-S9-5 (O174, s2 turn 1, 2026-10-26): the form of `PolicyProof`. (a) a
  guest def in the model of `Signed` (D1); (b) a new C type former with
  no guest intro (only the C run handler makes a term). The USER RULED
  (a) (O189).
- Q-S9-6 (O174, s2 turn 1, 2026-10-26): the form of `PolicyOk`. (a)
  first try the Flag elim to `Type 0` with `Unit` (D2); if the checker
  refuses it, use the `Sum` form and record the reason. The USER RULED
  (a); the checker accepts the elim (O190).
- Q-S9-7 (O175, s3 turn 1, 2026-10-26): the form of the proof tail in
  xs. (a) fixed 2 words: xs ends with the proof word p, then the length
  word L (0u or 32u; another L gives BAD_CALLDATA); the 13 header
  positions shift by 2; two new slots pl and pp at the end of the Prod
  (32 words). The USER RULED (a) (O195).
- Q-S9-8 (O175, s3 turn 1): the rows with no verifier. (a) each check
  and execute row gets ` 0u 0u` at the end of xs. Default (a) taken
  (O195).
- Q-S9-9 (O175, s3 turn 1): the place of NO_POLICY in the code chain.
  (a) the S7 place, now "the verifier is not 0 and (L is 0u or
  policyVerify ... p is flagNo)". Default (a) taken (O195).
- Q-S9-10 (O176, s3 turn 1): the differential. (a) test/diff.sh puts the
  mock verifier at 0x..ef next to the token mock; the policy rows stay
  in test/run/mandate.script and test/mandate-evm.script. Default (a)
  taken (O197; test/evm.sh also needs the alloc).
- Q-S9-11 (O176, s3 resume1): the place of the ok execute with the
  verifier. grant keeps `used s`, and REPLAY is before NO_POLICY. (a)
  the check rows go at rows 20 to 30; a grant with 0x..ef goes before
  the honest execute, which gets the correct proof tail. Default (a)
  taken (O196).
- Q-S9-12 (O198, s3 resume2): the label cap. (a) src/asm.h `ASM_LABELS`
  1024 to 2048; (b) fewer labels in examples/mandate.lang (one NO_POLICY
  test for check and execute; this changes the O175 design). Default (a)
  taken (O198).
- Q-S9-13 (O201, s3 resume3): the docs rows. (a) the S7 gas and size
  rows of docs/host/CAPABILITY.md and docs/host/README.md get the s3
  values, with one line of the S7 values; (b) the docs stay at S7, only
  the PLAN O rows get the s3 values. Default (a) taken (O201).
- Q-S9-14 (O204, s4 turn 1, 2026-10-26): the form of the S9 section of
  docs/VALIDATION.md. (a) one section at the end, after "The x402 route
  (S8)": the mock rule as a list, one table (Slice, Row, Form, Result)
  in the model of the S8 attack table, the place of the runs, then the
  BLOCKED row; (b) one section for each session. Default (a) taken
  (O204).
- Q-S9-15 (O204, s4 turn 1): the time of the PLAN close lines. (a) the
  PLAN script writes the section 1 bullets, the S9 row of section 9 and
  the O rows after the final gate, because they give the gate result;
  docs.pl changes only docs/VALIDATION.md; (b) docs.pl writes them
  before the gate. Default (a) taken (O204).
- Q-S10-1 (O209, kickoff 2026-10-27): the run of each mutant. (a) `make
  -B -j 2 build/langc build/asmtool build/slottool`, then the test script
  of the killing row, first on the unmodified scratch tree and then on
  the mutant; `make -k -B -j 2 check` only for a mutant that the script
  does not kill. RECOMMENDED. (b) `make -k -B -j 2 check` for each
  mutant (the method of S6 and S7, about 15 min for each mutant). RULED
  (a).
- Q-S10-2 (O209): a SURVIVED mutant. (a) a new row that kills it in the
  same session, then the mutant runs again (the model of S7 s2 resume
  4). RECOMMENDED. (b) record it as SURVIVED, with no new row. RULED
  (a).
- Q-S10-3 (O211): the test harness. (a) mutants of src/,
  examples/mandate.lang, the two allocs of the mock verifier
  (test/diff.sh, test/evm.sh) and the asmtool mock. RECOMMENDED. (b)
  mutants of src/ and examples/mandate.lang only. RULED (a).
- Q-S10-4 (O212): the close. (a) s3 closes the plan; the row with the
  real verifier stays BLOCKED (O178), and a later slice can open the
  plan again for it. RECOMMENDED. (b) S10 closes the mutants only; the
  plan stays open until the row is done. RULED (a).
