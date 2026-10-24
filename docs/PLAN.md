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
(a)) and bridge-lang took (bridge-lang Q1 (a)). Here it is not ruled yet
(Q1).

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
indexed families `Line m s`, `Cart m s`, `Cred s`, `Confirmed s c` and
`Spend m` (index values, no type parameter) are admitted, as `Pool k` is in
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
S7 has the host form). No BN254, no ElGamal, no ring signatures.

| Name | Kind | Reading |
|---|---|---|
| Hash | defined | `U256`, one keccak256 word |
| Sig | defined | `U256 * U256 * U256` (v, r, s) |
| signer | defined | `ecrecover` of an EIP-712 digest; the zero address is no signer |
| Mandate | defined | a record: `owner`, `agent`, `viewer`, `vault`, `token`, `cap`, `autoLimit`, `expiry`, `id` (4.1) |
| Listing | defined | `(merchant : Addr) * (sku : U256) * (price : U256) * (maxQty : U256)` |
| View m | defined | `(root : Hash) * Signed (viewer m) (root, id m)`: the Merkle root of the listings that the user saw or approved (4.2) |
| Session m | defined | `(sid : U256) * (merchant : Addr) * View m` |
| Prov v l | defined | `(i : U256) * (sib : List Hash) * Path Hash (merkle i (hash l) sib) (root v)` (4.2) |
| Line m s | defined | `(l : Listing) * (q : U256) * Prov (view s) l * Path Addr (merchant l) (merchant s) * Le q (maxQty l)` |
| Cart m s | defined | `Bag (Line m s)` (4.4) |
| Cred s | defined | `Signed (vault m) (sid s, merchant s, root (view s))` (4.3) |
| Confirmed s c | defined | `Signed (viewer m) (sid s, cartHash c, claimHash)` (4.5) |
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
        * Gate m s c
