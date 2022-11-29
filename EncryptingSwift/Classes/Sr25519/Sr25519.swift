import Foundation
import Sr25519

class SR25519: SignatureEngine {
    private let data: Data

    init(data: Data) {
        self.data = data
    }
    
    private func keyPair() throws -> Sr25519.Sr25519KeyPair {
        try Sr25519.Sr25519KeyPair(seed: .init(raw: data))
    }
    
    func loadPrivateKey() throws -> Data {
        data
    }
    
    func publicKey() throws -> Data {
        try keyPair().publicKey.raw
    }
    
    func verify(message: Data, signature: Data) throws -> Bool {
        try Sr25519PublicKey(raw: data)
            .verify(message: message, signature: Sr25519Signature(raw: signature))
    }
    
    func sign(message: Data) throws -> Data {
        try keyPair().sign(message: message).raw
    }
}

extension Data {
    public var sr25519: SignatureEngine {
        SR25519(data: self)
    }
}
