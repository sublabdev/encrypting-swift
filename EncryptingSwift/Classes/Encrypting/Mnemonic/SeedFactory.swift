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
