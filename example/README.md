# example

## Getting Started

### Clone this repository
```bash
git clone https://github.com/dhairya0907/react-native-encryption.git
```

### Setup
```sh
cd react-native-encryption && yarn && cd example && yarn
```

```sh
# Without this execution, you will get an error for pod install because of react-native-fetch-blob

grep -rl "s.dependency 'React/Core'" node_modules/ | xargs sed -i '' 's=React/Core=React-Core=g'
```

```sh
# Skip this, if not using ios

cd ios && pod install && cd ..
```
***If you make changes to the code, run setup again***

&nbsp;
### To run the app use:

```sh
npx react-native run-ios
```

or

```sh
npx react-native run-android
```
&nbsp;
## Author

Dhairya Sharma | [@dhairya0907](https://github.com/dhairya0907)

&nbsp;
## License

The library is released under the MIT license. For more information see [`LICENSE`](/LICENSE).
