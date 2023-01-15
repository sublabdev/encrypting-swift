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

/// ECDSA implementation of KeyPair protocol
struct EcdsaKeyPair: KeyPair {
    let privateKey: Data
    let publicKey: Data
    private let kind: EcdsaKind
    
    fileprivate init(privateKey: Data, publicKey: Data, kind: EcdsaKind) {
        self.privateKey = privateKey
        self.publicKey = publicKey
        self.kind = kind
    }
    
    /// Returns the SignatureEngine for ECDSA
    func signatureEngine(for data: Data) -> SignatureEngine {
        data.ecdsa(kind: kind)
    }
}

/// A factory object for ECDSA key pair
final class EcdsaKeyPairFactory: KeyPairFactory {
    override var seedFactory: SeedFactory { SubstrateSeedFactory() }
    
    private let kind: EcdsaKind
    
    init(kind: EcdsaKind) {
        self.kind = kind
    }
    
    override func load(seedOrPrivateKey: Data) throws -> KeyPair {
        let privateKey = try seedOrPrivateKey.ecdsa(kind: kind).loadPrivateKey()
        return try EcdsaKeyPair(
            privateKey: privateKey,
            publicKey: privateKey.ecdsa(kind: kind).publicKey(),
            kind: kind
        )
    }
}

extension KeyPairFactory {
    /// An access point to ECDSA's `KeyPair`factory
    public static func ecdsa(kind: EcdsaKind) -> KeyPairFactory {
        EcdsaKeyPairFactory(kind: kind)
    }
}
