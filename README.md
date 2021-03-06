# `@dhairyasharma/react-native-encryption`

![Supports Android, iOS](https://img.shields.io/badge/platforms-android%20|%20ios%20-lightgrey.svg) [ ![MIT License](https://img.shields.io/npm/l/@react-native-community/netinfo.svg) ](/LICENSE) ![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg) [ ![Maintainer](https://img.shields.io/badge/maintainer-dhairya0907-blue) ](https://github.com/dhairya0907) [![Generic badge](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/dhairya0907/react-native-encryption/releases)

[![Twitter](https://img.shields.io/badge/dhairya__0907-%231DA1F2.svg?style=for-the-badge&logo=Twitter&logoColor=white) ](https://twitter.com/dhairya_0907) [ ![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white) ](https://www.linkedin.com/in/dhairyasharma0907/)

### Encryption/decryption for React Native.

&nbsp;


# Benchmark

|                                                                                                                                                                                                           |                                                
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **File Details**                                                                                                                                                                                          |
| **_File Link_**<br>http://bit.do/benchmarkfile<br>**_File Size_**<br>1.09 GB                                                                                                                              |
| **IOS Benchmark**                                                                                                                                                                                         |
| **_Average of 100 Encryption_**<br>4.859 seconds<br><br>**_Average of 100 Decryption_**<br>5.594 seconds<br><br>Check Log for all IOS encryption [here](https://github.com/dhairya0907/react-native-encryption/blob/3e267e006f1fd1ed115733da2a86c21437865878/benchmark/IOS_LOGS.txt#L2).<br>Check Log for all IOS decryption [here](https://github.com/dhairya0907/react-native-encryption/blob/3e267e006f1fd1ed115733da2a86c21437865878/benchmark/IOS_LOGS.txt#L110).          |
| **Android Benchmark**                                                                                                                                                                                     |
| **_Average of 100 Encryption_**<br>20.373 seconds<br><br>**_Average of 100 Decryption_**<br>21.908 seconds<br><br>Check Log for all Android encryption [here](https://github.com/dhairya0907/react-native-encryption/blob/3e267e006f1fd1ed115733da2a86c21437865878/benchmark/ANDROID_LOGS.txt#L2).<br>Check Log for all Android decryption [here](https://github.com/dhairya0907/react-native-encryption/blob/3e267e006f1fd1ed115733da2a86c21437865878/benchmark/ANDROID_LOGS.txt#L109). |
|                                                                                                                                                                                                           | 

&nbsp;

# Features

- Encrypt/decrypt any length of text.
- Encrypt/decrypt any type of file.
- Encrypt/decrypt any size of file.

&nbsp;

# Getting started

Install the library using either Yarn:

```
yarn add @dhairyasharma/react-native-encryption
```

or npm:

```sh
npm install --save @dhairyasharma/react-native-encryption
```

or git:

```sh
npm install git+https://github.com/dhairya0907/react-native-encryption.git
```

### Using React Native >= 0.60

&nbsp;
Linking the package manually is not required anymore with [Autolinking](https://github.com/react-native-community/cli/blob/master/docs/autolinking.md).

- **iOS Platform:**

```sh
cd ios && pod install && cd ..
```

- **Android Platform:**

  Does not require any additional steps.

# Usage

## Import the library

```javascript
import RNEncryptionModule from "@dhairyasharma/react-native-encryption";
```

## Encrypt Text

```typescript
RNEncryptionModule.encryptText(
    plainText,
    password
    ).then((res: any) => {
        if (res.status == "success") {
            console.log("success", res)
        } else {
            Alert.alert("Error", res);
        }
        }).catch((err: any) => {
            console.log(err);
        });
```

- **plainText** : Plain text to be encrypted.
- **password** : Password to encrypt the plain text.

```javascript
returns

// If text encryption is successful, it returns a JSON object with the following structure:
{
  "status": "success",
  "encryptedText": "encryptedText",
  "iv": "iv",
  "salt": "salt"
}

or

// If text encryption is unsuccessful, it returns a JSON object with the following structure:
{
  "status": "Fail",
  "error": "error"
}
```

## Decrypt Text

```typescript
RNEncryptionModule.decryptText(
    encryptedText,
    password,
    iv,
    salt).then((res: any) => {
        if (res.status == "success") {
            console.log("success", res)
        } else {
            Alert.alert("Error", res);
        }
        }).catch((err: any) => {
            console.log(err);
        });
```

- **encryptedText** : Cipher text to be decrypted.
- **password** : Password to decrypt the cipher text.
- **iv** : Initialization vector from encryptText.
- **salt** : Salt from encryptText.

```javascript
returns

// If text decryption is successful, it returns a JSON object with the following structure:
{
  "status": "success",
  "decryptedText": "decryptedText"
}

or

// If text decryption is unsuccessful, it returns a JSON object with the following structure:
{
  "status": "Fail",
  "error": "error"
}
```

## Encrypt File

```typescript
 RNEncryptionModule.encryptFile(
      inputFilePath,
      outputEncryptedFilePath,
      password
    ).then((res: any) => {
        if (res.status == "success") {
            console.log("success", res)
        } else {
            console.log("error", res);
        }
        }).catch((err: any) => {
            console.log(err);
        });
```

- **inputFilePath** : Path of the file to be encrypted.
- **outputEncryptedFilePath** : Path of the encrypted file.
- **password** : Password to encrypt the file.

```javascript
returns

// If file encryption is successful, it returns a JSON object with the following structure:
{
  "status": "success",
  "iv": "iv",
  "salt": "salt"

}

or

// If file encryption is unsuccessful, it returns a JSON object with the following structure:
{
  "status": "Fail",
  "error": "error"
}
```

## Decrypt File

```typescript
 RNEncryptionModule.decryptFile(
      encryptedFilePath,
      outputDecryptedFilePath,
      password,
      iv,
      salt
    ).then((res: any) => {
        if (res.status == "success") {
            console.log("success", res)
        } else {
            console.log("error", res);
        }
        }).catch((err: any) => {
            console.log(err);
        });
```

- **encryptedFilePath** : Path of the file to be decrypted.
- **outputDecryptedFilePath** : Path of the decrypted file.
- **password** : Password to decrypt the file.
- **iv** : Initialization vector from encryptFile.
- **salt** : Salt from encryptFile.

```javascript
returns

// If file decryption is successful, it returns a JSON object with the following structure:
{
  "status": "success",
  "message" : "File decrypted successfully"

}

or

// If file decryption is unsuccessful, it returns a JSON object with the following structure:
{
  "status": "Fail",
  "error": "error"
}
```

---

**NOTE**

On android, Input or Output file path does not support **_content://_**&nbsp; type file path. Please use **_file://_**&nbsp; type file path.

You can use [react-native-fetch-blob stat](https://github.com/wkh237/react-native-fetch-blob/wiki/File-System-Access-API#user-content-statpathstringpromisernfetchblobstat) to get original path. See [example](https://github.com/dhairya0907/react-native-encryption/blob/3e267e006f1fd1ed115733da2a86c21437865878/example/src/App.tsx#L115).

**_You will need Files and media permission for this._**

---

&nbsp;

# Acknowledgements

- Inspired by [react-native-aes-gcm-crypto](https://github.com/craftzdog/react-native-aes-gcm-crypto)
- Module template by [react-native-module-template](https://github.com/demchenkoalex/react-native-module-template)
- IOS library by [IDZSwiftCommonCrypto](https://github.com/iosdevzone/IDZSwiftCommonCrypto)
- Android library by [bc-java](https://github.com/bcgit/bc-java) edited using [nodejs-mybc-util](https://github.com/jbuhacoff/nodejs-mybc-util)

&nbsp;

# Author

Dhairya Sharma | [@dhairya0907](https://github.com/dhairya0907)

&nbsp;

# License

The library is released under the MIT license. For more information see [`LICENSE`](/LICENSE).
