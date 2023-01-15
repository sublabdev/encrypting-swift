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

/// Mnemonic errors
enum MnemonicError: Error {
    case entropyFailure
    case saltFailure
}

/// Standard mnemonic interface
public protocol Mnemonic {
    var words: [String] { get }
    var entropy: Data { get }
    /// Generates a seed from a passphrase
    /// - Parameters:
    ///     - passphrase: Passphrase to generate a seed from
    /// - Returns: Generated seed
    func toSeed(passphrase: String) throws -> Data
}

extension Mnemonic {
    public var wordCount: Int { words.count }
    public var phrase: String { words.joined(separator: " ") }
    
    /// Generates a seed without using any passphrase
    /// - Returns: Generated seed
    public func toSeed() throws -> Data {
        try toSeed(passphrase: "")
    }
}
