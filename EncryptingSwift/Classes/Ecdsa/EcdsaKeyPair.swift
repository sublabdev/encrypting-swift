import Foundation

struct EcdsaKeyPair: KeyPair {
    public let privateKey: Data
    public let publicKey: Data
    
    public init(privateKey: Data, publicKey: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    public func signatureEngine(for data: Data) -> SignatureEngine {
        Ecdsa(data: data)
    }
}

final class EcdsaKeyPairFactory: KeyPairFactory {
    override func load(seed: Data) throws -> KeyPair {
        try EcdsaKeyPair(privateKey: seed, publicKey: seed.ecdsa.publicKey())
    }
}

extension KeyPairFactory {
    public static var ecdsa: KeyPairFactory {
        EcdsaKeyPairFactory()
    }
}
