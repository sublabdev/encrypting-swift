import Foundation
import ed25519swift

class ED25519: SignatureEngine {
    private let data: Data

    init(data: Data) {
        self.data = data
    }
    
    func loadPrivateKey() throws -> Data {
        data
    }
    
    func publicKey() throws -> Data {
        Data(Ed25519.calcPublicKey(secretKey: data.bytes))
    }
    
    func sign(message: Data) throws -> Data {
        Data(Ed25519.sign(message: message.bytes, secretKey: data.bytes))
    }
    
    func verify(message: Data, signature: Data) throws -> Bool {
        Ed25519.verify(signature: signature.bytes, message: message.bytes, publicKey: data.bytes)
    }
}

extension Data {
    public var ed25519: SignatureEngine {
        ED25519(data: self)
    }
}
