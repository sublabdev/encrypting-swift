import Foundation
import secp256k1

class Ecdsa: SignatureEngine {
    enum Error: Swift.Error {
        case invalidSecretKey
        case invalidMessage
        case signingFailed
    }
    
    struct Flags: OptionSet {
        let rawValue: Int32
        static let none = Flags(rawValue: SECP256K1_CONTEXT_NONE)
        static let sign = Flags(rawValue: SECP256K1_CONTEXT_SIGN)
        static let verify = Flags(rawValue: SECP256K1_CONTEXT_VERIFY)
    }
    
    private let data: Data
    private let context: OpaquePointer
    
    init(data: Data, flags: Flags = [.sign, .verify]) {
        self.data = data
        context = secp256k1_context_create(UInt32(flags.rawValue))
    }
    
    // MARK: - Keys
    func createPrivateKey() -> Data {
        data
    }
    
    func publicKey() throws -> Data {
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        try data.withUnsafeBytes {
            guard $0.count == 32 else {
                throw Error.invalidSecretKey
            }
            guard secp256k1_ec_pubkey_create(context, pubkey, $0.bufferPointer) == 1 else {
                throw Error.invalidSecretKey
            }
        }
        
        return serialize(publicKey: pubkey)
    }
    
    // MARK: - Signing
    func sign(privateKey: Data) throws -> Data {
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        
        try data.withUnsafeBytes {
            guard $0.count == 32 else {
                throw Error.invalidMessage
            }
            
            let messagePointer = $0.bufferPointer
            
            try privateKey.withUnsafeBytes {
                guard $0.count == 32 else {
                    throw Error.invalidSecretKey
                }
                
                let keyPointer = $0.bufferPointer
                let result: Int32 = secp256k1_ecdsa_sign_recoverable(
                    context,
                    signature,
                    messagePointer,
                    keyPointer,
                    nil,
                    nil
                )
                
                guard result == 1 else {
                    throw Error.signingFailed
                }
            }
        }
        
        return serialize(recoverableSignature: signature)
    }
    
    // MARK: - Verification
    func verify(signature: Data, publicKey: Data) throws -> Bool {
        let sig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        
        guard signature.withUnsafeBytes({
            guard $0.count == 64 else {
                return false
            }
            
            return secp256k1_ecdsa_signature_parse_compact(context, sig, $0.bufferPointer) == 1
        })
        else {
           return false
        }
        
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        
        guard publicKey.withUnsafeBytes({
            guard !$0.isEmpty else {
                return false
            }
            
            return secp256k1_ec_pubkey_parse(context, pubkey, $0.bufferPointer, $0.count) == 1
        })
        else {
           return false
        }
        
        return data.withUnsafeBytes {
            guard $0.count == 32 else {
                return false
            }
            
            return secp256k1_ecdsa_verify(context, sig, $0.bufferPointer, pubkey) == 1
        }
    }
    
    // MARK: - Private
    private func serialize(publicKey pubkey: UnsafePointer<secp256k1_pubkey>) -> Data {
        var size = 33
        var data = Data(count: size)
        
        data.withUnsafeMutableBytes {
            secp256k1_ec_pubkey_serialize(context, $0.bufferPointer, &size, pubkey, UInt32(SECP256K1_EC_COMPRESSED))
            return
        }
        
        return data
    }
    
    private func serialize(recoverableSignature sig: UnsafePointer<secp256k1_ecdsa_recoverable_signature>) -> Data {
        var signature = Data(count: 64)
        var recoveryId: Int32 = -1
        signature.withUnsafeMutableBytes {
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, $0.bufferPointer, &recoveryId, sig)
            return
        }
        return signature
    }
}

// MARK: - Extension
extension Data {
    public var ecdsa: SignatureEngine {
        Ecdsa(data: self)
    }
}
