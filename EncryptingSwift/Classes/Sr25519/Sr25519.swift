import Foundation
import Sr25519

class Sr25519: SignatureKeyPairEngine {
    private let data: Data

    init(data: Data) {
        self.data = data
    }
    
    func keyPair(seed: Data) throws -> KeyPair {
        let keypair = try Sr25519KeyPair(seed: .init(raw: seed))
        let sign = keypair.sign(message: data).raw
        return KeyPair(signature: sign, publicKey: keypair.publicKey.raw)
    }
    
    func verify(signature: Data, publicKey: Data) throws -> Bool {
        try Sr25519PublicKey(raw: publicKey)
            .verify(message: data, signature: Sr25519Signature(raw: signature))
    }
}

extension Data {
    public var sr25519: SignatureKeyPairEngine {
        Sr25519(data: self)
    }
}
