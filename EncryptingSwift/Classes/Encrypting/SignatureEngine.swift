import Foundation

public protocol SignatureEngine {
    func createPrivateKey() -> Data
    func publicKey() throws -> Data
    func sign(privateKey: Data) throws -> Data
    func verify(signature: Data, publicKey: Data) throws -> Bool
}
