//
//  FileEncryptionDecryption.swift
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

import Foundation

open class FileEncryptionDecryption: NSObject {
    
    open class func crypt(sc : StreamCryptor,  inputStream: InputStream, outputStream: OutputStream, bufferSize: Int) -> (bytesRead: Int, bytesWritten: Int)
    {
        var inputBuffer = Array<UInt8>(repeating:0, count:1024)
        var outputBuffer = Array<UInt8>(repeating:0, count:1024)
        var cryptedBytes : Int = 0
        var totalBytesWritten = 0
        var totalBytesRead = 0
        
        while inputStream.hasBytesAvailable
        {
            let bytesRead = inputStream.read(&inputBuffer, maxLength: inputBuffer.count)
            totalBytesRead += bytesRead
            let status = sc.update(bufferIn: inputBuffer, byteCountIn: bytesRead, bufferOut: &outputBuffer, byteCapacityOut: outputBuffer.count, byteCountOut: &cryptedBytes)
            assert(status == Status.success)
            if(cryptedBytes > 0)
            {
                let bytesWritten = outputStream.write(outputBuffer, maxLength: Int(cryptedBytes))
                assert(bytesWritten == Int(cryptedBytes))
                totalBytesWritten += bytesWritten
            }
        }
        
        let status = sc.final(bufferOut: &outputBuffer, byteCapacityOut: outputBuffer.count, byteCountOut: &cryptedBytes)
        assert(status == Status.success)
        
        if(cryptedBytes > 0)
        {
            let bytesWritten = outputStream.write(outputBuffer, maxLength: Int(cryptedBytes))
            assert(bytesWritten == Int(cryptedBytes))
            totalBytesWritten += bytesWritten
        }
        
        return (totalBytesRead, totalBytesWritten)
    }
}
