//
//  ImagePreviewViewController.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/27/22.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var previewConteinerView: UIView!
    
    @IBOutlet weak private var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.02
            scrollView.maximumZoomScale = 50.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    //@IBOutlet weak private var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    //MARK: - properties
    
     var imageView = UIImageView()
    
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            imageView.image
            
        }
        set {
            
            scrollView?.zoomScale = 3
            imageView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            if let conteinerView = self.previewConteinerView, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(conteinerView.bounds.size.width /  size.width, conteinerView.bounds.size.height /  size.height)
            }
           
            
            
            //spinner?.stopAnimating()
            
        }
    }

    //MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL != nil {
            fetchImage()
        } else {
            print("URL wasn't passed from segue")
        }
        
    }
    
    //MARK: - Methods
    
 
    private func fetchImage(){
        
        if let url = imageURL {
           // spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                }
                
                }
            }
        }
    }
}

//MARK: - ImagePreviewViewController UIScrollViewDelegate Extension

extension ImagePreviewViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
