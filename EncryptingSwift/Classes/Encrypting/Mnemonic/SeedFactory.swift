import Foundation

public protocol SeedFactory {
    func deriveSeed(mnemonic: Mnemonic, passphrase: String) throws -> Data
}

extension SeedFactory {
    public func deriveSeed(mnemonic: Mnemonic) throws -> Data {
        try deriveSeed(mnemonic: mnemonic, passphrase: "")
    }
}
