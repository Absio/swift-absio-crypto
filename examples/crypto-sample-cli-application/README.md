# Absio Crypto CLI Example V1.0.0

## CLI utility for showing capability of absio crypto SDK

Doc on how to run cli tool.

Requirements for build: 
Letest macOS 10.15
Installed xCode 11.6+

1. intall pods 
2. open crypto-sample-cli-application.xcworkspace
3. Build solution
4. Navigate to build artifacts folder with terminal
5. Run app with terminal

### Usage

Each command supports --help option.

```
./crypto-sample-cli-application --help

Usage:

    $ ./crypto-sample-cli-application

Commands:

    + aes - Symmetric Cryptography.
    + hash - Performs a SHA384 hash.
    + p384 - Creates an elliptic curve (P384) key pair.
    + ecdsa - Elliptic Curve Signature Algorithm
    + aies - Absio Integrated Encryption Scheme
    + ecdhe - Elliptic curve key exchange.
    + kdf2 - Key Derivation Function.
    + pbkdf2 - Password based key derivation function.
    + hmac - HMAC
```
NOTE: each command have optional --output parameter. You can specify path where to store result of operation. Or if parameter is missing result will be stored in same directory with default name for operation result.

```
./crypto-sample-cli-application aes create_key --help
Usage:

    $ ./crypto-sample-cli-application aes create_key

Options:
    --output [default: aes_key] - File path where will be stored data
```
In case with not passing --output into *aes create_key* result file name will be *aes_key.txt*


### Examples
NOTE: input.txt - is user created file with test data.

```
./crypto-sample-cli-application hmac create_key
```
This will create new hmac key and save it in default file (hmac_key.txt)

```
./crypto-sample-cli-application aes create_key
```
This will create new aes key and save it in default file (aes_key.txt)


Sequence example

1. Create key
2. Create digest
3. Verify digest and data 

```
./crypto-sample-cli-application hmac create_key
./crypto-sample-cli-application hmac digest ./hmac_key.txt ./input.txt
./crypto-sample-cli-application hmac verify ./hmac_key.txt ./input.txt ./hmac_digest.txt 
Authentication is valid
```

Absio IES example 

1. Create key pair
2. Encrypt data using Absio IES and store result into default file(aies_encrypted.txt)
3. Decrypt data data using Absio IES and store result into default file(aies_decrypted.txt)

```
./crypto-sample-cli-application p384
./crypto-sample-cli-application aies encrypt ./input.txt ./private_key.txt ./public_key.txt 
./crypto-sample-cli-application aies decrypt ./aies_encrypted.txt ./public_key.txt ./private_key.txt 
```