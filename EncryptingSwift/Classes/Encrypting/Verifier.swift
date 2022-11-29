import Foundation

public protocol Verifier {
    func verify(message: Data, signature: Data) throws -> Bool
}
