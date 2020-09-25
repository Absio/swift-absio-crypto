//
//  aies.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultAiesEncrypteFileName = "aies_encrypted"
let defaultAiesDecryptedFileName = "aies_decrypted"

let aiesGroup = Group {
    
    $0.command (
    "encrypt",
    Argument<String>("plain_text", description: inputDescription),
    Argument<String>("sender_private_key", description: privateKeyDescription),
    Argument<String>("recip_public_key", description: publicKeyDescription),
    Option("output", default: defaultAiesEncrypteFileName, description: outputDescription)
    ) { plain_text, sender_private_key, recip_public_key, output in
        do {
            let data = readDataFromFile(path: plain_text)
            let senderPrivateKey =  try PEM.getPrivateKey(source: readStringFromFile(path: sender_private_key))
            
            let recipPublicKey = try PEM.getPublicKey(source: readStringFromFile(path: recip_public_key))
            
            let senderId = UUID.init()
            let objectId = UUID.init()
            
            let encrypted = try AbsioIESHelper.encrypt(data: data, signingPrivateKey: IndexedECPrivateKey(index: 1, ecKey: senderPrivateKey), derivationPublicKey: IndexedECPublicKey(index: 1, ecKey:recipPublicKey), userId: senderId, objectId: objectId)
            
            writeHexDataToFile(data:encrypted, path: output, fileName: defaultAiesEncrypteFileName)
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
    
    $0.command(
    "decrypt",
    Argument<String>("cipher_text", description: inputDescription),
    Argument<String>("sender_public_key", description: publicKeyDescription),
    Argument<String>("recip_private_key", description: privateKeyDescription),
    Option("output", default: defaultAiesDecryptedFileName, description: outputDescription)
    ) { cipher_text, sender_public_key, recip_private_key, output in
        do {
            let encrypted = readHexDataFromFile(path: cipher_text)
            
            let reciPrivateKey =  try PEM.getPrivateKey(source: readStringFromFile(path: recip_private_key))
            
            let senderPublicKey = try PEM.getPublicKey(source: readStringFromFile(path: sender_public_key))
            
            let decrypted = try AbsioIESHelper.decrypt(data: encrypted, derivationPrivateKey: reciPrivateKey, signingPublicKey: senderPublicKey)
            
            writeStringToFile(data: decrypted, path: output, fileName: defaultAiesDecryptedFileName)
        
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
}
