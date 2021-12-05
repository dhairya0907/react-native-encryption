//
//  RNEncryptionModule.swift
//  RNEncryptionModule
//
//  Copyright © 2021 Dhairya Sharma. All rights reserved.
//

import Foundation

@objc(RNEncryptionModule)
class RNEncryptionModule: NSObject {
  @objc
  func constantsToExport() -> [AnyHashable : Any]! {
    return ["count": 1]
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
