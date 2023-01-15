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

import CommonSwift
import EncryptingSwift
import XCTest

class TestSr25519: XCTestCase {
    private let testValues = (0..<Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8) }
    
    func test() throws {
        let seed = try "0xcfdd8f2503e043e9884997c6afcccd3bb30184f7c504de359ce3e591d4f8d853".hex.decode()
        let correctPublicKey = try "0x003b6c9a114fb708a99b6fa6753e145f12cf62b9eba095d57a4237570e152f53".hex.decode()
        
        let privateKey = try seed.sr25519.loadPrivateKey()
        let publicKey = try privateKey.sr25519.publicKey()
        XCTAssertEqual(correctPublicKey, publicKey)

        for testValue in testValues {
            let signature = try privateKey.sr25519.sign(message: testValue)
            let isValid = try publicKey.sr25519.verify(message: testValue, signature: signature)
            XCTAssertTrue(isValid)
        }
    }
    
    func testKeyPair() throws {
        let mnemonicProvider = DefaultMnemonicProvider(seedFactory: SubstrateSeedFactory())
        for _ in 0..<(Constants.testsCount/10) {
            let mnemonic = try mnemonicProvider.make()
            
            let keyPairFromSeed = try KeyPairFactory.sr25519.load(seedOrPrivateKey: mnemonic.toSeed())
            let keyPairFromMnemonic = try KeyPairFactory.sr25519.generate(from: mnemonic)
            XCTAssertEqual(keyPairFromSeed.privateKey, keyPairFromMnemonic.privateKey)

            for testValue in testValues {
                let signature = try keyPairFromSeed.sign(message: testValue)
                let isValid = try keyPairFromSeed.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }
    
    func testKeyFactory() throws {
        for _ in 0..<(Constants.testsCount/10) {
            let keyPair = try KeyPairFactory.sr25519.generate()
            for testValue in testValues {
                let signature = try keyPair.sign(message: testValue)
                let isValid = try keyPair.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }
}
