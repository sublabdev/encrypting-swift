import XCTest
import EncryptingSwift
import CommonSwift

class TestEcdsa: XCTestCase {
    private let testCases = (0...Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8)?[0..<32] }
    
    func testSignature() throws {
        let seed = "0xbb32936d098683d24023663036690bad840cd6b8d6975830f8ef490bc3f1f8e4".hex.decode()
        
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let privateKey = seed.ecdsa.createPrivateKey()
        let publicKey = try privateKey.ecdsa.publicKey()
        
        for testCase in testCases {
            let signature = try testCase.ecdsa.sign(privateKey: privateKey)
            
            let isValid = try testCase.ecdsa.verify(signature: signature, publicKey: publicKey)
            XCTAssertEqual(isValid, true)
        }
    }
}
