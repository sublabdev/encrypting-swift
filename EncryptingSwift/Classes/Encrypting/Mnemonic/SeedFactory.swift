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

/// An interface for generating seed from a mnemonic and passphrase
public protocol SeedFactory {
    /// Generates a seed from a mnemonic and passphrase. Throwable.
    /// - Parameters:
    ///     - mnemonic: Mnemonic used to generate a seed
    ///     - passphrase: A passphrase to generate a seed
    /// - Returns: A newly generated seed
    func deriveSeed(mnemonic: Mnemonic, passphrase: String) throws -> Data
}

extension SeedFactory {
    /// Generates a seed from a mnemonic, with an empty passphrase. Throwable.
    /// - Parameters:
    ///     - mnemonic: Mnemonic used to generate a seed
    /// - Returns: A newly generated seed
    public func deriveSeed(mnemonic: Mnemonic) throws -> Data {
        try deriveSeed(mnemonic: mnemonic, passphrase: "")
    }
}
