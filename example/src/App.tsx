import React, { useEffect } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Alert,
  Pressable,
} from "react-native";
import RNEncryptionModule from "react-native-encryption";
import { launchImageLibrary } from "react-native-image-picker";
var RNFS = require("react-native-fs");

const App = () => {
  const [plainText, setPlainText] = React.useState("");
  const [encryptPassword, setEncryptPassword] = React.useState("");
  const [cipherText, setCipherText] = React.useState("");
  const [decryptPassword, setDecryptPassword] = React.useState("");
  const [iv, setIv] = React.useState("");
  const [salt, setSalt] = React.useState("");
  const [decryptedText, setDecryptedText] = React.useState("");

  const [inputFilePath, setInputFilePath] = React.useState("");
  const [encryptFilePath, setEncryptFilePath] = React.useState("");
  const [encryptFilePassword, setEncryptFilePassword] = React.useState("");
  const [encryptInputFilePath, setEncryptInputFilePath] = React.useState("");
  const [decryptFilePath, setDecryptFilePath] = React.useState("");
  const [decryptFilePassword, setDecryptFilePassword] = React.useState("");
  const [fileIv, setFileIv] = React.useState("");
  const [fileSalt, setFileSalt] = React.useState("");
  const [fileDecryptMessage, setFileDecryptMessage] = React.useState("");

  function encryptText() {
    RNEncryptionModule.encryptText(plainText, encryptPassword)
      .then((res: any) => {
        if (res.status == "success") {
          setCipherText(res.encryptedText);
          setDecryptPassword(encryptPassword);
          setIv(res.iv);
          setSalt(res.salt);
        } else {
          Alert.alert("Error", res.error);
        }
      })
      .catch((err: any) => {
        console.log(err);
      });
  }

  function decryptText() {
    RNEncryptionModule.decryptText(cipherText, decryptPassword, iv, salt)
      .then((res: any) => {
        if (res.status == "success") {
          setDecryptedText(res.decryptedText);
        } else {
          Alert.alert("Error", res.error);
        }
      })
      .catch((err: any) => {
        console.log(err);
      });
  }

  function encryptFile() {
    RNEncryptionModule.encryptFile(
      inputFilePath,
      encryptFilePath,
      encryptFilePassword
    ).then((res: any) => {
      if (res.status == "success") {
        setEncryptInputFilePath(encryptFilePath);
        setDecryptFilePassword(encryptFilePassword);
        setFileIv(res.iv);
        setFileSalt(res.salt);
      } else {
        Alert.alert("Error", res.error);
      }
    });
  }

  function decryptFile() {
    RNEncryptionModule.decryptFile(
      encryptInputFilePath,
      decryptFilePath,
      decryptFilePassword,
      fileIv,
      fileSalt
    ).then((res: any) => {
      if (res.status == "success") {
        setFileDecryptMessage(res.message);
      } else {
        Alert.alert("Error", res.error);
      }
    });
  }

  function launchImagePicker() {
    launchImageLibrary({
      mediaType: "mixed",
    }).then((response) => {
      if (!response.didCancel && response.assets) {
        setDecryptFilePath(
          (
            RNFS.DocumentDirectoryPath +
            "/Decrypt_" +
            response.assets[0].uri!.split("/").pop()
          ).substring(1)
        );

        setEncryptFilePath(
          (
            RNFS.DocumentDirectoryPath +
            "/Encrypted_" +
            response.assets[0].uri!.split("/").pop()
          ).substring(1)
        );

        setInputFilePath(response.assets[0].uri!.substring(8));
      }
    });
  }

  return (
    <ScrollView
      contentContainerStyle={{
        alignItems: "center",
        width: "100%",
        height: 1900,
      }}
    >
      <Text style={{ top: 50 }}>RNEncryption Module</Text>
      <Text style={{ top: 80, alignSelf: "flex-start", left: 10 }}>
        Text Encryption
      </Text>
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 100 }}
        placeholder="  Plain Text"
        onChangeText={(plainText) => setPlainText(plainText)}
        value={plainText}
      />
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 120 }}
        placeholder="  Password"
        onChangeText={(encryptPassword) => setEncryptPassword(encryptPassword)}
        value={encryptPassword}
      />
      <TouchableOpacity
        style={{
          height: 50,
          width: "70%",
          borderWidth: 2,
          justifyContent: "center",
          alignItems: "center",
          top: 140,
        }}
        onPress={encryptText}
      >
        <Text style={{}}>Encrypt</Text>
      </TouchableOpacity>
      <Text style={{ top: 180, alignSelf: "flex-start", left: 10 }}>
        Text Decryption
      </Text>
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 200 }}
        placeholder="  Cipher Text"
        onChangeText={(cipherText) => setCipherText(cipherText)}
        value={cipherText}
      />
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 220 }}
        placeholder="  Password"
        onChangeText={(decryptPassword) => setDecryptPassword(decryptPassword)}
        value={decryptPassword}
      />
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 240 }}
        placeholder="  IV"
        onChangeText={(iv) => setIv(iv)}
        value={iv}
      />
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 260 }}
        placeholder="  Salt"
        onChangeText={(salt) => setSalt(salt)}
        value={salt}
      />
      <TextInput
        style={{ width: "90%", height: 50, borderWidth: 2, top: 280 }}
        placeholder="  Decrypted Text"
        onChangeText={(decryptedText) => setDecryptedText(decryptedText)}
        value={decryptedText}
      />
      <TouchableOpacity
        style={{
          height: 50,
          width: "70%",
          borderWidth: 2,
          justifyContent: "center",
          alignItems: "center",
          top: 300,
        }}
        onPress={decryptText}
      >
        <Text style={{}}>Decrypt</Text>
      </TouchableOpacity>
      <Text style={{ top: 340, alignSelf: "flex-start", left: 10 }}>
        File Encryption
      </Text>
      <Pressable
        style={{ width: "90%", height: 50, top: 360 }}
        onPress={() => launchImagePicker()}
      >
        <View pointerEvents="none">
          <TextInput
            style={{ width: "100%", height: 50, borderWidth: 2 }}
            placeholder="  Input File Path"
            value={inputFilePath}
          />
        </View>
      </Pressable>
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 380, width: "90%" }}
        placeholder="  Encrypted File Path"
        value={encryptFilePath}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 400, width: "90%" }}
        placeholder="  Password"
        onChangeText={(encryptFilePassword) =>
          setEncryptFilePassword(encryptFilePassword)
        }
        value={encryptFilePassword}
      />
      <TouchableOpacity
        style={{
          height: 50,
          width: "70%",
          borderWidth: 2,
          justifyContent: "center",
          alignItems: "center",
          top: 420,
        }}
        onPress={encryptFile}
      >
        <Text style={{}}>Encrypt</Text>
      </TouchableOpacity>
      <Text style={{ top: 480, alignSelf: "flex-start", left: 10 }}>
        File Decryption
      </Text>
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 500, width: "90%" }}
        placeholder="  Encrypted File Path"
        onChangeText={(encryptInputFilePath) =>
          setEncryptInputFilePath(encryptInputFilePath)
        }
        value={encryptInputFilePath}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 520, width: "90%" }}
        placeholder="  Decrypted File Path"
        onChangeText={(decryptFilePath) => setDecryptFilePath(decryptFilePath)}
        value={decryptFilePath}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 540, width: "90%" }}
        placeholder="  Password"
        onChangeText={(decryptFilePassword) =>
          setDecryptFilePassword(decryptFilePassword)
        }
        value={decryptFilePassword}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 560, width: "90%" }}
        placeholder="  IV"
        onChangeText={(iv) => setFileIv(iv)}
        value={fileIv}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 580, width: "90%" }}
        placeholder="  Salt"
        onChangeText={(salt) => setFileSalt(salt)}
        value={fileSalt}
      />
      <TextInput
        style={{ height: 50, borderWidth: 2, top: 600, width: "90%" }}
        placeholder="  Decrypted File Message"
        editable={false}
        value={fileDecryptMessage}
      />
      <TouchableOpacity
        style={{
          height: 50,
          borderWidth: 2,
          top: 620,
          width: "70%",
          justifyContent: "center",
          alignItems: "center",
        }}
        onPress={decryptFile}
      >
        <Text style={{}}>Decrypt</Text>
      </TouchableOpacity>
    </ScrollView>
  );
};

export default App;
