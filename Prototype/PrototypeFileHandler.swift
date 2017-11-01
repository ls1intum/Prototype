//
//  PrototypeFileHandler.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

class PrototypeFileHandler {
    
    struct Constants {
        static let jsonFileName = "content.json"
        static let imagesDirectoryName = "images"
    }
    
    static func prototype(fromPath path: String) -> Prototype? {
        do {
            let fileWrapper = try FileWrapper.init(url: URL(fileURLWithPath: path), options: .immediate)
            return prototype(fromFileWrapper: fileWrapper)
        } catch _ {
            print("File from path \"\(path)\" could not be loaded")
            return nil
        }
    }
    
    static func prototype(forName fileName: String, inBundle bundle: Bundle = Bundle.main) -> Prototype? {
        guard let path = bundle.path(forResource: fileName, ofType: ".prototype") else {
            print("File named \"\(fileName)\" could not be found in bundle. Check if you added the file to the target.")
            return nil
        }
        return prototype(fromPath: path)
    }
    
    static func prototype(fromFileWrapper fileWrapper: FileWrapper) -> Prototype? {
        do {
            guard  let fileWrappers = fileWrapper.fileWrappers,
                let jsonFileWrapper = fileWrappers[Constants.jsonFileName],
                let imageFileWrappers = fileWrappers[Constants.imagesDirectoryName]?.fileWrappers,
                let jsonData = jsonFileWrapper.regularFileContents else {
                print("Corrupt file, could not find nescessary FileWrappers")
                return nil
            }
            
            let prototype = try JSONDecoder().decode(Prototype.self, from: jsonData)
            
            for page in prototype.pages {
                guard let imageData = imageFileWrappers[page.imageName]?.regularFileContents, let image = Image(data: imageData) else {
                    print("Image not found or could not be found or converted")
                    return nil
                }
                page.image = image
            }
            
            return prototype
        } catch _ {
            print("Prototype could not be decoded")
            return nil
        }
    }
    
    static func createFileWrapper(fromPrototype prototype: Prototype) -> FileWrapper? {
        
        let prototypeFileWrapper = FileWrapper(directoryWithFileWrappers:[:])
        prototypeFileWrapper.preferredFilename = "\(prototype.name).prototype"
        
        do {
            let data = try JSONEncoder().encode(prototype)
            let jsonFileWrapper = FileWrapper(regularFileWithContents: data)
            jsonFileWrapper.preferredFilename = Constants.jsonFileName
            prototypeFileWrapper.addFileWrapper(jsonFileWrapper)
        } catch _ {
            print("Prototype could not be encoded")
            return nil
        }
        
        let imageFolderFileWrapper = FileWrapper(directoryWithFileWrappers:[:])
        imageFolderFileWrapper.preferredFilename = Constants.imagesDirectoryName
        prototypeFileWrapper.addFileWrapper(imageFolderFileWrapper)
        
        for page in prototype.pages where imageFolderFileWrapper.fileWrappers?.filter({$0.0 == page.imageName}).keys.first == nil {
            #if os(OSX)
                guard let image = page.image, let imageData = image.tiffRepresentation, let imageRep = NSBitmapImageRep(data: imageData), let imageJPGData = imageRep.representation(using: .jpeg, properties: [:]) else {
                    print("Image not found or could not be converted")
                    return nil
                }
            #elseif os(iOS) || os(tvOS)
                guard let image = page.image, let imageJPGData = UIImageJPEGRepresentation(image,1.0) else {
                    print("Image not found or could not be converted")
                    return nil
                }
            #endif
            
            let imageFileWrapper = FileWrapper(regularFileWithContents: imageJPGData)
            imageFileWrapper.preferredFilename = page.imageName
            imageFolderFileWrapper.addFileWrapper(imageFileWrapper)
        }
        
        return prototypeFileWrapper
    }
}

extension PrototypeFileHandler {
    static func prototypeInInterfaceBuilder(withName prototypeName: String) -> Prototype? {
        let directories = ProcessInfo.processInfo.environment["IB_PROJECT_SOURCE_DIRECTORIES"]!.components(separatedBy: ":")
        if var firstPath = directories.first {
            firstPath = NSString(string: firstPath).deletingLastPathComponent
            
            let enumerator = FileManager.default.enumerator(atPath: firstPath)
            while let element = enumerator?.nextObject() as? NSString {
                if element.hasSuffix("prototype") && NSString(string: element.lastPathComponent).deletingPathExtension == prototypeName {
                    let prototypePath = firstPath.appending("/"+(element as String))
                    return PrototypeFileHandler.prototype(fromPath: prototypePath)
                }
            }
        }
        return nil
    }
}
