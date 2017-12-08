# How to test the playground
- Clone [*IDZSwiftCommonCrypto*](https://github.com/iosdevzone/IDZSwiftCommonCrypto)
- Execute this command to create fake module map of CommonCrypto:
```sh
$ sudo xcrun -sdk macosx swift GenerateCommonCryptoModule.swift macosx
```

- Build the Framework for OSX
- Add the Playground in this repo to *IDZSwiftCommonCrypto* workspace
- Execute the Playground
