import Foundation

// ECDSA implementation of KeyPair protocol
struct EcdsaKeyPair: KeyPair {
    let privateKey: Data
    let publicKey: Data
    private let kind: EcdsaKind
    
    fileprivate init(privateKey: Data, publicKey: Data, kind: EcdsaKind) {
        self.privateKey = privateKey
        self.publicKey = publicKey
        self.kind = kind
    }
    
    // Returns the SignatureEngine for ECDSA
    func signatureEngine(for data: Data) -> SignatureEngine {
        data.ecdsa(kind: kind)
    }
}

// A factory object for ECDSA key pair
final class EcdsaKeyPairFactory: KeyPairFactory {
    override var seedFactory: SeedFactory { SubstrateSeedFactory() }
    
    private let kind: EcdsaKind
    init(kind: EcdsaKind) {
        self.kind = kind
    }
    
    override func load(seedOrPrivateKey: Data) throws -> KeyPair {
        let privateKey = try seedOrPrivateKey.ecdsa(kind: kind).loadPrivateKey()
        return try EcdsaKeyPair(
            privateKey: privateKey,
            publicKey: privateKey.ecdsa(kind: kind).publicKey(),
            kind: kind
        )
    }
}

extension KeyPairFactory {
    /// An access point to ECDSA's `KeyPair`factory
    public static func ecdsa(kind: EcdsaKind) -> KeyPairFactory {
        EcdsaKeyPairFactory(kind: kind)
    }
}
