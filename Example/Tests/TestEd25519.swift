import XCTest
import EncryptingSwift
import CommonSwift

class TestEd25519: XCTestCase {
    private let seed = "0x7032fc2571822aaaf374cc5deb44e92d7ff97c314bea704aab95c04c4c4229b1".hex.decode()
    private let testValues = (0..<Constants.testsCount).compactMap { _ in UUID().uuidString.data(using: .utf8) }
    
    func testEd25519() throws {
        guard let seed = "0x2a5eb7a8366dd8b5c7fe51908ecd1f40bcea84664c09716b1aa053a4e5f1c677".hex.decode() else {
            XCTFail()
            return
        }
        
        let privateKey = try seed.ed25519.loadPrivateKey()
        let publicKey = try privateKey.ed25519.publicKey()
        
        for testValue in testValues {
            let signature = try privateKey.ed25519.sign(message: testValue)
        
            let isValid = try publicKey.ed25519.verify(message: testValue, signature: signature)
            XCTAssertEqual(isValid, true)
        }
    }
    
    func testKeyPair() throws {
        guard let seed = seed else {
            XCTFail()
            return
        }
        
        let keyPair = try KeyPairFactory.ed25519.load(seed: seed)
        
        for testValue in testValues {
            let signature = try keyPair.sign(message: testValue)
            let isValid = try keyPair.verify(message: testValue, signature: signature)
            
            XCTAssertEqual(isValid, true)
        }
    }
}
