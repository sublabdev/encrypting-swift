import Foundation

struct ED25519KeyPair: KeyPair {
    public let privateKey: Data
    public let publicKey: Data
    
    public init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public func signatureEngine(for data: Data) -> SignatureEngine {
        ED25519(data: data)
    }
}

final class ED25519KeyPairFactory: KeyPairFactory {
    override func load(seed: Data) throws -> KeyPair {
        try ED25519KeyPair(privateKey: seed, publicKey: seed.ed25519.publicKey())
    }
}

extension KeyPairFactory {
    public static var ed25519: KeyPairFactory {
        ED25519KeyPairFactory()
    }
}
