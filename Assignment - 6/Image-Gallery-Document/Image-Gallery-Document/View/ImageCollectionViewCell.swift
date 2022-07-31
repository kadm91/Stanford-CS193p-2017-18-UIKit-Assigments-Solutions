//
//  ImageCollectionViewCell.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var imageURL: URL?
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var spinnerIndicator: UIActivityIndicatorView!
    
    //MARK: - Methods
    
    func fetchImage(){
        
        if let url = imageURL?.imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let urlContents = try? Data(contentsOf: url), let image = UIImage(data: urlContents) {
                    DispatchQueue.main.async {
                        if url == self?.imageURL{
                            self?.image.image = image
                            self?.spinnerIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
        
    }
    
    //MARK: - End of ImageCollectionviewCell
}












