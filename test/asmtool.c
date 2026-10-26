/* The self-test of the assembler, keccak and the ABI selectors.
   Usage: asmtool            runs the checks; exit 0 when all pass
          asmtool runtime    the runtime hex of a program that returns 42
          asmtool creation   the creation hex of that program
          asmtool abi        the `langc abi` line of addPrice(Nat, Flag) */
#include <stdio.h>
#include <string.h>

#include "asm.h"
#include "keccak.h"
#include "target.h"

enum { CHECKS = 8 };

static void to_hex(const unsigned char *bytes, size_t size, char *text) {
  for (size_t i = 0; i < size; i++) snprintf(text + 2 * i, 3, "%02x", bytes[i]);
  text[2 * size] = '\0';
}

/* Returns 1 when the hex of keccak256(INPUT) starts with WANT, else 0 after
   a FAIL line. */
static int check_keccak(const char *input, const char *want) {
  unsigned char digest[32];
  char text[65];
  keccak256((const unsigned char *)input, strlen(input), digest);
  to_hex(digest, 32, text);
  if (strncmp(text, want, strlen(want)) == 0) return 1;
  printf("FAIL keccak256(\"%s\"): want %s, got %s\n", input, want, text);
  return 0;
}

/* Jumps forward to `start`, which jumps back to `back`, which returns the
   word 42. */
static int answer(Asm *a, FILE *err) {
  asm_init(a);
  Label start = asm_label(a);
  Label back = asm_label(a);
  asm_jump(a, start);
  asm_jumpdest(a, back);
  asm_push(a, 42);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_MSTORE);
  asm_push(a, 32);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_RETURN);
  asm_jumpdest(a, start);
  asm_jump(a, back);
  return asm_finish(a, err);
}

/* MLOAD of the word at memory offset AT. */
static void mload(Asm *a, uint64_t at) {
  asm_push(a, at);
  asm_op(a, EVM_OP_MLOAD);
}

/* Memory offset TO gets the call data word at offset AT. */
static void arg(Asm *a, uint64_t at, uint64_t to) {
  asm_push(a, at);
  asm_op(a, EVM_OP_CALLDATALOAD);
  asm_push(a, to);
  asm_op(a, EVM_OP_MSTORE);
}

/* Returns the word VALUE. */
static void return_word(Asm *a, uint64_t value) {
  asm_push(a, value);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_MSTORE);
  asm_push(a, 32);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_RETURN);
}

/* The mock ERC-20 token of slice K4d (C-K4d-3) for the CALL tests: the
   runtime of transfer(address,uint256) (from is the caller) and
   transferFrom(address,address,uint256). Slot 0 is the mode: 0 moves and
   returns the word 1, 1 returns the word 0 with no move, 2 moves and returns
   empty data, any other mode reverts. The balance of an address is at the
   slot equal to the address word. A move has no balance check and no
   allowance check (wrapping SUB, then ADD: a move to the sender keeps the
   balance) and makes one LOG3 Transfer(from, to) with the amount as data.
   Memory: 0x00 the amount, 0x20 from, 0x40 to. Another selector reverts. */
