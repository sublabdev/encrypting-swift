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

private let wordCountToStrength: [Int: Int] = [
    12: 128,
    15: 160,
    18: 192,
    21: 224,
    24: 256
]

/// Default mnemonic provider
public final class DefaultMnemonicProvider: MnemonicProvider {
    enum Error: Swift.Error {
        case invalidWordCount
    }
    
    private let seedFactory: SeedFactory
    public init(seedFactory: SeedFactory) {
        self.seedFactory = seedFactory
    }
    
    public func make(wordCount: Int, language: Bip39.Wordlist) throws -> Mnemonic {
        guard let strength = wordCountToStrength[wordCount] else {
            throw Error.invalidWordCount
        }
        
        return try DefaultMnemonic.from(
            mnemonic: try Bip39.Mnemonic(strength: strength),
            seedFactory: seedFactory
        )
    }
}
