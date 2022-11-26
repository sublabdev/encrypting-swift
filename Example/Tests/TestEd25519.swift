import XCTest
import EncryptingSwift
import CommonSwift

class TestEd25519: XCTestCase {
    private let testValues = (0..<Constants.testsCount).map { _ in UUID().uuidString.data(using: .utf8) }

    func testEd25519() throws {
        guard let seed = "0x2a5eb7a8366dd8b5c7fe51908ecd1f40bcea84664c09716b1aa053a4e5f1c677".hex.decode() else {
            XCTFail()
            return
        }
        
        let privateKey = seed.ed25519.createPrivateKey()
        let publicKey = try privateKey.ed25519.publicKey()
        
        for testValue in testValues {
            let signature = try testValue?.ed25519.sign(privateKey: privateKey)
        
            guard let signature = signature else {
                XCTFail()
                return
            }
            
            let isValid = try testValue?.ed25519.verify(signature: signature, publicKey: publicKey)
            XCTAssertEqual(isValid, true)
        }
    }
}
