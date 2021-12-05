//
//  TextEncryptionDecryption.swift
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

import Foundation
import CommonCrypto

open class TextEncryptionDecryption: NSObject {
    open class func crypt(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)

        let keyLength             = size_t(kCCKeySizeAES128)
        let options   = CCOptions(kCCOptionPKCS7Padding)


        var numBytesEncrypted :size_t = 0

        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  options,
                                  keyBytes.bindMemory(to: UInt8.self).baseAddress, keyLength,
                                  ivBytes.bindMemory(to: UInt8.self).baseAddress,
                                  dataBytes.bindMemory(to: UInt8.self).baseAddress, data.count,
                                  cryptBytes.bindMemory(to: UInt8.self).baseAddress, cryptLength,
                                  &numBytesEncrypted)
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)

        } else {
            print("Error: \(cryptStatus)")
        }

        return cryptData;
    }
    
}

