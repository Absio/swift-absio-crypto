//
//  exit.swift
//  crypto-sample-cli-application
//
//  Copyright © 2020 Absio. All rights reserved.
//

import Foundation

func exitWithError (errorMessage: String) {
    print(errorMessage)
    exit(EXIT_FAILURE)
}
