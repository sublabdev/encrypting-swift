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

import XCTest
import EncryptingSwift
import CommonSwift

class TestEd25519: XCTestCase {
    private let testValues = (0..<Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8) }
    
    func test() throws {
        let seed = try "0x355f13340b9db6e5f7aaadb1deea7aecc57a8af4a4587b7f0e24cfa824f48c07".hex.decode()
        
        let privateKey = try seed.ed25519.loadPrivateKey()
        let publicKey = try privateKey.ed25519.publicKey()

        for testValue in testValues {
            let signature = try privateKey.ed25519.sign(message: testValue)
            let isValid = try publicKey.ed25519.verify(message: testValue, signature: signature)
            XCTAssertTrue(isValid)
        }
    }

    func testKeyPair() throws {
        let mnemonicProvider = DefaultMnemonicProvider(seedFactory: SubstrateSeedFactory())
        for _ in 0..<Constants.testsCount/10 {
            let mnemonic = try mnemonicProvider.make()

            let keyPairFromSeed = try KeyPairFactory.ed25519.load(seedOrPrivateKey: mnemonic.toSeed())
            let keyPairFromMnemonic = try KeyPairFactory.ed25519.generate(from: mnemonic)
            XCTAssertEqual(keyPairFromSeed.privateKey, keyPairFromMnemonic.privateKey)

            for testValue in testValues {
                let signature = try keyPairFromSeed.sign(message: testValue)
                let isValid = try keyPairFromSeed.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }
    
    func testKeyFactory() throws {
        for _ in 0..<Constants.testsCount/10 {
            let keyPair = try KeyPairFactory.ed25519.generate()

            for testValue in testValues {
                let signature = try keyPair.sign(message: testValue)
                let isValid = try keyPair.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }
}
