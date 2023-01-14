import Foundation

public let defaultWordCount = 12

/// A factory for creating a `KeyPair` object
open class KeyPairFactory {
    /// Loads seed to create a `KeyPair`.
    /// > NOTE: The method must be implemented, otherwise a fatal error will be thrown
    /// - Parameters:
    ///     - seed: The seed data which is used to generate a `KeyPair` object
    /// - Returns: `KeyPair` object with private and public keys as well as with an interface that provides a signature engine, message signing and signature (and message) verification interfaces.
    open func load(seedOrPrivateKey: Data) throws -> KeyPair {
        fatalError("Not implemented")
    }
    
    var seedFactory: SeedFactory {
        fatalError("Not implemented")
    }
    
    /// Generates a `KeyPair` from a word count and a passphrase.
    /// Throws
    /// - Parameters:
    ///     - wordCount: A word count. The default value is set to 12
    ///     - passphrase: A passphrase. The default value is an empty `String`
    /// - Returns: A `KeyPair` object
    public func generate(wordCount: Int = defaultWordCount, passphrase: String = "") throws -> KeyPair {
        try generate(
            from: DefaultMnemonicProvider(seedFactory: seedFactory).make(wordCount: wordCount),
            passphrase: passphrase
        )
    }
    
    /// Generates a `KeyPair` from a mnemonic and a passphrase.
    /// Throws
    /// - Parameters:
    ///     - mnemonic: A mnemonic used to get a seed
    ///     - passphrase: A passphrase. The default value is an empty `String`
    /// - Returns: A `KeyPair` object
    public func generate(from mnemonic: Mnemonic, passphrase: String = "") throws -> KeyPair {
        try load(seedOrPrivateKey: mnemonic.toSeed(passphrase: passphrase))
    }
    
    /// Generates a `KeyPair` from a phrase and a passphrase.
    /// Throws
    /// - Parameters:
    ///     - phrase: A phrase
    ///     - passphrase: A passphrase. The default value is an empty `String`
    /// - Returns: A `KeyPair` object
    public func generate(phrase: String, passphrase: String = "") throws -> KeyPair {
        try generate(from: DefaultMnemonic.from(phrase: phrase), passphrase: passphrase)
    }
    
    /// Generates a `KeyPair` from words and a passphrase.
    /// Throws
    /// - Parameters:
    ///     - words: Words used to generate the mnemonic
    ///     - passphrase: A passphrase
    /// - Returns: A `KeyPair` object
    public func generate(words: [String], passphrase: String = "") throws -> KeyPair {
        try generate(from: DefaultMnemonic.from(words: words), passphrase: passphrase)
    }
}

/// An interface that holds the private and public key-pair;
/// and also effectively hides the specifics about which `SignatureEngine` is used
public protocol KeyPair: Signer, Verifier {
    /// The private key
    var privateKey: Data { get }
    /// The public key
    var publicKey: Data { get }
    /// Signature engine used
    /// - Parameters:
    ///     - data: The data for which `SignatureEngine` should be returned
    /// - Returns: The `SignatureEngine` for Data
    func signatureEngine(for data: Data) -> SignatureEngine
}

extension KeyPair {
    /// The default signing implementation
    /// - Parameters:
    ///     - message: The message that needs to be signed
    /// - Returns: The signature
    public func sign(message: Data) throws -> Data {
        try signatureEngine(for: privateKey).sign(message: message)
    }
    
    /// The default verification implementation
    /// - Parameters:
    ///     - message: The message
    ///     - signature: 64 bytes signature
    /// - Returns: A Bool value indicating whether the verification was successful or not
    public func verify(message: Data, signature: Data) throws -> Bool {
        try signatureEngine(for: publicKey).verify(message: message, signature: signature)
    }
}
