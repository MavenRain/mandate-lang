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
state (the mandate, `spent`, the used session numbers, `revoked`). `step`
runs one request. The agent program is a CM term and the checker is a CC
term. A run interprets `submit` by one `step` and the other operations by
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
| S7 | `Machine`; the contract of section 7; the decoder; the differential; gas and size rows | PLANNED |
| S8 | The attack corpus: the three attacks of the paper (G1 in the paper form, Q-S1-5; one row for each of the five forms of G2, Q-S1-6; G3 below and above `autoLimit`, Q-S1-7), the honest spend, the residual of 4.5; the x402 route | PLANNED |
| S9 | zkpolicy condition (4.9): `PolicyOk`, `PolicyProof`, the `prove` operation, the STATICCALL kit op (O12), the mock verifier, the `NO_POLICY` refusal rows, the differential rows with the mock; the row with the real verifier is BLOCKED on zkpolicy-lang P10 and the mandate instance of 4.9 (field encoding, cart binding, approving decision) | PLANNED |
| S10 | Mutants and close | PLANNED |

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
  measures the gas and can change the bound. Builder call.
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
