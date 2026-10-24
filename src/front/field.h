/* The generic field and a = 0 curve layer, split from front/bn254.c of
   intent-lang ef5abe8 (S2, the field split). Ported there from glue-lang
   src/front/fr.c at cded21d (the field part, with the modulus as a
   parameter). This layer has no BN254 constant: front/secp256k1.c gives its
   own p and n.

   An element is 8 limbs of 32 bits, least significant first, with a value in
   [0, m) for its modulus m. The arithmetic uses uint64_t intermediates only
   (no __int128), so that TinyCC builds it. */
#ifndef LANG_FRONT_FIELD_H
#define LANG_FRONT_FIELD_H

#include <stdint.h>

#include "front/u256.h"

#define FE_LIMBS 8u

/* A modulus m. */
typedef struct {
  uint32_t w[FE_LIMBS];
} Modulus;

typedef struct {
  uint32_t w[FE_LIMBS];
} Fe;


/* Returns 1, or 0 when X is F or more. */
int fe_from_u256(Fe *out, const U256 *x, const Modulus *f);
void fe_to_u256(U256 *out, const Fe *x);
void fe_from_u64(Fe *out, uint64_t n);
void fe_add(Fe *out, const Fe *a, const Fe *b, const Modulus *f);
void fe_sub(Fe *out, const Fe *a, const Fe *b, const Modulus *f);
void fe_neg(Fe *out, const Fe *a, const Modulus *f);
void fe_mul(Fe *out, const Fe *a, const Fe *b, const Modulus *f);
/* A^E for any 256-bit E. */
void fe_pow(Fe *out, const Fe *a, const U256 *e, const Modulus *f);
/* The inverse of A:  A^(m minus 2) (Fermat), thus 0 at 0. */
void fe_inv(Fe *out, const Fe *a, const Modulus *f);
int fe_eq(const Fe *a, const Fe *b);
/* 1 when A is less than B. */
int fe_lt(const Fe *a, const Fe *b);

/* A point of a curve in affine form. (0, 0) is the point at infinity. */
typedef struct {
  Fe x;
  Fe y;
} EcPoint;

/* The group operations on a curve y^2 = x^3 + b over the field F (a = 0;
   the formulas do not use b), for the secp256k1 of front/secp256k1.c. Each
   operation takes points on the curve. OUT can be A or B. */
void ec0_double(EcPoint *out, const EcPoint *a, const Modulus *f);
void ec0_add(EcPoint *out, const EcPoint *a, const EcPoint *b, const Modulus *f);
void ec0_mul(EcPoint *out, const EcPoint *p, const U256 *k, const Modulus *f);

#endif
