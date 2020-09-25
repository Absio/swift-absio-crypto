//
//  main.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let mainGroup = Group()

mainGroup.addCommand("aes", "Symmetric Cryptography.", aesGroup)
mainGroup.addCommand("hash", "Performs a SHA384 hash.", hashCommand)
mainGroup.addCommand("p384", "Creates an elliptic curve (P384) key pair.", p384Command)
mainGroup.addCommand("ecdsa", "Elliptic Curve Signature Algorithm", ecdsaGroup)
mainGroup.addCommand("aies", "Absio Integrated Encryption Scheme", aiesGroup)
mainGroup.addCommand("ecdhe", "Elliptic curve key exchange.", ecdheCommand)
mainGroup.addCommand("kdf2", "Key Derivation Function.", kdf2Command)
mainGroup.addCommand("pbkdf2", "Password based key derivation function.", pbkdf2Command)
mainGroup.addCommand("hmac", "HMAC", hmacGroup)

mainGroup.run()