Gate m s c = if spent m + total c <= autoLimit m then Unit else Confirmed s c
```

`total c` is the sum of `price l * q` over the lines. A line has no amount
field: the amount comes from the listing that the user saw. `spent m` is
contract state, so `Spend m` is a type over the state of the checker.

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

Residual risk (O9, O21): below `autoLimit`, a false claim can still steer
a spend of listings that the user saw, at most `maxQty` each. The loss from
this attack is at most `autoLimit` for the mandate.

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
| `submit` | the checker | a receipt or a refusal code |

We take the agent-lang design of IO (the operation signature, the host
interpreter, `confirm`). We do not take its other operations (model, files,
terminal). The guest evaluator answers the operations from a `langc run`
script, which plays the user, the viewer, the vault and the merchant.

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

The EIP-712 domain holds `chainid` and `self`. Under EIP-7702 `self` is
the user account, so a signature for one user does not verify for another
user or on another chain.

## 5. Laws

| Law | Form in mandate-lang |
|---|---|
| provenance | each line of a spend has `Prov` into the signed view (4.2) |
| shown price | the paid amount is `total c`, from the listings only (4.1) |
| session binding | `Cred s` pays only for `Cart m s` (4.3) |
| budget | `spent` does not decrease, and `spent <= cap` in each state |
| gate | a spend that passes `autoLimit` has `Confirmed` (4.5) |
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
| `grant` | `self` (the user sends to the own account) | stores the mandate, `spent = 0` |
| `revoke` | `self` | sets `revoked` |
| `check` | any (view) | decodes the spend, returns 0 or the refusal code of 4.8; no state change |
| `execute` | any (the agent or a facilitator) | `check`, marks `sid` used, adds `total c` to `spent`, `pay token merchant (total c)`, emits `Spent(sid, cartHash, total)` |

The x402 route (Q3 (a)): the facilitator runs `check` by `eth_call` in its
verify step. Its settle step sends `execute`. So the facilitator needs no
user key, and a facilitator that skips its own check still cannot move
tokens that the mandate does not allow. Size and gas rows per entry
(EIP-170, EIP-3860) come in the contract slice. The Merkle depth bounds
the gas of `check` (O15).

## 8. Tests

- Guest files: the mandate example, one refusal row for each guest type
  error of 4.8, evals for each law of section 5.
- `langc run` scripts: one script per attack of the brief (4.2, 4.3, 4.5)
  and one honest spend, on the guest evaluator.
- The differential: the same scripts on the guest evaluator and on geth
  `evm`, with the mock token of the kit.
- The `ecrecover` rows: EIP-712 digests and signatures, host against
  `evm`.

## 9. Slices

| Slice | Content | Status |
|---|---|---|
| S0 | Seed: the template with the tcc-evm-contract host, the design verbatim, this plan, the kit gate GREEN, the private remote | DONE |
| S1 | USER rulings on the questions of section 11; record them; read arXiv 2609.11757 and check the attack mapping (O4) | PLANNED |
| S2 | Kernel port (section 6); the gate counts of the source | PLANNED |
| S3 | R1 in this repo: `REFUSE_CELL`, the former matrix as CM and CC rows, `Bag` with `swap` | PLANNED |
| S4 | Base signature: `Hash`, `Sig`, `signer`, EIP-712 digests, `Env` `chainid` and `self`, the byte form of `keccak` (O12) | PLANNED |
| S5 | `Mandate`, `Listing`, `View`, `Prov` (Merkle path), `Line`, `Cart`, `cartHash`; the provenance refusals | PLANNED |
| S6 | `Session`, `Cred s`, `Confirmed`, `Gate`, `Spend`; `IO` and its operations; the run scripts | PLANNED |
| S7 | `Machine`; the contract of section 7; the decoder; the differential; gas and size rows | PLANNED |
| S8 | The attack corpus (the three attacks of the brief, the honest spend, the residual of 4.5); the x402 route | PLANNED |
| S9 | Mutants and close | PLANNED |

## 10. Open items

- O1: the name mandate-lang. Builder call.
- O2: the kit hosts/tcc-evm-contract; `pay` is an ERC-20 `transfer` with
  the contract as the sender. Builder call.
- O3: the reading of R1 (section 2), as intent-lang ruled it. Q1.
- O4: the attack model is the brief's summary of arXiv 2609.11757. The
  builder has not read the paper: it is newer than the builder's
  knowledge. The brief gives the rates 90%, 56% and 73.3% but does not
  say which rate goes with which attack. S1 reads the paper and checks the
  mapping of 4.2, 4.3 and 4.5. Builder call.
- O5: IO is the free CM of the payment operations, not the interaction
  tree of agent-lang (4.6). Q2.
- O6: the target: one EIP-7702 delegate with `check` for x402
  facilitators (section 7). Q3.
- O7: the view: one Merkle root over the listings that the user saw or
  approved, with `maxQty` in each leaf (4.2). Q4.
- O8: the credential: a vault key apart from the agent key (4.3). Q5.
- O9: the gate: `autoLimit` over all spends of the mandate (4.5). Q6.
- O10: the token: one ERC-20 per mandate. Q7.
- O11: the kernel route (section 6). Q8.
- O12: kit additions: `Env` `chainid` and `self`; a byte form of
  `keccak`, because the EIP-712 digest hashes the two bytes 0x19 0x01
  before two words. Q9.
- O13: zkpolicy-lang proves that an agent followed a policy. This plan
  does not use it. A later slice can add a zkpolicy proof as one more
  `Gate` condition. Q10.
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

## 11. Questions for the USER (S1)

- Q1 (O3): reading of R1. (a) as intent-lang ruled: ambient Pi, Sigma,
  Path, U unlimited; declared constructors only CM and CC; the syntactic
  cell criterion. RECOMMENDED. (b) another reading.
- Q2 (O5): IO. (a) the free CM of the payment operations; the checker is
  the CC `Machine`. RECOMMENDED. (b) port the agent-lang interaction tree;
  R1 then needs a third class.
- Q3 (O6): the target. (a) one EIP-7702 delegate with `execute`, plus
  `check` that an x402 facilitator calls by `eth_call` before it relays
  `execute`. RECOMMENDED. (b) EIP-7702 only. (c) a facilitator check
  only; nothing on the chain enforces the mandate.
- Q4 (O7): the view. (a) the viewer signs one Merkle root over the
  listings that the user saw or approved, with `maxQty` per leaf; one view
  serves many sessions (the user present or not present). RECOMMENDED.
  (b) one view per session (the user present only).
- Q5 (O8): the credential. (a) a vault key apart from the agent key signs
  `Cred s`. RECOMMENDED. (b) the agent key signs it; the binding then
  holds only for an agent that is steered, not for a broken one.
- Q6 (O9): confirmation. (a) `autoLimit` over all spends of the mandate;
  above it each cart needs `Confirmed`. RECOMMENDED. (b) a limit per cart
  (an agent can split a spend). (c) confirm each cart.
- Q7 (O10): the token. (a) one ERC-20 per mandate (for x402 on Base, USDC)
  by the kit `pay`. RECOMMENDED. (b) native ETH too.
- Q8 (O11): the kernel route. (a) port from bridge-lang, plus the host
  `ecrecover` of intent-lang ef5abe8; leave out BN254, ElGamal, the ring
  signatures, `Enc` and the pool and bridge domain. RECOMMENDED. (b) port
  from intent-lang.
- Q9 (O12): kit additions. (a) add `chainid`, `self` and the byte form of
  `keccak` in mandate-lang. RECOMMENDED. (b) add them to the lang-template
  kit first (a USER commit there), then port.
- Q10 (O13): zkpolicy-lang. (a) no link in this plan. RECOMMENDED. (b)
  plan a slice now that adds a zkpolicy proof to `Gate`.
