//
//  kdf2.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultKdf2FileName: String = "kdf2_result"

let kdf2Command = command(
    Argument<String>("secret", description: inputDescription),
    Option("length", default: 32, description: inputDescription),
    Option("output", default: defaultKdf2FileName, description: outputDescription)
    ) { secret, length, output in
        
    let seed = readDataFromFile(path: secret)
    let kdf2 = KDF2().deriveKey(seed: seed, keySize: length)
    
    writeHexDataToFile(data: kdf2!, path: output, fileName: defaultKdf2FileName)
 }
