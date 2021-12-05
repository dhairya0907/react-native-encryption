import React, { useEffect } from 'react'
import { View, Text } from 'react-native'
import RNEncryptionModule from 'react-native-encryption'

const App = () => {
  useEffect(() => {
    console.log(RNEncryptionModule)
  })

  return (
    <View style={{alignItems:"center",top : "50%"}}>
      <Text>Everything Working</Text>
      <Text></Text>
      <Text>{RNEncryptionModule.count}</Text>
    </View>
  )
}

export default App
