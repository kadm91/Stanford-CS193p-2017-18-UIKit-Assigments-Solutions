//
//  PersistGalleryModel.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 7/9/22.
//

import Foundation

typealias galleriesDataPersistance = PersistGalleryModel

struct PersistGalleryModel {
    
    let dataFilePaht = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("gallery.plist")
    private  let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    func saveData(_ save: [GallaryModel]) {
        
        
        do {
            let dataToEncode = try encoder.encode(save)
            try dataToEncode.write(to: dataFilePaht! )
        } catch {
            print("Error trying to encode and save gallery")
        }
    }
    
    
    func loadItems() -> [GallaryModel] {
        
        var galleries = [GallaryModel]()
        
        if let data = try? Data(contentsOf: dataFilePaht!){
            
            
            do{
                
                galleries = try decoder.decode([GallaryModel].self, from: data)
                
            } catch {
                print("Error decoding galleries array, \(error)")
            }
        }
        return galleries
    }
    
    
}
