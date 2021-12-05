import { NativeModules } from 'react-native';

export type EncryptedData = {
  iv: string;
  salt: string;
  encryptedText: string;
};

type ReactNativeEncryption = {
  decryptText(
    cipherText: string,
    password: string,
    iv: string,
    salt: string
  ): Promise<string>;
  decryptFile(
    encryptedFilePath: string,
    decryptedFilePath: string,
    password: string,
    iv: string,
    salt: string
  ): Promise<string>;
  encryptText(plainText: string, password: string): Promise<EncryptedData>;
  encryptFile(
    inputFilePath: string,
    encryptedFilePath: string,
    password: string
  ): Promise<{
    iv: string;
    salt: string;
  }>;
};

export default NativeModules.RNEncryptionModule
