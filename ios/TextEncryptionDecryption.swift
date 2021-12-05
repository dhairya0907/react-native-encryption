//
//  TextEncryptionDecryption.swift
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

import Foundation
import CommonCrypto

open class TextEncryptionDecryption: NSObject {
    open class func crypt(text: String, keyData:Data, ivData:Data, operation:String) -> Data? {
        let algorithm = Cryptor.Algorithm.aes
        if(operation == "encryption")
        {
            
            let cryptor = Cryptor(operation:.encrypt, algorithm:algorithm,mode: .CTR, padding: .NoPadding, key:Array(keyData), iv:Array(ivData))
            let cipherText = cryptor.update(text)?.final()
            
            return Data(cipherText!);
        }
        else if(operation == "decryption")
        {
            let cryptor = Cryptor(operation:.decrypt, algorithm:algorithm,mode: .CTR, padding: .NoPadding, key:Array(keyData), iv:Array(ivData))
            let plainText = cryptor.update(text.hexadecimaltodata!)?.final()
            
            return Data(plainText!);
        }
        
        return nil
    }
    
}

