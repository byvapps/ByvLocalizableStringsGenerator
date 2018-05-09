//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 2/5/17.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

func stringsFromSwiftFiles() {

    //guard let files = dir?.findFilesRecursively(byName: "example.swift") else {
    guard let files = dir?.findFilesRecursively(byExtension: "swift") else {
        abort()
    }

    for file in files {
        // get AST output from sourcekitten library
        let output = shell(
            launchPath: "/usr/bin/env",
            arguments: [
                "sourcekitten",
                "structure",
                "--file",
                "\(file.path)"
            ]
        )
        
        let data = output.data(using: .utf8)
        
        var contents: String? = nil
        
        do {
            let json = try JSONSerialization.jsonObject(
                with: data!,
                options: JSONSerialization.ReadingOptions.allowFragments
            )
            
            _ = Recursive(json: json) {
                value, path in
                
                guard let name = value["key.name"] as? String else {
                    return
                }
                
                //check .localize()
                if name.contains("\".localize") {
                    // this part gets the actual string that needs translating
                    var parts = name.components(separatedBy: "\".localize")
                    for i in 0...parts.count - 2 {
                        let part = parts[i]
                        if let str = part.components(separatedBy: "\"").last {
                            let string = str
                            let comment = ""
                            
                            if string.count > 0 {
                                var translation = Translation(comment: comment, files: [file.name])
                                if let storedTranslation = translations[string] {
                                    var files = storedTranslation.files
                                    files.append(file.name)
                                    translation.files = files
                                }
                                translations[string] = translation
                            }
                        }
                    }
                } else if name.contains(".locText") ||
                    name.contains(".locTitle") ||
                    name.contains(".locPlaceholder") ||
                    name.contains(".styledLocText") ||
                    name.contains(".styledLocTitle") ||
                    name.contains(".styledLocPlaceholder") ||
                    name.contains("NSLocalizedString") {
                    var string = ""
                    var stringOffset = -1
                    var stringLength = -1
                    var commentOffset = -1
                    var commentLength = -1
                    var comment = ""
                    if let subArray = value["key.substructure"] as? [[String: Any]] {
                        for sub in subArray {
                            guard let offset = sub["key.bodyoffset"] as? NSNumber else {return}
                            guard let length = sub["key.bodylength"] as? NSNumber else {return}
                            
                            if let name = sub["key.name"] as? String {
                                if name == "comment" {
                                    commentOffset = offset.intValue
                                    commentLength = length.intValue
                                } else if name == "format" {
                                    stringOffset = offset.intValue
                                    stringLength = length.intValue
                                }
                            } else {
                                // Can only be string
                                stringOffset = offset.intValue
                                stringLength = length.intValue
                            }
                        }
                    } else {
                        // Only text -> string => .locText("")
                        if let offset = value["key.bodyoffset"] as? NSNumber ,
                            let length = value["key.bodylength"] as? NSNumber {
                            stringOffset = offset.intValue
                            stringLength = length.intValue
                        }
                    }
                    
                    if contents == nil {
                        contents = file.contents()
                    }
                    guard let contents = contents else {return}
                    
                    // string
                    if stringOffset > 0 && stringLength > 0 {
                        
                        let quotedString = contents.substring(
                            with: (stringOffset)
                                ..< (stringOffset + stringLength)
                        )
                        string = quotedString.trimmingCharacters(in: CharacterSet(["\""]))
                        if quotedString == string {
                            // No quoted string, so it should be a variable
                            string = ""
                        }
                    }
                    
                    // comment
                    if commentOffset > 0 && commentLength > 0 {
                        
                        comment = contents.substring(
                            with: (commentOffset)
                                ..< (commentOffset + commentLength)
                        )
                        comment = comment.trimmingCharacters(in: CharacterSet(["\""]))
                    }
                    if string.count > 0 {
                        var translation = Translation(comment: comment, files: [file.name])
                        if let storedTranslation = translations[string] {
                            var files = storedTranslation.files
                            files.append(file.name)
                            translation.files = files
                        }
                        translations[string] = translation
                    }
                }
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    return
}
