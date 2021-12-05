//
//  FormatChangeExtention.swift
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

import Foundation

public extension Data {
    var datatohexadecimal: String {
        return map { String(format: "%02x", $0) }
        .joined()
    }
}

public extension String {
    var hexadecimaltodata: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}
