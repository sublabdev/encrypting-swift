import Foundation
import ed25519swift

class ED25519: SignatureEngine {
    private let data: Data

    init(data: Data) {
        self.data = data
    }
    
    func createPrivateKey() -> Data {
        data
    }
    
    func publicKey() throws -> Data {
        Data(Ed25519.calcPublicKey(secretKey: data.bytes))
    }
    
    func sign(privateKey: Data) throws -> Data {
        Data(Ed25519.sign(message: data.bytes, secretKey: privateKey.bytes))
    }
    
    func verify(signature: Data, publicKey: Data) -> Bool {
        Ed25519.verify(signature: Array(signature), message: data.bytes, publicKey: publicKey.bytes)
    }
    
    func isValidKeyPair(publicKey: Data, secretKey: Data) throws -> Bool {
        Ed25519.isValidKeyPair(publicKey: publicKey.bytes, secretKey: secretKey.bytes)
    }
}

extension Data {
    public var ed25519: SignatureEngine {
        ED25519(data: self)
    }
}