static int mock(Asm *a, FILE *err) {
  const char *event = "Transfer(address,address,uint256)";
  unsigned char topic[32];
  keccak256((const unsigned char *)event, strlen(event), topic);
  asm_init(a);
  Label transfer = asm_label(a);
  Label from = asm_label(a);
  Label move = asm_label(a);
  Label stop = asm_label(a);
  Label no = asm_label(a);
  Label revert = asm_label(a);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_CALLDATALOAD);
  asm_push(a, 0xe0);
  asm_op(a, EVM_OP_SHR);
  asm_op(a, EVM_OP_DUP1);
  asm_push(a, 0xa9059cbb);
  asm_op(a, EVM_OP_EQ);
  asm_jump_if(a, transfer);
  asm_push(a, 0x23b872dd);
  asm_op(a, EVM_OP_EQ);
  asm_jump_if(a, from);
  asm_jump(a, revert);
  asm_jumpdest(a, transfer);
  asm_op(a, EVM_OP_POP);
  asm_op(a, EVM_OP_CALLER);
  asm_push(a, 0x20);
  asm_op(a, EVM_OP_MSTORE);
  arg(a, 0x04, 0x40);
  arg(a, 0x24, 0x00);
  asm_jump(a, move);
  asm_jumpdest(a, from);
  arg(a, 0x04, 0x20);
  arg(a, 0x24, 0x40);
  arg(a, 0x44, 0x00);
  asm_jumpdest(a, move);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_SLOAD);
  asm_op(a, EVM_OP_DUP1);
  asm_push(a, 2);
  asm_op(a, EVM_OP_LT); /* 2 < mode */
  asm_jump_if(a, revert);
  asm_op(a, EVM_OP_DUP1);
  asm_push(a, 1);
  asm_op(a, EVM_OP_EQ);
  asm_jump_if(a, no);
  mload(a, 0x00);
  mload(a, 0x20);
  asm_op(a, EVM_OP_SLOAD);
  asm_op(a, EVM_OP_SUB);
  mload(a, 0x20);
  asm_op(a, EVM_OP_SSTORE);
  mload(a, 0x00);
  mload(a, 0x40);
  asm_op(a, EVM_OP_SLOAD);
  asm_op(a, EVM_OP_ADD);
  mload(a, 0x40);
  asm_op(a, EVM_OP_SSTORE);
  mload(a, 0x40); /* topic 2: to */
  mload(a, 0x20); /* topic 1: from */
  asm_push_word(a, topic);
  asm_push(a, 32);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_LOG3);
  asm_push(a, 2);
  asm_op(a, EVM_OP_EQ);
  asm_jump_if(a, stop);
  return_word(a, 1);
  asm_jumpdest(a, stop);
  asm_op(a, EVM_OP_STOP);
  asm_jumpdest(a, no);
  return_word(a, 0);
  asm_jumpdest(a, revert);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_REVERT);
  return asm_finish(a, err);
}

static int check_answer(const Asm *a) {
  static const char want[] = "61000d565b602a5f5260205ff35b61000456";
  char text[2 * sizeof want];
  int ok = 2 * a->size + 1 == sizeof want;
  if (ok) to_hex(a->code, a->size, text);
  if (ok && strcmp(text, want) == 0) return 1;
  printf("FAIL answer: the code differs from %s\n", want);
  return 0;
}

/* asm_finish refuses an unbound label, a stray label and a full label table. */
static int check_refusals(FILE *quiet) {
  static Asm a;
  asm_init(&a);
  asm_jump(&a, asm_label(&a));
  int unbound = !asm_finish(&a, quiet);
  asm_init(&a);
  asm_bind(&a, 7);
  int stray = !asm_finish(&a, quiet);
  asm_init(&a);
  for (size_t i = 0; i <= ASM_LABELS; i++) asm_label(&a);
  int full = !asm_finish(&a, quiet);
  if (unbound && stray && full) return 1;
  printf("FAIL refusals: unbound %d, stray %d, full %d\n", unbound, stray, full);
  return 0;
}

/* One row with each scalar type, then the Trap() selector of C-K4-9 (a
   name with no parameters). */
static int abi(FILE *out, FILE *err) {
  static const IrScalar params[] = {IR_SCALAR_NAT, IR_SCALAR_FLAG, IR_SCALAR_U256, IR_SCALAR_ADDR};
  IrFunc fn;
  IrFunc trap;
  memset(&fn, 0, sizeof fn);
  memset(&trap, 0, sizeof trap);
  fn.name = "addPrice";
  fn.params = params;
  fn.param_count = 4;
  trap.name = "Trap";
  return target_abi_line(&fn, out, err) && target_abi_line(&trap, out, err);
}

static int checks(const Asm *runtime) {
  FILE *quiet = fopen("/dev/null", "w");
  int passed = check_keccak("", "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470")
             + check_keccak("abc", "4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45")
             + check_keccak("transfer(address,uint256)", "a9059cbb")
             + check_keccak("transferFrom(address,address,uint256)", "23b872dd")
             + check_keccak("approve(address,uint256)", "095ea7b3")
             + check_keccak("balanceOf(address)", "70a08231")
             + check_answer(runtime)
             + check_refusals(quiet != NULL ? quiet : stderr);
  if (quiet != NULL) fclose(quiet);
  printf("asmtool: %d of %d checks passed\n", passed, CHECKS);
  return passed == CHECKS ? 0 : 1;
}

