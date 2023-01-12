import Bip39
import Foundation

private let wordCountToStrength: [Int: Int] = [
    12: 128,
    15: 160,
    18: 192,
    21: 224,
    24: 256
]

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
