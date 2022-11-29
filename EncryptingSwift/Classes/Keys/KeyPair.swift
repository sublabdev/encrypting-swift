import Foundation

open class KeyPairFactory {
    open func load(seed: Data) throws -> KeyPair {
        fatalError("Not implemented")
    }
}

public protocol KeyPair: Signer, Verifier {
    var privateKey: Data { get }
    var publicKey: Data { get }
    func signatureEngine(for data: Data) -> SignatureEngine
}

extension KeyPair {
    public func sign(message: Data) throws -> Data {
        try signatureEngine(for: privateKey).sign(message: message)
    }
    
    public func verify(message: Data, signature: Data) throws -> Bool {
        try signatureEngine(for: publicKey).verify(message: message, signature: signature)
    }
}
