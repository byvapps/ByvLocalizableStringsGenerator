//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

func generateStringsFiles(translations: [String:Translation]) {
    let languages = Language.allLanguages()
    
    let stringsFilePath = path + "/all.strings"
    
    // create new strings file
    _ = shell(
        launchPath: "/usr/bin/env",
        arguments: [
            "touch",
            "\(stringsFilePath)"
        ]
    )
    
    guard let stringsFileHandle = FileHandle(forWritingAtPath: stringsFilePath) else {
        print("no file to write to \(stringsFilePath) was not created or available")
        abort()
    }
    
    for text in translations.keys {
        let newline = "\r\n"
        
        if let translation = translations[text] {
            let rule = "\(newline)/* Files = \(translation.files); comment = \"\(translation.comment)\" */\(newline)\"\(text)\" = \"\(text)\";\(newline)"
            
            stringsFileHandle.write(rule.data(using: .utf8)!)
            
            //Stored Languages
            let emptyRule = "\(newline)/* Files = \(translation.files); comment = \"\(text)\" */\(newline)\"\(text)\" = \"\";\(newline)"
            for language in languages {
                if language.translated[text] == nil {
                    //Translation not stored
                    if language.langId.uppercased() == "BASE" {
                        language.stringsFileHandle?.write(rule.data(using: .utf8)!)
                    } else {
                        language.stringsFileHandle?.write(emptyRule.data(using: .utf8)!)
                    }
                }
            }
        }
    }
    
    
    print("Outputted base.strings file in \(stringsFilePath)")
    stringsFileHandle.closeFile()
    
    for language in languages {
        print("Outputted base.strings file in \(language.newPath)")
        language.stringsFileHandle?.closeFile()
    }
}
