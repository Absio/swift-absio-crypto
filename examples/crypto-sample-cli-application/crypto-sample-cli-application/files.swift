//
//  files.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation

let outputDescription = "File path where will be stored data"
let inputDescription = "File path where the data is stored"
let defaultFileExtention = "txt"

func writeHexDataToFile(data: Data, path: String, fileName: String) {
    let hexData = data.toHexString()
    writeStringToFile(string: hexData, path: path, fileName: fileName)
}
func writeStringToFile(data: Data, path: String, fileName: String) {
    let utfString = String(data: data, encoding: .utf8)!
    writeStringToFile(string: utfString, path: path, fileName: fileName)
}

func writeStringToFile(string: String, path: String, fileName: String) {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false
    fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
    
    do {
        if (isDirectory.boolValue) {
            var complitedPath = URL(fileURLWithPath: path)
            complitedPath.appendPathComponent(fileName)
            complitedPath.appendingPathExtension(defaultFileExtention)
            try string.write(to: complitedPath, atomically: false, encoding: .utf8)
        }
        else {
            let complitedPath = URL(fileURLWithPath: path)
            
            if (complitedPath.pathExtension.isEmpty) {
                let workingDir = fileManager.currentDirectoryPath
                var filePath = URL(fileURLWithPath: workingDir)
                filePath.appendPathComponent(path)
                filePath.appendPathExtension(defaultFileExtention)
                try string.write(to: filePath, atomically: false, encoding: .utf8)
            }
            else {
                try string.write(to: complitedPath, atomically: false, encoding: .utf8)
            }
        }
    } catch {
        exitWithError(errorMessage: error.localizedDescription)
    }
}

func readStringFromFile(path: String) -> String {
    let fileManager = FileManager.default
    
    if (fileManager.fileExists(atPath: path)) {
        do {
            
            let fileUrl = URL(fileURLWithPath: path)
            let string = try String(contentsOf: fileUrl, encoding: .utf8)
            return string
            
        } catch {
            exitWithError(errorMessage: error.localizedDescription)
        }
    }
    
    exitWithError(errorMessage: "File does not exist : " + path)
    return String() // this shouldn't call ever
}

func readDataFromFile(path: String) -> Data {
    let str = readStringFromFile(path: path)
    return str.toData()
}

func readHexDataFromFile(path: String) -> Data {
    let str = readStringFromFile(path: path)
    return Data().fromHexString(hex: str)
}
