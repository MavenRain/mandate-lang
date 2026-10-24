# mandate-lang design

The USER request of 2026-10-24, verbatim. The pasted brief is in its place
in the request.

## Request

I want to build a programming language with the following features:

The type constructors/higher-kinded types are restricted to cell monads and their duals in a locally presentable locally cartesian closed \((\infty,1)\)-category, as realized computationally in Cubical Type Theory

As for base types and operations, as well as compilation target, take the minimum required to satisfy the following:

```text
mandate-lang: agent payment mandates (recommended)

  - Activity: Chainalysis counted 138.5M AI-agent x402 payments on Base in Q3
    2026, up from 58,800 a year earlier. Monthly active x402 senders rose 152%
    to 43,100 in mid-October. Dollar volume is still small: about $24M over 30
    days in July.
  - The gap: A September 2026 paper, "Signing the Transaction but Not the
    Decision" (arXiv 2609.11757), shows that Google's AP2 payment protocol signs
    the cart but nothing ties the cart to what the user saw. Text on a
    merchant's product page can steer the agent. The three attacks succeed 90%,
    56% and 73.3% of the time.
  - The language:
    - A spending mandate is a type.
    - Each cart line must carry a path back to the product listing the user saw.
    - Each credential lookup is tied to the session that asked for it.
    - That turns the paper's two fixable attacks into type errors.
    - The third attack, a false stock claim, leaves no structural trace. The
      language needs an explicit "ask the user to confirm this spend" operation
      for it.
  - Target: EVM, either as an EIP-7702 delegate contract or as a check run by an
    x402 payment facilitator. It reuses agent-lang's IO and your EVM toolkit.
  - Overlap: zkpolicy-lang proves that an agent followed a policy. mandate-lang
    covers the payment authorization, so the two fit together without
    duplicating.
```

Finally, the host language shall be TinyCC.
