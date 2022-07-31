//
//  ImageModel.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/20/22.
//

import Foundation
import UIKit

struct ImageModel: Hashable, Codable {
    
    func hash(into hasher: inout Hasher) {
        imageURL?.hash(into: &hasher)
    }
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.imageURL == rhs.imageURL
    }
    
    var imageURL: URL?
    var imageHight: CGFloat?
    
}
