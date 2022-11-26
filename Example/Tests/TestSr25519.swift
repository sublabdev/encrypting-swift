import XCTest
import EncryptingSwift
import CommonSwift

class TestSr25519: XCTestCase {
    private let testValues = (0..<Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8)?[0..<32] }
    
    func testSr25519() throws {
        guard let seed = "0x7032fc2571822aaaf374cc5deb44e92d7ff97c314bea704aab95c04c4c4229b1".hex.decode() else {
            XCTFail()
            return
        }
    
        for testValue in testValues {
            let keyPair = try testValue.sr25519.keyPair(seed: seed)
           
            let isValid = try testValue.sr25519.verify(
                signature: keyPair.signature,
                publicKey: keyPair.publicKey
            )
            
            XCTAssertEqual(isValid, true)
        }
    }
}
