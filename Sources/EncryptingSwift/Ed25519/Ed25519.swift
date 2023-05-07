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
import ed25519swift

/// Handles ED25519 encryption
final class Ed25519: SignatureEngine {
    let name = "ed25519"
    
    private let data: Data

    /// Creates ED25519 encryption handler
    /// - Parameters:
    ///     - data: The data to encrypt (the seed)
    fileprivate init(data: Data) {
        self.data = data
    }
    
    /// Loads a private key for ED25519
    /// - Returns: The private key
    func loadPrivateKey() throws -> Data {
        data
    }
    
    /// Generates a public key for ED25519
    /// - Returns: A created public key
    func publicKey() throws -> Data {
        Data(ed25519swift.Ed25519.calcPublicKey(secretKey: data.bytes))
    }
    /// The default signing implementation for ED25519
    /// - Parameters:
    ///     - message: The message that needs to be signed
    /// - Returns: The signature
    func sign(message: Data) throws -> Data {
        Data(ed25519swift.Ed25519.sign(message: message.bytes, secretKey: data.bytes))
    }
    
    /// Verifies the provided message and signature against ED25519
    /// - Parameters:
    ///     - message: The message
    ///     - signature: 64 bytes signature
    /// - Returns: A Bool value indicating whether the verification was successful or not
    func verify(message: Data, signature: Data) throws -> Bool {
        ed25519swift.Ed25519.verify(signature: signature.bytes, message: message.bytes, publicKey: data.bytes)
    }
}

extension Data {
    /// An access point to ED25519 functionality
    public var ed25519: SignatureEngine {
        Ed25519(data: self)
    }
}
