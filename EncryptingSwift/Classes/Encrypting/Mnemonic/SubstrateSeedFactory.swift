import Bip39
import Foundation
import UncommonCrypto

private let defaultPassphrase = "mnemonic"
private let scryptN = 16384
private let scryptR = 8
private let scryptP = 1
private let seedBytes = 64

public final class SubstrateSeedFactory: SeedFactory {
    public init() {}
    
    public func deriveSeed(mnemonic: Mnemonic, passphrase: String) throws -> Data {
        guard let salt = (defaultPassphrase + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8)?.bytes else { throw MnemonicError.saltFailure }
        
        return try Data(PBKDF2.derive(type: .sha512, password: mnemonic.entropy.bytes, salt: salt))
    }
}
