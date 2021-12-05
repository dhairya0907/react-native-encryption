package com.dhairyasharma.reactnativeencryption

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.security.GeneralSecurityException
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import java.security.Security
import java.security.spec.InvalidKeySpecException
import java.security.spec.KeySpec
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec
import rnencryption.bouncycastle.jce.provider.BouncyCastleProvider

class fileEncryptionOutput(val iv: ByteArray?, val salt: ByteArray?)

class textEncryptionOutput(val iv: ByteArray?, val salt: ByteArray?, val encryptedText: ByteArray?)

@ReactModule(name = "RNEncryptionModule")
class RNEncryptionModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNEncryptionModule"
    }

    private val ENCRYPT_ALGO = "AES/CTR/NoPadding"
    private val IV_LENGTH_BYTE = 16
    private val SALT_LENGTH_BYTE = 16

    private fun getRandomNonce(numBytes: Int): ByteArray {
        val nonce = ByteArray(numBytes)
        SecureRandom().nextBytes(nonce)
        return nonce
    }

    @Throws(NoSuchAlgorithmException::class, InvalidKeySpecException::class)
    fun getAESKeyFromPassword(password: CharArray?, salt: ByteArray?): SecretKey {
        val factory: SecretKeyFactory =
            SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512", "RNEBC")
        val spec: KeySpec = PBEKeySpec(password, salt, 65536, 256)
        return SecretKeySpec(factory.generateSecret(spec).getEncoded(), "AES")
    }

    @Throws(java.lang.Exception::class)
    fun textDecryption(cipherText: String, password: String?, iv: String?, salt: String?): String {
        val iv = iv?.hexStringToByteArray()
        val salt = salt?.hexStringToByteArray()
        val aesKeyFromPassword = getAESKeyFromPassword(password?.toCharArray(), salt)
        val cipher: Cipher = Cipher.getInstance(ENCRYPT_ALGO, "RNEBC")

        cipher.init(Cipher.DECRYPT_MODE, aesKeyFromPassword, IvParameterSpec(iv))

        val plainText = cipher.doFinal(cipherText.hexStringToByteArray())

        return plainText.toString(Charsets.UTF_8)
    }

    @Throws(java.lang.Exception::class)
    fun fileDecryption(
        encryptedFilePath: File?,
        decryptedFilePath: File?,
        password: String?,
        iv: String?,
        salt: String?
    ) {
        val iv = iv?.hexStringToByteArray()
        val salt = salt?.hexStringToByteArray()
        val aesKeyFromPassword = getAESKeyFromPassword(password?.toCharArray(), salt)
        val cipher: Cipher = Cipher.getInstance(ENCRYPT_ALGO, "RNEBC")

        cipher.init(Cipher.DECRYPT_MODE, aesKeyFromPassword, IvParameterSpec(iv))

        var fos: FileOutputStream? = null
        var cis: CipherInputStream? = null
        var fis: FileInputStream? = null
        try {
            fis = FileInputStream(encryptedFilePath)
            cis = CipherInputStream(fis, cipher)
            fos = FileOutputStream(decryptedFilePath)
            val data = ByteArray(1024)
            var read: Int = cis.read(data)
            while (read != -1) {
                fos.write(data, 0, read)
                fos.flush()
                read = cis.read(data)
            }
        } finally {
            cis?.close()
            fos?.close()
            fis?.close()
        }
    }

    @Throws(java.lang.Exception::class)
    fun textEncryption(
        plainText: String,
        password: String?,
    ): textEncryptionOutput {
        val salt = getRandomNonce(SALT_LENGTH_BYTE)
        val iv = getRandomNonce(IV_LENGTH_BYTE)
        val aesKeyFromPassword = getAESKeyFromPassword(password?.toCharArray(), salt)
        val cipher: Cipher = Cipher.getInstance(ENCRYPT_ALGO, "RNEBC")

        cipher.init(Cipher.DECRYPT_MODE, aesKeyFromPassword, IvParameterSpec(iv))

        val cipherText = cipher.doFinal(plainText.toByteArray(Charsets.UTF_8))

        return textEncryptionOutput(iv, salt, cipherText)
    }

    @Throws(java.lang.Exception::class)
    fun fileEncryption(
        inputFilePath: File?,
        encryptedFilePath: File?,
        password: String?
    ): fileEncryptionOutput {

        val salt = getRandomNonce(SALT_LENGTH_BYTE)
        val iv = getRandomNonce(IV_LENGTH_BYTE)
        val aesKeyFromPassword = getAESKeyFromPassword(password?.toCharArray(), salt)
        val cipher: Cipher = Cipher.getInstance(ENCRYPT_ALGO, "RNEBC")

        cipher.init(Cipher.ENCRYPT_MODE, aesKeyFromPassword, IvParameterSpec(iv))

        var fos: FileOutputStream? = null
        var cos: CipherOutputStream? = null
        var fis: FileInputStream? = null
        try {
            fis = FileInputStream(inputFilePath)
            fos = FileOutputStream(encryptedFilePath)
            cos = CipherOutputStream(fos, cipher)
            fos = null
            val data = ByteArray(1024)
            var read: Int = fis.read(data)
            while (read != -1) {
                cos.write(data, 0, read)
                cos.flush()
                read = fis.read(data)
            }
            cos.flush()
        } finally {
            cos?.close()
            fos?.close()
            fis?.close()
        }
        return fileEncryptionOutput(iv, salt)
    }

    @ReactMethod
    fun decryptText(
        cipherText: String,
        password: String,
        iv: String,
        salt: String,
        promise: Promise
    ) {
        try {
            Security.addProvider(BouncyCastleProvider())

            if (cipherText == null || cipherText == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Cipher Text is required")
                promise.resolve(response)
            } else if (password == null || password == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Password is required")
                promise.resolve(response)
            } else if (iv == null || iv == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "IV is required")
                promise.resolve(response)
            } else if (salt == null || salt == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Salt is required")
                promise.resolve(response)
            } else {
                val decryptedText = textDecryption(cipherText, password, iv, salt)
                val response = WritableNativeMap()
                response.putString("status", "success")
                response.putString("decryptedText", decryptedText)
                promise.resolve(response)
            }
        } catch (e: GeneralSecurityException) {
            promise.reject(e)
        } catch (e: Exception) {
            promise.reject(e)
        }
    }

    @ReactMethod
    fun decryptFile(
        encryptedFilePath: String,
        decryptedFilePath: String,
        password: String,
        iv: String,
        salt: String,
        promise: Promise
    ) {
        try {
            Security.addProvider(BouncyCastleProvider())

            if (encryptedFilePath == null || encryptedFilePath == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Encrypted File Path is required")
                promise.resolve(response)
            } else if (decryptedFilePath == null || decryptedFilePath == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Decrypted File Path is required")
                promise.resolve(response)
            } else if (password == null || password == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Password is required")
                promise.resolve(response)
            } else if (iv == null || iv == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "IV is required")
                promise.resolve(response)
            } else if (salt == null || salt == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Salt is required")
                promise.resolve(response)
            } else {
                fileDecryption(File(encryptedFilePath), File(decryptedFilePath), password, iv, salt)
                val response = WritableNativeMap()
                response.putString("status", "success")
                response.putString("message", "File Decrypted successfully.")

                promise.resolve(response)
            }
        } catch (e: GeneralSecurityException) {
            promise.reject(e)
        } catch (e: Exception) {
            promise.reject(e)
        }
    }

    @ReactMethod
    fun encryptText(plainText: String, password: String, promise: Promise) {
        try {
            Security.addProvider(BouncyCastleProvider())

            if (plainText == null || plainText == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Plain text is required")
                promise.resolve(response)
            } else if (password == null || password == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Password is required")
                promise.resolve(response)
            } else {
                val sealed = textEncryption(plainText, password)
                val response = WritableNativeMap()
                response.putString("status", "success")
                response.putString("iv", sealed.iv?.toHex())
                response.putString("salt", sealed.salt?.toHex())
                response.putString("encryptedText", sealed.encryptedText?.toHex())
                promise.resolve(response)
            }
        } catch (e: GeneralSecurityException) {
            promise.reject(e)
        } catch (e: Exception) {
            promise.reject(e)
        }
    }

    @ReactMethod
    fun encryptFile(
        inputFilePath: String,
        encryptedFilePath: String,
        password: String,
        promise: Promise
    ) {
        try {
            Security.addProvider(BouncyCastleProvider())

            if (inputFilePath == null || inputFilePath == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Input File Path is required")
                promise.resolve(response)
            } else if (encryptedFilePath == null || encryptedFilePath == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Encrypted File Path is required")
                promise.resolve(response)
            } else if (password == null || password == "") {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "Password is required")
                promise.resolve(response)
            } else if (!File(inputFilePath).exists()) {
                val response = WritableNativeMap()
                response.putString("status", "Fail")
                response.putString("error", "File for encryption not found")
                promise.resolve(response)
            } else {
                val sealed = fileEncryption(File(inputFilePath), File(encryptedFilePath), password)
                val response = WritableNativeMap()
                response.putString("status", "success")
                response.putString("iv", sealed.iv?.toHex())
                response.putString("salt", sealed.salt?.toHex())
                promise.resolve(response)
            }
        } catch (e: GeneralSecurityException) {
            promise.reject(e)
        } catch (e: Exception) {
            promise.reject(e)
        }
    }
}
