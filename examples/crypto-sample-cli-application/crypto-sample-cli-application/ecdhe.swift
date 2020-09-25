//
//  ecdhe.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultEcdheFileName: String = "ecdhe_secret"

let ecdheCommand = command(
    Argument<String>("private_key", description: inputDescription),
    Argument<String>("public_key", description: inputDescription),
    Option("output", default: defaultEcdheFileName, description: outputDescription)
) { private_key, public_key, output in
    do {
        let privateKey = try PEM.getPrivateKey(source: readStringFromFile(path: private_key))
        let publicKey = try PEM.getPublicKey(source: readStringFromFile(path: public_key))
        
        let secret = ECDH.exchange(privateKey: privateKey, publicKey: publicKey)
        writeHexDataToFile(data: secret, path: output, fileName: defaultEcdheFileName)
        
    } catch {
        exitWithError(errorMessage: error.localizedDescription)
    }
}
