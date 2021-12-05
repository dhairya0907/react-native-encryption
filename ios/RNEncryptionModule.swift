//
//  RNEncryptionModule.swift
//  RNEncryptionModule
//
//   Created by Dhairya Sharma on 05/12/21.
//

import Foundation
import CommonCrypto


@objc(RNEncryptionModule)
class RNEncryptionModule: NSObject {
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    private let ENCRYPT_ALGO = Cryptor.Algorithm.aes
    private let IV_LENGTH_BYTE = 16
    private let SALT_LENGTH_BYTE = 16
    
    func getRandomNonce(numBytes: Int) -> Data? {
        
        var nonce = Data(count: numBytes)
        let result = nonce.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, numBytes, $0.baseAddress!)
        }
        
        if result == errSecSuccess {
            return nonce
        }
        
        return nil
    }
    
    func getAESKeyFromPassword(password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data?
    {
        return KeyGeneration.pbkdf2(
            hash: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512), password: password, salt: salt,
            keyByteCount: keyByteCount, rounds: rounds)
    }
    
    func decryptText(cipherText: String, password: String, iv: String, salt: String) -> [String:String?]
    {
        let salt = salt.hexadecimaltodata
        let iv = iv
        let aesKeyFromPassword = self.getAESKeyFromPassword(password: password, salt: salt!, keyByteCount: 32, rounds: 65536)
        
        let decryptedText = TextEncryptionDecryption.crypt(data: cipherText.hexadecimaltodata!, keyData: aesKeyFromPassword!, ivData: iv.hexadecimaltodata!, operation:kCCDecrypt)
        
        return ["decryptedText" : String(decoding: decryptedText, as: UTF8.self)]
    }
    
    func decryptFile(encryptedFilePath: String, decryptedFilePath: String, password: String, iv: String, salt: String) -> [String:String?]
    {
        do {
            
            let salt = salt.hexadecimaltodata
            let iv = iv.hexadecimaltodata
            let aesKeyFromPassword = self.getAESKeyFromPassword(password: password, salt: salt!, keyByteCount: 32, rounds: 65536)
            
            
            guard let encryptedFileStream = InputStream(fileAtPath: encryptedFilePath) else
            {
                return ["error" : "Failed to open the encrypted file for input."]
            }
            encryptedFileStream.open()
            
            guard let decryptedFilStream = OutputStream(toFileAtPath: decryptedFilePath, append:false) else {
                return ["error" : "Failed to open the file for the decrypted output file."]
            }
            decryptedFilStream.open()
            
            let sc = StreamCryptor(operation: .decrypt, algorithm: ENCRYPT_ALGO, mode: .CTR, padding: .NoPadding, key: [UInt8](aesKeyFromPassword!), iv: [UInt8](iv!))
            _ = FileEncryptionDecryption.crypt(sc: sc, inputStream: encryptedFileStream, outputStream: decryptedFilStream, bufferSize: 1024)
            
            encryptedFileStream.close()
            decryptedFilStream.close()
        }
        return ["message" : "File Decrypted Sucessfully."]
    }
    
    
    func encryptText(plainText: String, password: String) -> [String:String?]
    {
        var response = [String: String?]()
        
        let salt = getRandomNonce(numBytes: SALT_LENGTH_BYTE)
        let iv = getRandomNonce(numBytes: IV_LENGTH_BYTE)
        let aesKeyFromPassword = self.getAESKeyFromPassword(password: password, salt: salt!, keyByteCount: 32, rounds: 65536)
        
        let encryptedText = TextEncryptionDecryption.crypt(data: plainText.data(using: .utf8)!, keyData: aesKeyFromPassword!, ivData: iv!, operation:kCCEncrypt)
        
        response = [
            "iv" : iv?.datatohexadecimal,
            "salt" : salt?.datatohexadecimal,
            "encryptedText" : encryptedText.datatohexadecimal
        ]
        
        return response
    }
    
    func encryptFile(inputFilePath: String, encryptedFilePath: String, password: String) -> [String:String?]
    {
        var response = [String: String?]()
        
        do {
            
            let salt = getRandomNonce(numBytes: SALT_LENGTH_BYTE)
            let iv = getRandomNonce(numBytes: IV_LENGTH_BYTE)
            let aesKeyFromPassword = self.getAESKeyFromPassword(password: password, salt: salt!, keyByteCount: 32, rounds: 65536)
            
            
            guard let inputFileStream = InputStream(fileAtPath: inputFilePath) else {
                return ["error" : "Failed to initialize the image input stream."]
            }
            inputFileStream.open()
            
            guard let  encryptedFileStream = OutputStream(toFileAtPath: encryptedFilePath, append:false) else
            {
                return ["error" : "Failed to open output stream."]
            }
            encryptedFileStream.open()
            
            let sc = StreamCryptor(operation: .encrypt, algorithm: ENCRYPT_ALGO, mode: .CTR, padding: .NoPadding, key: [UInt8](aesKeyFromPassword!), iv: [UInt8](iv!))
            
            _ = FileEncryptionDecryption.crypt(sc: sc, inputStream: inputFileStream, outputStream: encryptedFileStream, bufferSize: 1024)
            
            encryptedFileStream.close()
            inputFileStream.close()
            
            
            response = [
                "iv": iv!.datatohexadecimal,
                "salt": salt!.datatohexadecimal,
            ]
            
        }
        return response
    }
    
    @objc(decryptText:withPassword:iv:salt:withResolver:withRejecter:)
    func decryptText(
        cipherText: String, password: String, iv : String, salt : String,
        resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock
    ) {
        let response = self.decryptText(cipherText: cipherText ,password: password, iv: iv, salt: salt)
        resolve(response)
    }
    
    @objc(decryptFile:decryptedFilePath:withPassword:iv:salt:withResolver:withRejecter:)
    func decryptFile(
        encryptedFilePath: String, decryptedFilePath: String, password: String, iv : String, salt : String,
        resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock
    ) {
        let response = self.decryptFile(encryptedFilePath: encryptedFilePath, decryptedFilePath: decryptedFilePath, password: password, iv: iv, salt: salt)
        resolve(response)
    }
    
    
    @objc(encryptText:withPassword:withResolver:withRejecter:)
    func encryptText(
        plainText: String, password: String,
        resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock
    ) {
        let response = self.encryptText(plainText: plainText ,password: password)
        resolve(response)
    }
    
    @objc(encryptFile:encryptedFilePath:withPassword:withResolver:withRejecter:)
    func encryptFile(
        inputFilePath: String, encryptedFilePath: String, password: String,
        resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock
    ) {
        let response = self.encryptFile(inputFilePath: inputFilePath, encryptedFilePath: encryptedFilePath, password: password)
        resolve(response)
    }
    
}

