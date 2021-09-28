# [![AbsioCrypto](logo.png)](https://www.absio.com)
# Absio Crypto SDK for macOs and iOs

## About
The Absio Crypto SDK provides basic cryptographic operations: key generation, key exchange, encyption/decryption, HMAC, signing, hashing and elliptic curve cryptography (ECC). A custom Integrated Encryption Scheme (IES) for confidentiality and source verification is included as part of the ECC features.

## Basics 
Genaral technology overview and toolset can be found [here](http://docs.absio.com/#technologytools)

## Requirements

- iOS 12.0 and higher
- macOs 10.14 and higher
- Xcode 12.5 and higher
- Swift 5.0 and higher

### Install 

Currently we are supporting CocoaPods. 
If you are new to using pods please visit getting started [page](https://guides.cocoapods.org/using/getting-started.html).

To get our pod instantly please use line below

```ruby
pod 'AbsioCrypto', '~> 1.2.0'
```

#### **Note:**
We are distributing fat libraries to support both simulator and different architectures. If you will have **issues with validation/submitting** your application to App Store. Please insert content of [cut-architectures.sh](cut-architectures.sh) into 'Build Phases' of your application with 'New Run Script Phase'. This will strip unused architectures for simulators and validation should went smooth.

## Documentation
Latest documentation can be found at our docs [page](http://docs.absio.com/#technologydata)

The API reference is located at our Github [page](https://absio.github.io/swift-absio-crypto/).

## Symmetric Features
The SDK will perform symmetric key generation, encryption and decryption. By default the SDK will use AES 256.

### Symmetric Key Generation
~~~
let cipher = Cipher()
let aes256Key = cipher.generateKey()
~~~

### Symmetric Encryption
~~~
let cipher = Cipher()
let ciphertextBytes = try cipher.encrypt(key: keyBytes, iv: ivBytes, data: plaintextBytes)
~~~

### Symmetric Decryption
~~~
let cipher = Cipher()
let plaintextBytes = try cipher.decrypt(key: keyBytes, iv: ivBytes, data: ciphertextBytes)
~~~


## Hashing
By default the SDK use SHA384 for hashing operations. 
But you have also access to SHA256 SHA384 SHA512

~~~
let hashBytes256 = Hash.sha256.perform(on: dataBytes)
let hashBytes384 = Hash.sha384.perform(on: dataBytes)
let hashBytes512 = Hash.sha512.perform(on: dataBytes)
~~~

## Absio Integrated Encryption Scheme
Included in the ECC module is a special Integrated Encryption Scheme. In this scheme ECDH is computed using the recipient user's public derivation key. The resultant key is used to encrypt the data. That data is then signed with the sending user's signing key. By default this will use AES 256 CTR NoPadding along with ECDH and ECDSA both using curve P384.

### Absio IES Encrypt
~~~
let encrypted = try AbsioIESHelper.encrypt(data: data, signingPrivateKey: alicePrivateKey, derivationPublicKey: bobPublicKey, userId: aliceId, objectId: objectId)
~~~

### Absio IES Decrypt
~~~
let decrypted = try AbsioIESHelper.decrypt(data: encrypted, derivationPrivateKey: bobPrivateKey, signingPublicKey: alicePublicKey)
~~~

## Key Derivation Function
The SDK can be used to derive keys using KDF2 as well. By default it will generate keys using a SHA384 Message Digest.
~~~
let kdf2 = KDF2()
let keyBytes = kdf2.deriveKey(seed: testSeedBytes, keySize: keySizeInBytes)
~~~

## Password Based Key Derivation Function
The SDK can be used to derive keys using PBKDF2 as well. By default it will use HMACSHA384, AES256 in CTR mode with no padding and UTF-8 encoding.

### Key Generation
~~~
let pbkdf2 = PBKDF2();
let keyBytes = pbkdf2.generateDerivedKey(password: password, salt: salt, iterationCount: iterationCount, derivedKeyLength: derivedKeyLength)
~~~

### Encrypt

~~~
let helper = PBKDF2Helper()
let formattedCiphertextBytes = try helper.encryptToFormat(data: plaintextBytes, salt: saltBytes, password: "password", iterationCount: 100000)
~~~

### Decrypt

~~~
let helper = PBKDF2Helper()
let plaintextBytes = try helper.decryptFromFormat(formattedData: formattedCiphertextBytes, password: "password", iterationCount: 100000)
~~~

## Asymmetric Features
The SDK can generate key pairs and perform encryption and decryption with Absio IES(Integrated Encryption Scheme). By default this will create Elliptic Curve keys.

### Asymmetric Key Generation
~~~
let p384PrivateKey = try ECKeyGenarator.p384.generatePrivateKey()
let p384PublicKey = try p384PrivateKey.publicKey()
~~~

## Diffie-Hellman Key Exchange
The SDK can compute the shared secret for a Diffie-Hellman key exchange. 
~~~
let sharedSecretBytes = ECDH.exchange(privateKey: privateKey, publicKey: publicKey)
~~~

## HMAC
The SDK will perform HMAC operations to ensure data integrity. By default Absio supports: HMAC-SHA384.

### Key Generation
~~~
let key = try MacHelper.MacAlgorithm.HMACSHA384.generateKey()
~~~

### Digest
By default it will perform HMAC-SHA384.
~~~
let helper = MacHelper()
let digestBytes = try helper.generateDigest(data: dataBytes, key: secretKey)
~~~

### Digest Verify
~~~
let helper = MacHelper()
let verified = try helper.verifyDigest(digest: generatedDigest, data: dataBytes, key: secretKey)
~~~

## Signature
The SDK can perform signing operations: sign and verify. By default Absio supports: ECDSA signing with SHA384.

### Signing
~~~
let ecdsa = ECDSA()
let signatureBytes = try ecdsa.sign(digest: dataBytes, privateKey: privateKey)
~~~

### Signature Verification
~~~
let ecdsa = ECDSA()
let signatureBytes = try ecdsa.verify(digest: dataBytes, signature: signatureBytes, publicKey: publicKey)
~~~

## Elliptic Curve Cryptograpy Operations
The SDK has a helper class (ECCHelper) to perform all the basic ECC operations. This allows you to use a single helper to perform all ECC operations. See below for its usage. By default this will use curve P384 and AES256 for the IES encryption.

### Generate Key
~~~
let helper = ECCHelper()
let ecPrivateKey = try helper.generatePrivateKey()
let ecPublicKey = try ecPrivateKey.publicKey()
~~~

### ECDH Generate Shared Key
~~~
let eccHelper = ECCHelper()
let sharedKey = try eccHelper.generateDHSharedKey(privateKey: privateKey, publicKey: publicKey)
~~~

### ECDH Generate Shared Secret
~~~
let helper = ECCHelper()
let sharedSecretRecreated = try eccHelper.generateDHSharedSecret(privateKey: privateKey, publicKey: publicKey)
~~~

### Absio IES Encrypt
~~~
let eccHelper = ECCHelper()
let iesDataBytes = try eccHelper.absioIESEncrypt(data: data, signingPrivateKey: alicePrivateKey, derivationPublicKey: bobPublicKey, userId: aliceId, objectId: objectId)
~~~

### IES Decrypt
~~~
let eccHelper = ECCHelper()
let plaintextBytes = try eccHelper.absioIESDecrypt(absioIESData: iesDataBytes, signingPublicKey: alicePublicKey, derivationPrivateKey: bobPrivateKey)
~~~

### Sign
~~~
let eccHelper = ECCHelper()
let signatureBytes = try eccHelper.sign(digest: dataBytes, privateKey: privateKey)
~~~

### Verify Signature
~~~
let eccHelper = ECCHelper()
let signatureBytes = try eccHelper.verify(digest: dataBytes, signature: signatureBytes, publicKey: publicKey)
~~~

## License
Please visit out license page at [absio.com](http://docs.absio.com/#licenselicense)

## Getting Help
- Please contact us at support@absio.com if you experience issues,  want to submit feeback, or have general questions about the technology

- Have a bug to report? [Open an issue](https://github.com/Absio/swift-absio-sdk/issues). If possible, include the version of Absio SDK, a full log, and description on how to reproduce.