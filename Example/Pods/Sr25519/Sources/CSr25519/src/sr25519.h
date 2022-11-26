#ifndef __SR25519_H__
#define __SR25519_H__

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef uint8_t sr25519_mini_secret_key[32];
typedef uint8_t sr25519_secret_key[64];
typedef uint8_t sr25519_secret_key_key[32];
typedef uint8_t sr25519_secret_key_nonce[32];
typedef uint8_t sr25519_chain_code[32];
typedef uint8_t sr25519_public_key[32];
typedef uint8_t sr25519_keypair[96];
typedef uint8_t sr25519_signature[64];
typedef uint8_t sr25519_vrf_output[32];
typedef uint8_t sr25519_vrf_io[64];
typedef uint8_t sr25519_vrf_proof[64];
typedef uint8_t sr25519_vrf_out_and_proof[96];
typedef uint8_t sr25519_vrf_proof_batchable[96];
typedef uint8_t sr25519_vrf_raw_output[16];
typedef uint8_t sr25519_vrf_threshold[16];

typedef enum Sr25519SignatureResult {
    Ok,
    EquationFalse,
    PointDecompressionError,
    ScalarFormatError,
    BytesLengthError,
    NotMarkedSchnorrkel,
    MuSigAbsent,
    MuSigInconsistent,
} Sr25519SignatureResult;

typedef struct VrfResult {
    Sr25519SignatureResult result;
    bool is_less;
} VrfResult;


/*
 * keypair: the output ed25519 compatible keypair, 96 bytes long
 * seed: the input mini secret key, 32 bytes long
*/
void sr25519_keypair_from_seed(sr25519_keypair keypair, const sr25519_mini_secret_key seed);

/*
 * keypair: the output uniform keypair, 96 bytes long
 * seed: the input mini secret key, 32 bytes long
*/
void sr25519_uniform_keypair_from_seed(sr25519_keypair keypair, const sr25519_mini_secret_key seed);

/*
 * uniform_keypair: the output uniform keypair, 96 bytes long
 * ed25519_keypair: the ed25519 compatible keypair, 96 bytes long
*/
void sr25519_keypair_ed25519_to_uniform(sr25519_keypair uniform_keypair, const sr25519_keypair ed25519_keypair);

/*
 * signature: the signature ouput, 64 bytes long
 * public: the public key of the keypair to sign the message, 32 bytes long
 * secret: the secret key of the keypair to sign the message, 64 bytes long
 * message and message_length: message arrary and length
*/
void sr25519_sign(sr25519_signature signature, const sr25519_public_key public, const sr25519_secret_key secret, const uint8_t *message, unsigned long message_length);

/*
 * signature: the signature bytes to verify, 64 bytes long
 * message and message_length: message arrary and length
 * public: the corresponding public key that signing the message, 32 bytes long
*/
bool sr25519_verify(const sr25519_signature signature, const uint8_t *message, unsigned long message_length, const sr25519_public_key public);

/*
 * derived: the derived keypair, 96 bytes long
 * keypair: the input keypair, 96 bytes long
 * chain_code: the input chain code, 32 bytes long
*/
void sr25519_derive_keypair_soft(sr25519_keypair derived, const sr25519_keypair keypair, const sr25519_chain_code chain_code);

/*
 * derived_public: the derived public key, 32 bytes long
 * public: the input public key, 32 bytes long
 * chain_code: the input chain code, 32 bytes long
*/
void sr25519_derive_public_soft(sr25519_public_key derived_public, const sr25519_public_key public, const sr25519_chain_code chain_code);

/*
 * derived: the derived keypair, 96 bytes long
 * keypair_in: the input keypair, 96 bytes long
 * chain_code: the input chain code, 32 bytes long
*/
void sr25519_derive_keypair_hard(sr25519_keypair derived, const sr25519_keypair keypair, const sr25519_chain_code chain_code);

/*
 * out_and_proof: output combination of vrf output (0..32) and vrf proof (32..96)
 * keypair: keypair for signing, it should be an uniform keypair instead of ed25519 compatible, you can generated by sr25519_uniform_keypair_from_seed or converted by sr25519_keypair_ed25519_to_uniform
 * message and message_length: message arrary and length
 * threshold: the vrf threshold, 16 bytes long, if the raw output bytes is less than threshold, the is_less field of result strcut will be true
*/
VrfResult sr25519_vrf_sign_if_less(sr25519_vrf_out_and_proof out_and_proof, const sr25519_keypair keypair, const uint8_t *message, unsigned long message_length, const sr25519_vrf_threshold threshold);

/*
 * public: the corresponding public key that signing the message
 * message and message_length: message arrary and length
 * output: the signature for the message
 * proof: the proof of the signature
 * threshold: the vrf threshold, 16 bytes long, if the raw output bytes is less than threshold, the is_less field of result structure will be true
 * If errors, is_less field of the returned structure is not meant to contain a valid value
*/
VrfResult sr25519_vrf_verify(const sr25519_public_key public, const uint8_t *message, unsigned long message_length, const sr25519_vrf_output output, const sr25519_vrf_proof proof, const sr25519_vrf_threshold threshold);

#endif
