//
//  ecdsa.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultSignatureFileName = "signarute"
let privateKeyDescription  = "File path where the private pem key is stored"
let publicKeyDescription  = "File path where the public pem key is stored"
let signatureDescription  = "File path where the signature is stored"

let ecdsaGroup = Group {
    $0.command(
        "sign",
        Argument<String>("private_key", description: privateKeyDescription),
        Argument<String>("input", description: inputDescription),
        Option("output", default: defaultSignatureFileName, description: outputDescription)
    ) { private_key, input, output in
        do {
            let privateKey = try PEM.getPrivateKey(source: readStringFromFile(path: private_key))
            let data = readDataFromFile(path: input)
            
            let signature = try ECDSA().sign(digest: data, privateKey: privateKey)
            writeHexDataToFile(data: signature, path: output, fileName: defaultSignatureFileName)
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
    $0.command(
        "verify",
        Argument<String>("public_key", description: publicKeyDescription),
        Argument<String>("data", description: inputDescription),
        Argument<String>("signature", description: signatureDescription)
    ) { public_key, data, signature in
         do {
            let publicKey = try PEM.getPublicKey(source: readStringFromFile(path: public_key))
            let dataFromFile = readDataFromFile(path: data)
            let signatureData = readHexDataFromFile(path: signature)
            
            let verificationFlag = try ECDSA().verify(digest: dataFromFile, signature: signatureData, publicKey: publicKey)
            
            print("Signature is " + (verificationFlag ? "valid": "invalid"))
            
         } catch {
            exitWithError(errorMessage: error.localizedDescription)
         }
    }
}
