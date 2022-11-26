import Foundation

public protocol SignatureKeyPairEngine {
    func keyPair(seed: Data) throws -> KeyPair
    func verify(signature: Data, publicKey: Data) throws -> Bool
}
