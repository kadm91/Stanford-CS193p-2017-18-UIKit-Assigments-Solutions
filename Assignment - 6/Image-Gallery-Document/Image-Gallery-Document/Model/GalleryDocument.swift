//
//  Document.swift
//  Image-Gallery-Document
//
//  Created by Kevin Martinez on 7/12/22.
//

import UIKit

class GalleryDocument: UIDocument {
    
    var gallery: GallaryModel?
    var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
//        return Data()
        
        if let galleryData = gallery?.json {
            return galleryData
           
        } else {
            return Data()
          
        }
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            let newValue = try? JSONDecoder().decode(GallaryModel.self, from: json)
            gallery = newValue
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
  
        
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        return attributes
    }
    
    
}

