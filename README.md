# mandate-lang

mandate-lang is a Cubical TT language for agent payment mandates. A
spending mandate is a type. Each cart line holds a path back to a listing
that the user saw. Each payment credential is indexed by the session that
asked for it. A spend above the limit of the user needs an explicit
confirmation. The only type constructors are cell monads and their duals.
The host is TinyCC. The compiler writes EVM bytecode: an EIP-7702 delegate
contract with a check entry for x402 payment facilitators.

mandate-lang comes from lang-template with the tcc-evm-contract host.

- `design/DESIGN.md`: the request and the brief, verbatim. It is the only
  source of the core types and the core operations.
- `docs/PLAN.md`: the rulings, the reading of the type-former ruling, the
  minimal base signature, the readings of the brief, the laws, the kernel
  route, the contract, the slices, the open items and the questions.
- `SPEC.md`: the specification. Fill each section.
- `formers/FORMERS.md`: the type formers. `formers/tcc-evm-contract.md`
  gives their status on the tcc-evm-contract host.
- `probe/CAPABILITY.md`: the host probe.
- `docs/STATUS.md` and `docs/VALIDATION.md`: the status and the gate
  results.
- `docs/host/README.md`: how to build and test the host kit, and how to
  replace the sample domain in `domain/`.
