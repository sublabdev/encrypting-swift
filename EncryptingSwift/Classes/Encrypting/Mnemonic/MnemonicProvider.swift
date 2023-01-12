import Bip39
import Foundation

public protocol MnemonicProvider {
    func make(wordCount: Int, language: Wordlist) throws -> Mnemonic
}

extension MnemonicProvider {
    public func make(wordCount: Int) throws -> Mnemonic {
        try make(wordCount: wordCount, language: .english)
    }
    
    public func make() throws -> Mnemonic {
        try make(wordCount: defaultWordCount, language: .english)
    }
}
