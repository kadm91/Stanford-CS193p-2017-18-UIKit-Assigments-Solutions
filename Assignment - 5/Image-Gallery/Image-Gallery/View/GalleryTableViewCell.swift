//
//  GalleryTableViewCell.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 7/1/22.
//

import UIKit

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
//MARK: - IBOutles
    
    @IBOutlet weak var titleTextField: UITextField!{didSet { titleTextField.delegate = self}}
    
    //MARK: - Properties
    
    var resignationHandler: (()-> Void)?
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    

}
