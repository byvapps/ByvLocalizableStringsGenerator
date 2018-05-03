//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

class Language {
    let langId:String
    var translated:[String:String] = [:]
    let newPath:String
    let stringsFileHandle:FileHandle?
    
    init(file: File) {
        var lang = "base"
        for comp in file.path.components(separatedBy: "/") {
            let comps = comp.components(separatedBy: ".lproj")
            if comps[0] != comp {
                lang = comps[0]
                print("Language: \(lang)")
                break
            }
        }
        self.langId = lang
        
        do {
            let text = try String(contentsOfFile: file.path)
            self.translated = text.propertyListFromStringsFileFormat()
        } catch {
            self.translated = [:]
        }
        
        newPath = path + "/\(self.langId).strings"
        
        _ = shell(
            launchPath: "/usr/bin/env",
            arguments: [
                "touch",
                "\(newPath)"
            ])
        
        self.stringsFileHandle = FileHandle(forWritingAtPath: newPath)
    }
    
    static func allLanguages() -> [Language] {
        guard let lacalizables = dir?.findFilesRecursively(byName: "Localizable.strings") else {
            abort()
        }
        var response:[Language] = []
        for file in lacalizables {
            print("Localizable: \(file.path)")
            response.append(Language(file: file))
        }
        return response
    }
}
