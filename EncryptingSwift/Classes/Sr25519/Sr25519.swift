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
import Sr25519

/// Handles SR25519 encryption
class SR25519: SignatureEngine {
    let name = "sr25519"
    private let data: Data

    /// Creates SR25519 encryption handler
    /// - Parameters:
    ///     - data: The data to encrypt (the seed)
    fileprivate init(data: Data) {
        self.data = data
    }
    
    /// Loads the private key for SR25519
    /// - Returns: The private key
    func loadPrivateKey() throws -> Data {
        data
    }
    
    /// Generates a public key for SR25519
    /// - Returns: A created public key
    func publicKey() throws -> Data {
        try keyPair().publicKey.raw
    }
    
    /// The default signing implementation for SR25519
    /// - Parameters:
    ///     - message: The message that needs to be signed
    /// - Returns: The signature
    func sign(message: Data) throws -> Data {
        try keyPair().sign(message: message).raw
    }
    
    // MARK: - Verification
    /// Verifies the provided message and signature against SR25519
    /// - Parameters:
    ///     - message: The message
    ///     - signature: 64 bytes signature
    /// - Returns: A Bool value indicating whether the verification was successful or not
    func verify(message: Data, signature: Data) throws -> Bool {
        try Sr25519PublicKey(raw: data)
            .verify(message: message, signature: Sr25519Signature(raw: signature))
    }
    
    // Returns a KeyPair object for SR25519
    private func keyPair() throws -> Sr25519.Sr25519KeyPair {
        try Sr25519.Sr25519KeyPair(seed: .init(raw: data))
    }
}

extension Data {
    /// An access point to SR25519 functionality
    public var sr25519: SignatureEngine {
        SR25519(data: self)
    }
}
