//
//  ByvLocalizableStringsGenerator.swift
//  ByvLocalizableStringsGenerator
//
//  Created by Adrian Apodaca on 3/5/18.
//  Copyright © 2017 byvapps. All rights reserved.
//

import Foundation

let path = FileManager.default.currentDirectoryPath
let dir = Directory(path: path + "/..")

extension FileHandle {
    
    public func read (encoding: String.Encoding = String.Encoding.utf8) -> String {
        let data: Data = self.readDataToEndOfFile()
        
        guard let result = String(data: data, encoding: encoding) else {
            fatalError("Could not convert binary data to text.")
        }
        
        return result
    }
    
}


/**
 * Filesystem node (either a file or directory)
 * Is used as a base class for the file and directory classes
 */
class DiskNode {
    
    let manager: FileManager = FileManager.default
    
    let path: String
    
    init?(path: String) {
        self.path = path
        
        if type(of: self) == DiskNode.Type.self {
            return nil
        }
        if !exists() {
            return nil
        }
    }
    
    func exists() -> Bool {
        var isDir : ObjCBool = false
        
        let result: Bool
        
        if manager.fileExists(atPath: path, isDirectory: &isDir) {
            if type(of: self) == Directory.Type.self {
                if isDir.boolValue {
                    result = true
                }
                else {
                    result = false
                }
            }
            else {
                result = true
            }
        }
        else {
            result = false
        }
        
        return result
    }
    
}

/**
 * Local filesystem file
 */
class File: DiskNode {
    
    let handle: FileHandle
    
    let name: String
    
    let ext: String
    
    override init?(path: String) {
        guard let handle = FileHandle(forReadingAtPath: path) else {
            return nil
        }
        
        let uri = URL(fileURLWithPath: path)
        
        self.handle = handle
        self.ext = URL(fileURLWithPath: path).pathExtension
        self.name = uri.pathComponents.last ?? ""
        
        super.init(path: path)
    }
    
    func contents() -> String {
        return handle.read()
    }
    
}

/**
 * Local filesystem directory
 */
class Directory: DiskNode {
    
    func findFilesRecursively(byExtension: String) -> [File]? {
        guard let enumerator = manager.enumerator(atPath: path) else {
            return nil
        }
        
        var result: [File] = []
        
        enumerator.forEach({ (path) in
            guard let path = path as? String else {
                return
            }
            
            let ext = URL(fileURLWithPath: path).pathExtension
            
            guard ext == byExtension else {
                return
            }
            guard let file = File(path: self.path + "/" + path) else {
                return
            }
            
            result.append(file)
        })
        
        return result
    }
    
    func findFilesRecursively(byName: String) -> [File]? {
        guard let enumerator = manager.enumerator(atPath: path) else {
            return nil
        }
        
        var result: [File] = []
        
        enumerator.forEach({ (path) in
            guard let path = path as? String else {
                return
            }
            
            let filename = URL(fileURLWithPath: path).lastPathComponent
            
            guard filename == byName else {
                return
            }
            guard let file = File(path: self.path + "/" + path) else {
                return
            }
            
            result.append(file)
        })
        
        return result
    }
    
}
