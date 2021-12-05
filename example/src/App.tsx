import React, { useEffect } from "react";
import { View, Text } from "react-native";
import RNEncryptionModule from "react-native-encryption";

const App = () => {
  useEffect(() => {
    RNEncryptionModule.encryptText(
      "The quick brown fox jumps over the lazy dog.",
      "password"
    )
      .then((res: any) => {
        console.log(res);
        RNEncryptionModule.decryptText(
          res.encryptedText,
          "password",
          res.iv,
          res.salt
        )
          .then((res: any) => {
            console.log(res);
          })
          .catch((err: any) => {
            console.log(err);
          });
      })
      .catch((err: any) => {
        console.log(err);
      });
  });

  return (
    <View style={{ alignItems: "center", top: "50%" }}>
      <Text>Everything Working</Text>
      <Text></Text>
      <Text>{RNEncryptionModule.count}</Text>
    </View>
  );
};

export default App;
