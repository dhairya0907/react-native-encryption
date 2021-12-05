package com.dhairyasharma.reactnativeencryption

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule

class RNEncryptionModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "RNEncryptionModule"

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }
}
