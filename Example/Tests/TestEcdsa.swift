import XCTest
import EncryptingSwift
import CommonSwift

class TestEcdsa: XCTestCase {
    private let testValues = (0...Constants.testsCount)
        .compactMap { _ in UUID().uuidString.data(using: .utf8) }
        
    func testSubstrateSignature() throws {
        try testSignature(kind: .substrate)
    }
    
    func testEthereumSignature() throws {
        try testSignature(kind: .ethereum)
    }

    private func testSignature(kind: EcdsaKind) throws {
        guard let seed = "0x0637cff0bfebd949172774cbc4d9933e92b6a18eaffd835a79a776a0f6cf92e9".hex.decode() else {
            XCTFail()
            return
        }
        
        let privateKey = try seed.ecdsa(kind: kind).loadPrivateKey()
        let publicKey = try privateKey.ecdsa(kind: kind).publicKey()

        for testValue in testValues {
            let signature = try privateKey.ecdsa(kind: kind).sign(message: testValue)
            let isValid = try publicKey.ecdsa(kind: kind).verify(message: testValue, signature: signature)
            XCTAssertTrue(isValid)
        }
    }

    func testSubstrateKeyPair() throws {
        try testKeyPair(kind: .substrate)
    }
    
    func testEthereumKeyPair() throws {
        try testKeyPair(kind: .ethereum)
    }

    private func testKeyPair(kind: EcdsaKind) throws {
        let seedFactory: SeedFactory = kind == .substrate ? SubstrateSeedFactory() : EthereumSeedFactory()

        let mnemonicProvider = DefaultMnemonicProvider(seedFactory: seedFactory)
        for _ in 0..<Constants.testsCount/10 {
            let mnemonic = try mnemonicProvider.make()

            let keyPairFromSeed = try KeyPairFactory.ecdsa(kind: kind).load(seedOrPrivateKey: mnemonic.toSeed())
            let keyPairFromMnemonic = try KeyPairFactory.ecdsa(kind: kind).generate(from: mnemonic)
            XCTAssertEqual(keyPairFromSeed.privateKey, keyPairFromMnemonic.privateKey)

            for testValue in testValues {
                let signature = try keyPairFromSeed.sign(message: testValue)
                let isValid = try keyPairFromSeed.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }

    func testSubstrateKeyFactory() throws {
        try testKeyFactory(kind: .substrate)
    }
    
    func testEthereumKeyFactory() throws {
        try testKeyFactory(kind: .ethereum)
    }

    private func testKeyFactory(kind: EcdsaKind) throws {
        for _ in 0..<Constants.testsCount/10 {
            let keyPair = try KeyPairFactory.ecdsa(kind: kind).generate()

            for testValue in testValues {
                let signature = try keyPair.sign(message: testValue)
                let isValid = try keyPair.verify(message: testValue, signature: signature)
                XCTAssertTrue(isValid)
            }
        }
    }
}
