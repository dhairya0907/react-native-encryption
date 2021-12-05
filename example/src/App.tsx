import React, { useEffect } from 'react'
import RNEncryptionModule, { Counter } from 'react-native-encryption'

const App = () => {
  useEffect(() => {
    console.log(RNEncryptionModule)
  })

  return <Counter />
}

export default App
