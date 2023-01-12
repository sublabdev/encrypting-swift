import Foundation

enum MnemonicError: Error {
    case entropyFailure
    case saltFailure
}

public protocol Mnemonic {
    var words: [String] { get }
    var entropy: Data { get }
    func toSeed(passphrase: String) throws -> Data
}

extension Mnemonic {
    public var wordCount: Int { words.count }
    public var phrase: String { words.joined(separator: " ") }
    
    public func toSeed() throws -> Data {
        try toSeed(passphrase: "")
    }
}
