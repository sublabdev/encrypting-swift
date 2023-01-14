import Bip39
import Foundation

/// A default mnemonic
public final class DefaultMnemonic: Mnemonic {
    
    public let words: [String]
    public let entropy: Data
    private let seedFactory: SeedFactory
    
    init(words: [String], entropy: Data, seedFactory: SeedFactory) throws {
        self.words = words
        self.entropy = entropy
        self.seedFactory = seedFactory
    }
    
    public func toSeed(passphrase: String) throws -> Data {
        try seedFactory.deriveSeed(mnemonic: self, passphrase: passphrase)[0..<32]
    }
}

extension DefaultMnemonic {
    /// Generates a default mnemoninc using `Bip39`'s mnemonic and a seed factory to generate a seed from it.
    /// Throws
    /// - Parameters:
    ///     - mnemonic: A `Bip39`'s mnemonic
    ///     - seedFactory: Seed factory that is used to generate a seed from it
    /// - Returns: A default mnemomic
    public static func from(
        mnemonic: Bip39.Mnemonic,
        seedFactory: SeedFactory = SubstrateSeedFactory()
    ) throws -> Mnemonic {
        try DefaultMnemonic(
            words: Bip39.Mnemonic.toMnemonic(mnemonic.entropy),
            entropy: Data(mnemonic.entropy),
            seedFactory: seedFactory
        )
    }
    
    /// Generates a default mnemoninc from a phrase and a seed factory to generate a seed from it.
    /// Throws
    /// - Parameters:
    ///     - phrase: A phrase used as words
    ///     - seedFactory: Seed factory that is used to generate a seed from it
    /// - Returns: A default mnemomic
    public static func from(phrase: String, seedFactory: SeedFactory = SubstrateSeedFactory()) throws -> Mnemonic {
        try from(words: phrase.split(separator: " ").map { String($0) }, seedFactory: seedFactory)
    }
    
    /// Generates a default mnemoninc from words and a seed factory to generate a seed from it.
    /// Throws
    /// - Parameters:
    ///     - words: Words used to generate the mnemonic
    ///     - seedFactory: Seed factory that is used to generate a seed from it
    /// - Returns: A default mnemomic
    public static func from(words: [String], seedFactory: SeedFactory = SubstrateSeedFactory()) throws -> Mnemonic {
        try DefaultMnemonic(
            words: words,
            entropy: Data(Bip39.Mnemonic.toEntropy(words)),
            seedFactory: seedFactory
        )
    }
}
