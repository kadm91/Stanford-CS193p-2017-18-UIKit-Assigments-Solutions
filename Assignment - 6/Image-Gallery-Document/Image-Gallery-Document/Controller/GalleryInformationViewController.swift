//
//  GalleryInformationViewController.swift
//  Image-Gallery-Document
//
//  Created by Kevin Martinez on 7/21/22.
//

import UIKit

protocol removeBlurViewDelegate {
    func removeBluer()
}

class GalleryInformationViewController: UIViewController {
    
    //MARK: - Properties
    
    var removeBluerDelegate: removeBlurViewDelegate?
    
    
    var galleryDocument: GalleryDocument? {
        didSet {
            updateUI()
        }
    }
    private var sizeText: String?
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    } ()
    
    //MARK: - IBOutlets
    
    @IBOutlet var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var returnToDocumentButton: UIButton!
    @IBOutlet weak var topLevelView: UIStackView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBluerDelegate?.removeBluer()
    }
    
    //MARK: - @IBActions
    
    @IBAction func returnToGallery(_ sender: Any) {
     
            presentingViewController?.dismiss(animated: true)
        
        
    }
    
    
    //MARK: - Methods
    
    private func updateUI(){
        
        
   
        
        if sizeLabel != nil, createdLabel != nil, let url = galleryDocument?.fileURL,  let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            
            
            
            if let size = attributes[.size] as? Double {
                
                
                
                switch size {
                case 0..<1000000 :
                    sizeText =  "\(size) bytes"
                case 1000000... :
                    
                    let sizeInMb = size / Double(1024)
                    let sizeInMbString = String(format: "%.2f", sizeInMb)
                  sizeText =  "\(sizeInMbString) Mb"
                    
                    // it will hard that a gallery that store only small data as StringURL past Mb1000000
                    
                default: break
                }
            }
            sizeLabel.text = sizeText //"\(attributes[.size] ?? 0) bytes"
            
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = shortDateFormatter.string(from: created)
                
            }
        }
        
        if thumbnailImageView != nil, thumbnailAspectRatio != nil ,let thumbnail = galleryDocument?.thumbnail {
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRatio)


            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView as Any,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0
            )
            thumbnailImageView.addConstraint(thumbnailAspectRatio)

        }
        
        
        
        
        
    }


//MARK: - End of GalleryInformationViewController
    
}
