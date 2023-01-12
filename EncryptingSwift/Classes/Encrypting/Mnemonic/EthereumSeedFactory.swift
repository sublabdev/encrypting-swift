import Bip39
import Foundation

public final class EthereumSeedFactory: SeedFactory {
    public init() {}
    
    public func deriveSeed(mnemonic: Mnemonic, passphrase: String) throws -> Data {
        Data(
            try Bip39.Mnemonic(entropy: mnemonic.entropy.bytes).seed(password: passphrase)
        )
    }
}