/* The mock policy verifier of S9 s1 (O173, D3 and D4). The call data is the
   five words policyId, domain, id, sid and cartHash, then the proof word.
   Call data of other than 192 bytes reverts. The result is the word 1 when
   the proof word equals keccak256 of the key K and the five words, else 0.
   K is the ASCII bytes "mandate-mock", right-aligned in the word. */
static const unsigned char MOCK_KEY[12] = {'m', 'a', 'n', 'd', 'a', 't', 'e', '-', 'm', 'o', 'c', 'k'};
static const char HEX[] = "0123456789abcdef";

static int verifier(Asm *a, FILE *err) {
  unsigned char key[32] = {0};
  memcpy(key + 20, MOCK_KEY, sizeof MOCK_KEY);
  asm_init(a);
  Label revert = asm_label(a);
  asm_op(a, EVM_OP_CALLDATASIZE);
  asm_push(a, 192);
  asm_op(a, EVM_OP_EQ);
  asm_op(a, EVM_OP_ISZERO);
  asm_jump_if(a, revert);
  asm_push_word(a, key);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_MSTORE);
  for (uint64_t i = 0; i < 5u; i++) arg(a, 32u * i, 32u * (i + 1u));
  asm_push(a, 192);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_SHA3);
  asm_push(a, 160);
  asm_op(a, EVM_OP_CALLDATALOAD);
  asm_op(a, EVM_OP_EQ);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_MSTORE);
  asm_push(a, 32);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_RETURN);
  asm_jumpdest(a, revert);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_PUSH0);
  asm_op(a, EVM_OP_REVERT);
  return asm_finish(a, err);
}

/* Reads the hex word TEXT (0x is optional, 64 digits or fewer) into W, big
   endian and padded on the left. Returns 0 on a bad digit. */
static int hex_word(const char *text, unsigned char w[32]) {
  const char *digits = strncmp(text, "0x", 2) == 0 ? text + 2 : text;
  size_t n = strlen(digits);
  int ok = n > 0 && n <= 64;
  memset(w, 0, 32);
  for (size_t i = 0; ok && i < n; i++) {
    const char *at = strchr(HEX, digits[n - 1u - i] | 0x20);
    ok = at != NULL && *at != '\0';
    if (ok) w[31u - i / 2u] |= (unsigned char)((at - HEX) << (4u * (i % 2u)));
  }
  return ok;
}

/* Writes the mock proof word of the five words in ARGS: keccak256 of the key
   K and the five words (S9 s1, D4). */
static int proof(char *const *args, FILE *out, FILE *err) {
  unsigned char input[192] = {0};
  unsigned char digest[32];
  char text[65] = {0};
  memcpy(input + 20, MOCK_KEY, sizeof MOCK_KEY);
  for (size_t i = 0; i < 5u; i++)
    if (!hex_word(args[i], input + 32u * (i + 1u))) return fprintf(err, "asmtool: bad word %s\n", args[i]), 0;
  keccak256(input, sizeof input, digest);
  to_hex(digest, sizeof digest, text);
  return fprintf(out, "%s\n", text) > 0;
}

int main(int argc, char **argv) {
  static Asm runtime;
  static Asm creation;
  static Asm token;
  static Asm verify;
  const char *mode = argc == 2 ? argv[1] : "";
  if (argc == 7 && strcmp(argv[1], "proof") == 0) return proof(argv + 2, stdout, stderr) ? 0 : 1;
  if (argc > 2) return fputs("usage: asmtool [runtime|creation|abi|mock|verifier|proof A B C D E]\n", stderr), 2;
  if (!answer(&runtime, stderr)) return 1;
  if (strcmp(mode, "mock") == 0) return mock(&token, stderr) && asm_write_hex(&token, stdout, stderr) ? 0 : 1;
  if (strcmp(mode, "verifier") == 0) return verifier(&verify, stderr) && asm_write_hex(&verify, stdout, stderr) ? 0 : 1;
  if (strcmp(mode, "runtime") == 0) return asm_write_hex(&runtime, stdout, stderr) ? 0 : 1;
  if (strcmp(mode, "creation") == 0) return asm_creation(&creation, &runtime, stderr) && asm_write_hex(&creation, stdout, stderr) ? 0 : 1;
  if (strcmp(mode, "abi") == 0) return abi(stdout, stderr) ? 0 : 1;
  if (argc == 2) return fputs("usage: asmtool [runtime|creation|abi|mock|verifier|proof A B C D E]\n", stderr), 2;
  return checks(&runtime);
}
