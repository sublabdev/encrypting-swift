import XCTest
import EncryptingSwift
import CommonSwift

class TestSr25519: XCTestCase {
    private let seed = "0x7032fc2571822aaaf374cc5deb44e92d7ff97c314bea704aab95c04c4c4229b1".hex.decode()
    private let testValues = (0..<Constants.testsCount/10)
        .compactMap { _ in UUID().uuidString.data(using: .utf8)?[0..<32] }
    
    func testSr25519() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let privateKey = try seed.sr25519.loadPrivateKey()
        let publicKey = try privateKey.sr25519.publicKey()
    
        for testValue in testValues {
            let signature = try privateKey.sr25519.sign(message: testValue)
            let isValid = try publicKey.sr25519.verify(message: testValue, signature: signature)
            
            XCTAssertEqual(isValid, true)
        }
    }
    
    func testKeyPair() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let keyPair = try KeyPairFactory.sr25519.load(seedOrPrivateKey: seed)
        
        for testValue in testValues {
            let signature = try keyPair.sign(message: testValue)
            let isValid = try keyPair.verify(message: testValue, signature: signature)
            
            XCTAssertEqual(isValid, true)
        }
    }
}
