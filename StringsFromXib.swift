//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 2/5/17.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

func stringsFromXibFiles() {

    var files = dir?.findFilesRecursively(byExtension: "xib") ?? []
    files += dir?.findFilesRecursively(byExtension: "storyboard") ?? []
    
    let dispatchGroup = DispatchGroup()

    for file in files {
        dispatchGroup.enter()
        if let data = file.contents().data(using: .utf8) {
            let _ = XML(data: data) { (items) in
                for item in items {
                    if let keyPath = item["keyPath"],
                        let string = item["value"] {
                        if keyPath == "locText" ||
                            keyPath == "locTitle" ||
                            keyPath == "locPlaceholder" {
                            var translation = Translation(comment: "", files: [file.name])
                            if let storedTranslation = translations[string] {
                                var storedFiles = storedTranslation.files
                                storedFiles.append(file.name)
                                translation.files = storedFiles
                            }
                            translations[string] = translation
                        } else if keyPath == "locTitles" {
                            //Segmented
                            let comps = string.components(separatedBy: ";")
                            for i in 0...comps.count - 1 {
                                let text = comps[i]
                                let comment = "Segmented[\(i)]"
                                var translation = Translation(comment: comment, files: [file.name])
                                if let storedTranslation = translations[string] {
                                    var storedFiles = storedTranslation.files
                                    storedFiles.append(file.name)
                                    translation.files = storedFiles
                                }
                                translations[text] = translation
                            }
                        }
                    }
                }
                dispatchGroup.leave()
            }
        } else {
            print("File: \(file.path) - no data")
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.wait()
    return
}
