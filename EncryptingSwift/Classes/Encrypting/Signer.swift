import Foundation

public protocol Signer {
    func sign(message: Data) throws -> Data
}
