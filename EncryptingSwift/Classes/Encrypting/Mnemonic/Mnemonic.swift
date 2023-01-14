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
