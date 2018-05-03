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
    
    var items:[[String: String]] = [];
    var foundCharacters = "";
    
    required init(data: Data, completion: @escaping ([[String: String]]) -> Void) {
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
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "userDefinedRuntimeAttribute" {
            items.append(attributeDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion(items)
    }
}
