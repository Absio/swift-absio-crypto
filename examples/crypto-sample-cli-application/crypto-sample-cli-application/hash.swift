//
//  hash.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation
import Commander
import AbsioCryptoMacOS

let defaultHashFileName: String = "hash_result"

let hashCommand = command(
    Argument<String>("input", description: inputDescription),
    Option("output", default: defaultHashFileName, description: outputDescription)
) { input, output in
    do {
        let data = readDataFromFile(path: input)
        let hash = try Hash.sha384.perform(on: data)
        writeHexDataToFile(data: Data(bytes: hash), path: output, fileName: defaultHashFileName)
    } catch {
        exitWithError(errorMessage: error.localizedDescription)
    }
}

