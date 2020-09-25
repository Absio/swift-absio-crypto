//
//  aes.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import AbsioCryptoMacOS
import Commander

let defaultAesKeyFileName: String = "aes_key"
let defaultIvFileName: String = "iv"
let defaultEncryptedFileName: String = "encrypted"
let defaultDecryptedFileName: String = "decrypted"

let aesGroup = Group {
    $0.command(
        "create_key",
         Option("output", default: defaultAesKeyFileName,description: outputDescription)
    ) { output in
        
        let aesKey = Cipher(using: .aes_256_ctr).generateKey()
        writeHexDataToFile(data: aesKey, path: output, fileName: defaultAesKeyFileName)
    }
    
    $0.command(
        "create_iv",
         Option("output", default: defaultIvFileName, description: outputDescription)
    ) { output in
        let iv = Cipher(using: .aes_256_ctr).generateIv()
        writeHexDataToFile(data: iv, path: output, fileName: defaultIvFileName)
    }
    
    $0.command(
        "encrypt",
        Argument<String>("key", description: inputDescription),
        Argument<String>("iv", description: inputDescription),
        Argument<String>("input", description: inputDescription),
        Option("output", default: defaultEncryptedFileName, description: inputDescription)
    ) { key, iv, input, output in
        
        do {
            let aesKey = readHexDataFromFile(path: key)
            let ivData = readHexDataFromFile(path: iv)
            let inputData = readDataFromFile(path: input)
            
            let cipher = Cipher(using: .aes_256_ctr)
            let encrypted = try cipher.encrypt(key: aesKey, iv: ivData, data: inputData)
        
            writeHexDataToFile(data: encrypted, path: output, fileName: defaultEncryptedFileName)
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
    
    $0.command(
        "decrypt",
        Argument<String>("key", description: inputDescription),
        Argument<String>("iv", description: inputDescription),
        Argument<String>("input", description: inputDescription),
        Option("output", default: defaultDecryptedFileName, description: inputDescription)
    ) { key, iv, input, output in
        let aesKey = readHexDataFromFile(path: key)
        let ivData = readHexDataFromFile(path: iv)
        let inputData = readHexDataFromFile(path: input)
        
        let cipher = Cipher(using: .aes_256_ctr)
        let decrypted = try cipher.decrypt(key: aesKey, iv: ivData, data: inputData)
        writeStringToFile(data: decrypted, path: output, fileName: defaultDecryptedFileName)
    }
}
