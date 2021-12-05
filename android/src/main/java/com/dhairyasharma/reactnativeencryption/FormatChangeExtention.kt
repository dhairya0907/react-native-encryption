package com.dhairyasharma.reactnativeencryption

private const val HEX_CHARS_STR = "0123456789abcdef"

fun ByteArray.toHex(): String {
    val result = StringBuffer()

    forEach {
        val st = String.format("%02x", it)
        result.append(st)
    }

    return result.toString()
}

fun String.hexStringToByteArray(): ByteArray {

    val result = ByteArray(length / 2)

    for (i in 0 until length step 2) {
        val firstIndex = HEX_CHARS_STR.indexOf(this[i])
        val secondIndex = HEX_CHARS_STR.indexOf(this[i + 1])

        val octet = firstIndex.shl(4).or(secondIndex)
        result[i.shr(1)] = octet.toByte()
    }

    return result
}
