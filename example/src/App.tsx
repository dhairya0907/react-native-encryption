import React, { useEffect } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
} from "react-native";
import RNEncryptionModule from "react-native-encryption";

const App = () => {
  const [plainText, setPlainText] = React.useState("");
  const [encryptPassword, setEncryptPassword] = React.useState("");
  const [cipherText, setCipherText] = React.useState("");
  const [decryptPassword, setDecryptPassword] = React.useState("");
  const [iv, setIv] = React.useState("");
  const [salt, setSalt] = React.useState("");
  const [decryptedText, setDecryptedText] = React.useState("");

  function encrypt() {
    RNEncryptionModule.encryptText(plainText, encryptPassword)
      .then((res: any) => {
        setCipherText(res.encryptedText);
        setDecryptPassword(encryptPassword);
        setIv(res.iv);
        setSalt(res.salt);
      })
      .catch((err: any) => {
        console.log(err);
      });
  }

  function decrypt() {
    RNEncryptionModule.decryptText(cipherText, decryptPassword, iv, salt)
      .then((res: any) => {
        setDecryptedText(res.decryptedText);
      })
      .catch((err: any) => {
        console.log(err);
      });
  }

  return (
    <ScrollView
      contentContainerStyle={{
        alignItems: "center",
        width: "100%",
        height: 900,
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
        onPress={encrypt}
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
        onPress={decrypt}
      >
        <Text style={{}}>Decrypt</Text>
      </TouchableOpacity>
    </ScrollView>
  );
};

export default App;
