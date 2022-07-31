//
//  GallaryModel.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/22/22.
//

import Foundation

struct GallaryModel: Codable {
    var images = [ImageModel]()
   
     
    
    func getGalleryFromData(json: Data ) -> GallaryModel? {
        if let newValue = try? JSONDecoder().decode(GallaryModel.self,from: json) {
            return newValue
        } else {
            return nil
        }
    }
    
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    
}
