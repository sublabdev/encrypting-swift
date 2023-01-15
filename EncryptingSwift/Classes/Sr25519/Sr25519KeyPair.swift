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

// Sr25519 implementation of KeyPair protocol
struct Sr25519KeyPair: KeyPair {
    let privateKey: Data
    let publicKey: Data
    
    fileprivate init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    // Returns the SignatureEngine for Sr25519
    func signatureEngine(for data: Data) -> SignatureEngine {
        data.sr25519
    }
}

// A factory object for Sr25519 key pair
final class SR25519KeyPairFactory: KeyPairFactory {
    override var seedFactory: SeedFactory { SubstrateSeedFactory() }
    
    override func load(seedOrPrivateKey: Data) throws -> KeyPair {
        let privateKey = try seedOrPrivateKey.sr25519.loadPrivateKey()
        return try Sr25519KeyPair(privateKey: privateKey, publicKey: privateKey.sr25519.publicKey())
    }
}

extension KeyPairFactory {
    /// An access point to Sr25519's `KeyPair`factory
    public static var sr25519: KeyPairFactory {
        SR25519KeyPairFactory()
    }
}
