# Capability probe (slice K1)

Date: 2026-10-07. Machine: macOS, AArch64.

## Tools

- tcc 0.9.28rc 2026-09-04 mob@0fb54300
- geth `evm` 1.14.12-stable
- anvil 0.3.0 (5a8bd89)

## Results

1. `evm run --code HEX` runs the code and writes `0x<output>`. `test/asm.sh` uses it. The runtime of the test program returns the word 42. The creation code returns the runtime. Both pass.
2. `evm transition` (t8n) and `evm statetest` are in geth 1.14.12. K1 did not run a fixture through them.
3. anvil 0.3.0 is installed. It needs a local port and a process that runs for the full test. K1 did not start it.
4. The escrowc precedent (escrow-lang `settlement.py`) chains the state with `evm --verbosity 0 run --prestate FILE --gas GAS --input DATA --value VALUE --json --dump`. Each call reads the state that the previous call wrote.

## Recommendation for K4

- Use the escrowc path: chains of `evm run --prestate ... --dump`. It needs no port and no daemon, and escrowc uses it now.
- Use `evm statetest` only if K4 needs a transaction context that `run` does not give (a nonce, a deploy transaction, a gas price).
- Do not use anvil in the gate. It needs a port and a long-lived process.

## K4 result (slice K4d)

- K4 uses the escrowc path. `test/evm.sh` runs 6 chains of `evm run --prestate ... --dump` (43 steps). `test/diff.sh` runs the CALL failure table (10 rows) and 5 call scripts on the mock ERC-20 at the token address. The gate uses no t8n, no statetest and no anvil.
- Each pay and each pull is one CALL to the token (C-K4d-6). Pay is `transfer(payTo, payAmount)`. Pull is `transferFrom(pullFrom, pullTo, pullAmount)`. The contract is the sender.
- Each CALL forwards all gas (`GAS`) and 0 wei (C-K4d-7). There is no gas cap.
- The CALL must succeed. Its return data must either be 32 bytes equal to the word 1, or be empty with code at the token (`EXTCODESIZE`). If either check fails, the step does a REVERT with empty data (C-K4-14).

## Gas of each chain step (C-K4-19)

Measured on 2026-10-10 at LT 382e224 with geth `evm` 1.14.12: each step of `test/evm.sh` and `test/diff.sh` again with `evm run --statdump`. The value is the gas of the execution. `evm run` does not add the intrinsic gas of a transaction. The list does not include the deploy steps. The gate does not check the gas, and there is no cap.

| Chain of `test/evm.sh` | Program | Gas of each step |
| --- | --- | --- |
| `test/run/basic.script` | `test/contract-nocall.lang` | 22267, 2276, 2269, 27471, 2275, 27786 |
| `test/run/map.script` | `examples/map.lang` | 44473, 27373, 2334, 2334, 10273, 2334 |
| `test/run/residuals.script` | `examples/residuals.lang` | 6817, 2321, 149, 109, 44460, 26881, 5320, 9617, 315 |
| `test/run/events.script` | `examples/events.lang` | 24355, 7255 |
| `test/run/lists.script` | `examples/lists.lang` | 2399, 2342, 2378, 44415, 4638, 71653, 9158, 9435, 27315, 11418, 11778, 16381, 16466, 11418, 2409 |
| `test/same-state.script` | `test/same-state.lang` | 3542, 23597, 3542, 6497, 3542 |

`test/diff.sh` runs `examples/contract.lang` with the mock:

- Part 2, `test/run/basic.script` (mode 0): 73471, 2276, 2318, 80738, 2275, 27786. Step 1 (deposit 5u) does one pull CALL. Step 4 (withdraw 2u) does one pay CALL. Steps 2 and 3 revert before the CALL.
- Part 1, deposit 30u (one pull) with mode 0, 1, 2, 3 and no code: 73471, 27441, 73459, 27249, 25184. Withdraw 30u (one pay), same order: 80738, 34708, 80726, 34516, 32461.
- The other 4 scripts of part 2 use the same gas as in `test/evm.sh`.

