//
//  p384.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultPublicKeyFileName = "public_key"
let defaultPrivateKeyFileName = "private_key"

let p384Command = command(
    Option("public_key", default: defaultPublicKeyFileName, description: outputDescription),
    Option("private_key", default: defaultPrivateKeyFileName, description: outputDescription)
) { public_key, private_key in
    do {
        let privateKey = try ECKeyGenarator.p384.generatePrivateKey()
        let publicKey = try privateKey.publicKey()
        
        writeStringToFile(data: publicKey.toPemFormat() , path: public_key, fileName: defaultPublicKeyFileName)
        
        writeStringToFile(data: privateKey.toPemFormat(), path: private_key, fileName: defaultPrivateKeyFileName)
        
    } catch {
        exitWithError(errorMessage: error.localizedDescription)
    }
}
