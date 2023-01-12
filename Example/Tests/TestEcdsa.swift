import XCTest
import EncryptingSwift
import CommonSwift

class TestEcdsa: XCTestCase {
    private let seed = "0xbb32936d098683d24023663036690bad840cd6b8d6975830f8ef490bc3f1f8e4".hex.decode()
    private let testValues = (0...Constants.testsCount/10)
        .compactMap { _ in UUID().uuidString.data(using: .utf8)?[0..<32] }
    
    private let kinds: [EcdsaKind] = [.substrate, .ethereum]
    
    func testSignature() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        for kind in kinds {
            let privateKey = try seed.ecdsa(kind: kind).loadPrivateKey()
            let publicKey = try privateKey.ecdsa(kind: kind).publicKey()
            
            for testValue in testValues {
                let signature = try privateKey.ecdsa(kind: kind).sign(message: testValue)
                
                let isValid = try publicKey.ecdsa(kind: kind).verify(message: testValue, signature: signature)
                XCTAssertEqual(isValid, true)
            }
        }
    }
    
    func testKeyPair() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        for kind in kinds {
            let keyPair = try KeyPairFactory.ecdsa(kind: kind).load(seedOrPrivateKey: seed)
            
            for testValue in testValues {
                let signature = try keyPair.sign(message: testValue)
                let isValid = try keyPair.verify(message: testValue, signature: signature)
                XCTAssertEqual(isValid, true)
            }
        }
    }
}
