//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

var translations:[String: Translation] = [:]

struct Translation {
    let comment: String
    var files: [String]
}
