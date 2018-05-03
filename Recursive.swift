//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

/**
 * Recursively walk over all leafs of the
 * provided JSON object.
 */
class Recursive {
    
    typealias JsonObject = Dictionary<String, Any>
    
    typealias JsonArray = Array<AnyObject>
    
    typealias LeafCallback = (_ key: Any, _ value: Any, _ path: Recursive.Path) -> Swift.Void
    typealias JsonCallback = (_ value: JsonObject, _ path: Recursive.Path) -> Swift.Void
    
    /**
     * Keeps track of JsonObjects found along the way.
     */
    class Path {
        
        class Step {
            
            var key: Any
            
            var value: JsonObject
            
            init(key: Any, value: JsonObject) {
                self.key = key
                self.value = value
            }
            
        }
        
        var steps: [Step] = []
        
        func append(key: Any, value: JsonObject) {
            steps.append(Step(key: key, value: value))
        }
        
        func last(count: Int = 0) -> JsonObject? {
            if count == 0 {
                if let last: Step = steps.last {
                    return last.value
                }
            }
            
            let index = (steps.count - 1) - count
            
            if index >= 0 {
                return steps[index].value
            }
            
            return nil
        }
        
        init() {}
        
    }
    
    var path = Path()
    
    var callback: LeafCallback?
    var jsonCallback: JsonCallback?
    
    func select(key: Any, value: Any) {
        if let object = value as? JsonObject {
            path.append(key: key, value: object)
            enumerate(object: object)
            jsonCallback?(object, path)
        }
        else if let array = value as? JsonArray {
            enumerate(array: array)
        }
        else if let string = value as? String {
            callback?(key, string, path)
        }
        else if let number = value as? NSNumber {
            callback?(key, number, path)
        }
    }
    
    func enumerate(array:JsonArray) {
        for (key, value) in array.enumerated() {
            select(key: key, value: value)
        }
    }
    
    func enumerate(object:JsonObject) {
        for (key, value) in object {
            select(key: key, value: value)
        }
    }
    
    init(json: Any, leaf: @escaping LeafCallback) {
        callback = leaf
        select(key: "", value: json)
    }
    
    init(json: Any, jsonLeaf: @escaping JsonCallback) {
        jsonCallback = jsonLeaf
        select(key: "", value: json)
    }
    
}
