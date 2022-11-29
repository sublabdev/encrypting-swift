import XCTest
import EncryptingSwift
import CommonSwift

class TestEcdsa: XCTestCase {
    private let seed = "0xbb32936d098683d24023663036690bad840cd6b8d6975830f8ef490bc3f1f8e4".hex.decode()
    private let testValues = (0...Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8)?[0..<32] }
    
    func testSignature() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let privateKey = try seed.ecdsa.loadPrivateKey()
        let publicKey = try privateKey.ecdsa.publicKey()
        
        for testValue in testValues {
            let signature = try privateKey.ecdsa.sign(message: testValue)
            
            let isValid = try publicKey.ecdsa.verify(message: testValue, signature: signature)
            XCTAssertEqual(isValid, true)
        }
    }
    
    func testKeyPair() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let keyPair = try KeyPairFactory.ecdsa.load(seed: seed)
        
        for testValue in testValues {
            let signature = try keyPair.sign(message: testValue)
            let isValid = try keyPair.verify(message: testValue, signature: signature)
            XCTAssertEqual(isValid, true)
        }
    }
}
