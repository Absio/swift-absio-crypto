//
//  pbkdf2.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultPbkdf2FileName: String = "pbkdf2_result"

let pbkdf2Command = command(
    Argument<String>("password", description: inputDescription),
    Option("salt", default: "", description: inputDescription),
    Option("output", default: defaultPbkdf2FileName, description: outputDescription)
) { password, salt, output in
    
    let passwordData = readDataFromFile(path: password)
    var saltData = Data()
    
    if !salt.isEmpty {
        saltData = readHexDataFromFile(path: salt)
    }
    let pbkdf2 = PBKDF2().generateDerivedKey(password: passwordData, salt: saltData, iterationCount: 100)
    
    writeHexDataToFile(data: pbkdf2!, path: output, fileName: defaultPbkdf2FileName)
}
