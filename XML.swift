//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

class XML: NSObject {
    
    var parser: XMLParser?
    
    var completion:([[String: String]]) -> Void
    
    var searchParams:[String]
    var items:[[String: String]] = [];
    var foundCharacters:String? = nil;
    var searchingValue: String? = nil
    
    required init(data: Data, searchParams:[String], completion: @escaping ([[String: String]]) -> Void) {
        self.searchParams = searchParams
        self.completion = completion
        super.init()
        self.parser = XMLParser(data: data)
        self.parser?.delegate = self;
        if !(self.parser?.parse() ?? false) {
            completion([])
            print("Error parsing XML")
        }
    }
}

extension XML: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        if elementName == "userDefinedRuntimeAttribute" {
            if let keyPath = attributeDict["keyPath"], searchParams.contains(keyPath) {
                if let string = attributeDict["value"] {
                    items.append(["keyPath": keyPath,
                                  "value": string])
                } else {
                    searchingValue = keyPath
                }
            }
        } else if searchingValue != nil && elementName == "string" && (attributeDict["key"] == "value") {
            foundCharacters = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let chars = foundCharacters {
            self.foundCharacters = chars + string;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let keyPath = searchingValue, let string = foundCharacters, elementName == "string" {
            items.append(["keyPath": keyPath,
                          "value": string])
            foundCharacters = nil
            searchingValue = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("XML items: \(items)")
        completion(items)
    }
}
