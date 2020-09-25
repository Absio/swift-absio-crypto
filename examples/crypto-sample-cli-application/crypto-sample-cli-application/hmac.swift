//
//  hmac.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultHmacKeyFileName = "hmac_key"
let defaultHmacDigestFileName = "hmac_digest"

let hmacGroup =  Group {
    $0.command (
        "create_key",
        Option("output", default: defaultHmacKeyFileName, description: outputDescription)
    ) { output in
        
        do {
            let key = try MacHelper.MacAlgorithm.HMACSHA384.generateKey()
            writeHexDataToFile(data: key, path: output, fileName: defaultHmacKeyFileName)
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
    
    $0.command (
        "digest",
        Argument<String>("key", description: inputDescription),
        Argument<String>("data", description: inputDescription),
        Option("output", default: defaultHmacDigestFileName, description: outputDescription)
    ) { key, data, output in
        
        let keyData = readDataFromFile(path: key)
        let dataFromFile = readDataFromFile(path: data)
        let digest = MacHelper(using: .HMACSHA384).generateDigest(data: dataFromFile, key: keyData)
        
        writeHexDataToFile(data: digest, path: output, fileName: defaultHmacDigestFileName)
        
    }
    
    $0.command (
        "verify",
        Argument<String>("key", description: inputDescription),
        Argument<String>("data", description: inputDescription),
        Argument<String>("digest", description: inputDescription)
    ) { key, data, digest in

        let keyData = readDataFromFile(path: key)
        let dataFromFile = readDataFromFile(path: data)
        let digestFromFile = readHexDataFromFile(path: digest)
        
        let verificationFlag = MacHelper(using: .HMACSHA384).verifyDigest(digest: digestFromFile, data: dataFromFile, key: keyData)
        
        print("Authentication is " + (verificationFlag ? "valid": "invalid"))
    }
}
