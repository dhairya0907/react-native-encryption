//
//  KeyGeneration.swift
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

import Foundation
import CommonCrypto

open class KeyGeneration: NSObject {
    open class func pbkdf2(
        hash: CCPBKDFAlgorithm,
        password: String,
        salt: Data,
        keyByteCount: Int,
        rounds: Int
    ) -> Data? {
        guard let passwordData = password.data(using: .utf8) else { return nil }
        
        var derivedKeyData = Data(repeating: 0, count: keyByteCount)
        let derivedCount = derivedKeyData.count
        
        let derivationStatus: OSStatus = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            let derivedKeyRawBytes = derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress
            return salt.withUnsafeBytes { saltBytes in
                let rawBytes = saltBytes.bindMemory(to: UInt8.self).baseAddress
                return CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    rawBytes,
                    salt.count,
                    hash,
                    UInt32(rounds),
                    derivedKeyRawBytes,
                    derivedCount)
            }
        }
        
        return derivationStatus == kCCSuccess ? derivedKeyData : nil
    }
}
