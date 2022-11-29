import Foundation

struct Sr25519KeyPair: KeyPair {
    public let privateKey: Data
    public let publicKey: Data
    
    public init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public func signatureEngine(for data: Data) -> SignatureEngine {
        SR25519(data: data)
    }
}

final class SR25519KeyPairFactory: KeyPairFactory {
    override func load(seed: Data) throws -> KeyPair {
        try Sr25519KeyPair(privateKey: seed, publicKey: seed.sr25519.publicKey())
    }
}

extension KeyPairFactory {
    public static var sr25519: KeyPairFactory {
        SR25519KeyPairFactory()
    }
}
