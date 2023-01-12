import Foundation

// ed25519 implementation of KeyPair protocol
struct Ed25519KeyPair: KeyPair {
    let privateKey: Data
    let publicKey: Data
    
    fileprivate init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    // Returns the SignatureEngine for ED25519
    func signatureEngine(for data: Data) -> SignatureEngine {
        data.ed25519
    }
}

// A factory object for ED25519 key pair
final class Ed25519KeyPairFactory: KeyPairFactory {
    override func load(seedOrPrivateKey: Data) throws -> KeyPair {
        let privateKey = try seedOrPrivateKey.ed25519.loadPrivateKey()
        return try Ed25519KeyPair(privateKey: privateKey, publicKey: privateKey.ed25519.publicKey())
    }
}

extension KeyPairFactory {
    /// An access point to ED25519's `KeyPair`factory
    public static var ed25519: KeyPairFactory {
        Ed25519KeyPairFactory()
    }
}
