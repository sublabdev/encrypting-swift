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

import Bip39
import Foundation
import UncommonCrypto

private let defaultPassphrase = "mnemonic"
private let scryptN = 16384
private let scryptR = 8
private let scryptP = 1
private let seedBytes = 64

public final class SubstrateSeedFactory: SeedFactory {
    public init() {}
    
    public func deriveSeed(mnemonic: Mnemonic, passphrase: String) throws -> Data {
        guard let salt = (defaultPassphrase + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8)?.bytes else { throw MnemonicError.saltFailure }
        
        return try Data(PBKDF2.derive(type: .sha512, password: mnemonic.entropy.bytes, salt: salt))
    }
}
