import Foundation

public protocol SignatureEngine: Verifier, Signer {
    func loadPrivateKey() throws -> Data
    func publicKey() throws -> Data
}