### The mandate contract (slice S9 s3, O142)

Measured on 2026-10-26 on the S9 s3 work tree (base 97c8a8a) with geth `evm` 1.14.12: a copy of `test/diff.sh` runs `test/run/mandate-gas.script` on `examples/mandate.lang` (the mock in mode 0 at 0x..ee, the chain id 1337), and each step again with `evm run --statdump`. The value is the gas of the execution, as above: it does not include the intrinsic gas of a transaction (21000 and the calldata). The grant is 233442. Each spend has a new session and the total 200u, and each spend needs the confirm signature (3 ecrecover calls, the worst case). The grant has no policy verifier (the address 0), thus `check` and `execute` do not call a verifier. The gate runs the script with `langc run` (`test/run.sh`), not on the EVM, and does not check the gas.

| Spend | Lines | Merkle depth | `check` | `execute` |
| --- | --- | --- | --- | --- |
| gd1Spend | 1 | 1 | 166592 | 392282 |
| gd2Spend | 1 | 2 | 178459 | 364632 |
| gd4Spend | 1 | 4 | 202024 | 411762 |
| gd8Spend | 1 | 8 | 249092 | 505940 |
| gc2Spend | 2 | 2 | 238415 | 484628 |
| gc4Spend | 4 | 2 | 358506 | 724726 |

- Each extra Merkle level adds about 11800 gas to `check` and about 23600 to `execute`.
- Each extra line adds about 60000 gas to `check` and about 120000 to `execute`.
- The `execute` of gd1Spend is more than the `execute` of gd2Spend. It is the first pay, thus it probably writes storage slots that are zero (the spent amount and the mock balances).
- The S7 values (base 17d50a4), in the order of the table: `check` 152881, 164484, 187521, 233533, 223120, 340571; `execute` 364952, 336774, 382848, 474914, 454130, 688948. The same copy of `test/diff.sh` on the files of HEAD 97c8a8a gives these values again, thus the two tables use one measure.
- The S9 s3 decoder reads 2 more words (the proof tail, O175). With no policy call, at depth 1 with 1 line, this adds 13711 gas to `check` and 27330 to `execute`. Each extra Merkle level adds 264 and 528 more, and each extra line 1320 and 2640 more. Probably each step of the fold copies the 2 more words of the accumulator.
- The Merkle depth is at most 8 (O15). The bound stays (O143): depth 8 costs 249092 for `check` and 505940 for `execute` (less than 2 percent of the block gas limit 30000000).

### Code size (slice S9 s3, O141 and O143)

`build/langc --kit build FILE` (the creation code) and `build/langc --kit build FILE --runtime` (the runtime; the flag goes after the file), on 2026-10-26 on the S9 s3 work tree:

| Program | Creation code (EIP-3860 limit 49152) | Runtime (EIP-170 limit 24576) |
| --- | --- | --- |
| `examples/mandate.lang` | 23388 | 23363 (1213 bytes free, 95.1 percent) |
| `examples/precompile.lang` | 1881 | 1861 |

- The S7 values: `examples/mandate.lang` 22482 and 22457 (2119 bytes free, 91.4 percent), `examples/precompile.lang` 1725 and 1705. S9 s2 changed `examples/precompile.lang`. S9 s3 adds 906 bytes to `examples/mandate.lang`.
- The S9 s3 build of `examples/mandate.lang` uses 1047 labels and 1109 jumps (HEAD 97c8a8a: 1015 and 1077). The assembler tables have 2048 labels (`ASM_LABELS` in `src/asm.h`, 1024 before S9 s3) and 4096 jumps. With 1024 labels, the S9 s3 build gives EVM_SIZE.

A large change to `examples/mandate.lang` can go over the EIP-170 limit.

## Open


- A t8n or statetest run with a fixture (two transactions on one pre-state): not done. K4 did not need it: the `run --prestate` path is sufficient for the chain test and the differential test.
