//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

translations = [:]

print("Searching in swift files...")
stringsFromSwiftFiles()

print("Searching in Xib files...")
stringsFromXibFiles()

print("Generating strings files...")
generateStringsFiles(translations: translations)

