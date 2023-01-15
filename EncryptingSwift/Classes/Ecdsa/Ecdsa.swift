/**
 *
 * Copyright 2023 SUBSTRATE LABORATORY LLC <info@sublab.dev>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 */

import Foundation
import HashingSwift
import secp256k1

private typealias Hasher = (Data) throws -> Data

/// Handles ECDSA encryption
class Ecdsa: SignatureEngine {
    let name = "ecdsa"
    
    enum Error: Swift.Error {
        case invalidSecretKey
        case invalidMessage
        case signingFailed
    }
    
    struct Flag: OptionSet {
        let rawValue: Int32
        static let none = Flag(rawValue: SECP256K1_CONTEXT_NONE)
        static let sign = Flag(rawValue: SECP256K1_CONTEXT_SIGN)
        static let verify = Flag(rawValue: SECP256K1_CONTEXT_VERIFY)
        
        static let `default`: Flag = [.sign, .verify]
    }
    
    private let data: Data
    private let hasher: Hasher
    private let context: OpaquePointer
    
    /// Creates Ecdsa encryption handler
    /// - Parameters:
    ///     - data: The data to encrypt (the seed)
    ///     - flags: The falgs for creating a secp256k1 context (the default values are: `.sign` and `.verify`
    fileprivate init(data: Data, hasher: @escaping Hasher) {
        self.data = data
        self.hasher = hasher
        context = secp256k1_context_create(UInt32(Flag.default.rawValue))
    }
    
    // MARK: - Keys
    /// Loads the private key for ECDSA
    /// - Returns: The private key
    func loadPrivateKey() throws -> Data {
        data
    }
    
    /// Generates a public key for ECDSA
    /// - Returns: A created public key
    func publicKey() throws -> Data {
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        try data.withUnsafeBytes {
            guard $0.count == 32 else {
                throw Error.invalidSecretKey
            }
            guard secp256k1_ec_pubkey_create(context, pubkey, $0.bufferPointer) == 1 else {
                throw Error.invalidSecretKey
            }
        }
        
        return serialize(publicKey: pubkey)
    }
    
    // MARK: - Signing
    /// The default signing implementation for ECDSA
    /// - Parameters:
    ///     - message: The message that needs to be signed
    /// - Returns: The signature
    func sign(message: Data) throws -> Data {
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        
        try hasher(message).withUnsafeBytes {
            guard $0.count == 32 else {
                throw Error.invalidMessage
            }
            
            let messagePointer = $0.bufferPointer
            
            try data.withUnsafeBytes {
                guard $0.count == 32 else {
                    throw Error.invalidSecretKey
                }
                
                let keyPointer = $0.bufferPointer
                let result: Int32 = secp256k1_ecdsa_sign_recoverable(
                    context,
                    signature,
                    messagePointer,
                    keyPointer,
                    nil,
                    nil
                )
                
                guard result == 1 else {
                    throw Error.signingFailed
                }
            }
        }
        
        return serialize(recoverableSignature: signature)
    }
    
    // MARK: - Verification
    /// Verifies the provided message and signature against ECDSA
    /// - Parameters:
    ///     - message: The message
    ///     - signature: 64 bytes signature
    /// - Returns: A Bool value indicating whether the verification was successful or not
    func verify(message: Data, signature: Data) throws -> Bool {
        let sig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        
        guard signature.withUnsafeBytes({
            guard $0.count == 64 else {
                return false
            }
            
            return secp256k1_ecdsa_signature_parse_compact(context, sig, $0.bufferPointer) == 1
        })
        else {
           return false
        }
        
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        
        guard data.withUnsafeBytes({
            guard !$0.isEmpty else {
                return false
            }
            
            return secp256k1_ec_pubkey_parse(context, pubkey, $0.bufferPointer, $0.count) == 1
        })
        else {
           return false
        }
        
        return try hasher(message).withUnsafeBytes {
            guard $0.count == 32 else {
                return false
            }
            
            return secp256k1_ecdsa_verify(context, sig, $0.bufferPointer, pubkey) == 1
        }
    }
    
    // MARK: - Private
    // Handles the public key serialization
    private func serialize(publicKey pubkey: UnsafePointer<secp256k1_pubkey>) -> Data {
        var size = 33
        var data = Data(count: size)
        
        data.withUnsafeMutableBytes {
            secp256k1_ec_pubkey_serialize(context, $0.bufferPointer, &size, pubkey, UInt32(SECP256K1_EC_COMPRESSED))
            return
        }
        
        return data
    }
    
    // Handles the signature serialization
    private func serialize(recoverableSignature sig: UnsafePointer<secp256k1_ecdsa_recoverable_signature>) -> Data {
        var signature = Data(count: 64)
        var recoveryId: Int32 = -1
        signature.withUnsafeMutableBytes {
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, $0.bufferPointer, &recoveryId, sig)
            return
        }
        return signature
    }
}

// MARK: - Extension

extension Data {
    /// An access point to ECDSA functionality
    public func ecdsa(kind: EcdsaKind) -> SignatureEngine {
        Ecdsa(data: self) { try hashData($0, kind: kind) }
    }
}

private func hashData(_ data: Data, kind: EcdsaKind) throws -> Data {
    switch kind {
    case .substrate:
        return try data.hashing.blake2b_256()
    case .ethereum:
        return try data.hashing.keccak256()
    }
}
