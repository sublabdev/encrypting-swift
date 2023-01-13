import Bip39
import Foundation

/// Interface for a mnemonic provider
public protocol MnemonicProvider {
    /// Makes a mnemonic with specific count of words and language. Throwable.
    /// - Parameters:
    ///     - wordCount: The count of words in the generated mnemonic
    ///     - language: Language for the generated mnemonic.
    /// - Returns: A newly generated mnemonic
    func make(wordCount: Int, language: Wordlist) throws -> Mnemonic
}

extension MnemonicProvider {
    /// Makes a mnemonic with a specified count of words and a language set as English. Throwable
    /// - Parameters:
    ///     - wordCount: The count of words in the generated mnemonic
    /// - Returns: A newly generated mnemonic
    public func make(wordCount: Int) throws -> Mnemonic {
        try make(wordCount: wordCount, language: .english)
    }
    
    /// Generates a mnemonic with a default words count (12) and a language set as English. Throwable.
    /// - Returns: A newly generated mnemonic
    public func make() throws -> Mnemonic {
        try make(wordCount: defaultWordCount, language: .english)
    }
}
