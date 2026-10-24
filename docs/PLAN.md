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

Builder calls (NOT ruled; section 10 gives each one, section 11 gives the
questions):

- O1: the name mandate-lang (from the brief).
- O2: the kit is hosts/tcc-evm-contract (U256, Addr, Env, `pay`, `pull`,
  events). `pay` calls `transfer(to, amount)` of the token with the
  contract as the sender. Under EIP-7702 the contract is the user account,
  so `pay` spends the user's tokens.
- Tests are guest-language files plus `langc run` scripts. The kit gate
  scripts stay. We add no new harness.

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
| Sig | defined | `U256 * U256 * U256` (v, r, s) |
| signer | defined | `ecrecover` of an EIP-712 digest; the zero address is no signer |
| Mandate | defined | a record: `owner`, `agent`, `viewer`, `vault`, `token`, `cap`, `autoLimit`, `expiry`, `id`, `policyVerifier`, `policyId` (4.1, 4.9) |
| Listing | defined | `(merchant : Addr) * (sku : U256) * (price : U256) * (maxQty : U256)` |
| View m | defined | `(root : Hash) * Signed (viewer m) (root, id m)`: the Merkle root of the listings that the user saw or approved (4.2) |
| Session m | defined | `(sid : U256) * (merchant : Addr) * View m` |
| Prov v l | defined | `(i : U256) * (sib : List Hash) * Path Hash (merkle i (hash l) sib) (root v)` (4.2) |
| Line m s | defined | `(l : Listing) * (q : U256) * Prov (view s) l * Path Addr (merchant l) (merchant s) * Le q (maxQty l)` |
| Cart m s | defined | `Bag (Line m s)` (4.4) |
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
the free commutative monoid (a QIT with a `swap` path constructor). Each
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
| S3 | R1 in this repo: `REFUSE_CELL`, the former matrix as CM and CC rows, `Bag` with `swap` | PLANNED |
| S4 | Base signature: `Hash`, `Sig`, `signer`, EIP-712 digests, `Env` `chainid` and `self`, the byte form of `keccak` (O12) | PLANNED |
| S5 | `Mandate`, `Listing`, `View`, `Prov` (Merkle path), `Line`, `Cart`, `cartHash`; the provenance refusals | PLANNED |
| S6 | `Session`, `Cred s`, `Confirmed`, `Gate`, `Spend`; `IO` and its operations; the run scripts | PLANNED |
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

New questions (S2), OPEN. S2 applied the (a) option where the text says
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
