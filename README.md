# `@dhairya0907/react-native-encryption`

![Supports Android, iOS](https://img.shields.io/badge/platforms-android%20|%20ios%20-lightgrey.svg) ![MIT License](https://img.shields.io/npm/l/@react-native-community/netinfo.svg)

Encryption/decryption for React Native

# Getting started

Install the library using either Yarn:

```
yarn add @dhairya0907/react-native-encryption
```

or npm:

```sh
npm install --save @dhairya0907/react-native-encryption
```

or git:

```sh
npm install git+https://github.com/dhairya0907/react-native-encryption.git
```

&nbsp;

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

Import the library:

```javascript
import RNEncryptionModule from "@dhairya0907/react-native-encryption";
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
  "status": "error",
  "error": "error"
}
```

## Decrypt Text

```typescript
RNEncryptionModule.decryptText(
    cipherText,
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
  "status": "error",
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
  "status": "error",
  "error": "error"
}
```

## Encrypt File

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
  "status": "error",
  "error": "error"
}
```
