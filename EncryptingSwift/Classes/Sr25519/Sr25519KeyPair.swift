import Foundation

// Sr25519 implementation of KeyPair protocol
struct Sr25519KeyPair: KeyPair {
    let privateKey: Data
    let publicKey: Data
    
    fileprivate init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    // Returns the SignatureEngine for Sr25519
    func signatureEngine(for data: Data) -> SignatureEngine {
        data.sr25519
    }
}

// A factory object for Sr25519 key pair
final class SR25519KeyPairFactory: KeyPairFactory {
    override var seedFactory: SeedFactory { SubstrateSeedFactory() }
    
    override func load(seedOrPrivateKey: Data) throws -> KeyPair {
        let privateKey = try seedOrPrivateKey.sr25519.loadPrivateKey()
        return try Sr25519KeyPair(privateKey: privateKey, publicKey: privateKey.sr25519.publicKey())
    }
}

extension KeyPairFactory {
    /// An access point to Sr25519's `KeyPair`factory
    public static var sr25519: KeyPairFactory {
        SR25519KeyPairFactory()
    }
}
