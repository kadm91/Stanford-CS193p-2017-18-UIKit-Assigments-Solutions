//
//  ImageGallaryCollectionViewController.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/14/22.
//


//TODO: study difference between URL and NSURL and try to change URL for NSURL if need in this code, create model for the imageURL dataBase


import UIKit

private let reuseIdentifier = "Cell"

class ImageGallaryCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    

    var galleryIsSelected = false
    var label = UILabel()
    var imagesInGallery = GallaryModel()
    var galleries = [GallaryModel]()
    
    //MARK: - Privatre Properties
    
 
    private let galleriesPersistData = galleriesDataPersistance()
    private let trashButton = UIButton()
    private let showGalleryBtn = UIButton()
    private lazy var cellWidth = collectionView.frame.width / 5
    
    
    //MARK: - life cicle
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLabelIfCollectionViewIsEmpty()
        trashButtomConfiguration()
        trashButtomIsHide()
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        
        let pinchGestruer = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom))
        
        collectionView.addGestureRecognizer(pinchGestruer)
    }
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selecteItem = self.collectionView.indexPathsForSelectedItems else {print("item no found"); return}
        let indexPath = selecteItem[0].item
        
        if let previewVC = segue.destination as? ImagePreviewViewController {
            
            previewVC.imageURL = imagesInGallery.images[indexPath].imageURL
            
            
        }
        
    }
    
    //MARK: - @objc Methods
    
    
    
    @objc func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case .began, .changed :
            
            let scalecellWidth = cellWidth * sender.scale
            
            if scalecellWidth <= K.cellWithValues.max, scalecellWidth >= K.cellWithValues.min {
                
                cellWidth = scalecellWidth
                collectionView.collectionViewLayout.invalidateLayout()
                
            }
            sender.scale = 1.0
            
        default: break
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return imagesInGallery.images.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifiers.cellImageId, for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            
            if let imageURL = imagesInGallery.images[indexPath.item].imageURL{
                imageCell.imageURL = imageURL
                imageCell.fetchImage()
            }
            imageCell.fetchImage()
        }
        
        trashButtomIsHide()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.segueID.imagePreview, sender: self)
        
    }
    
    //MARK: - Methods
    
    private func trashButtomConfiguration() {
        
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.tintColor = .systemRed
        
        let dropInteraction = UIDropInteraction(delegate: self)
        trashButton.addInteraction(dropInteraction)
        
        let barItem = UIBarButtonItem(customView: trashButton)
        navigationItem.rightBarButtonItem = barItem
        
        barItem.customView!.widthAnchor.constraint(equalToConstant: 25).isActive = true
        barItem.customView!.heightAnchor.constraint(equalToConstant: 25).isActive = true
        barItem.tintColor = .systemRed
    }
    

    private func addLabelIfCollectionViewIsEmpty() {
        
        if imagesInGallery.images.isEmpty {
            label.frame = CGRect(x: 600, y: 600, width: 600.0, height: 500)
            label.center = collectionView.center
            label.textAlignment = .center
            label.textColor = .systemGray
            label.numberOfLines = 0
            label.font = label.font.withSize(50)
            label.text = "\"Please select a Gallery to see its content or add more images\""
            self.view.addSubview(label)
        }
    }
  

    private func trashButtomIsHide(){
        
        if imagesInGallery.images.isEmpty {
            
            DispatchQueue.main.async { [weak self] in
                self?.trashButton.isHidden = true
            }
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                self?.trashButton.isHidden = false
            }
        }
    }

}


//MARK: - UICollectionViewDelegateFlowLayout

extension ImageGallaryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let newHeight: CGFloat
        let aspectRatio: CGFloat
        
        let imageHeight = imagesInGallery.images[indexPath.item].imageHight
        aspectRatio = cellWidth / (imageHeight ?? 0)
        newHeight = cellWidth / aspectRatio
        
        return CGSize(width: cellWidth, height: newHeight )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        // this callculates the space between columns
        
        return 2
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        // calculate space between rows
        return 5
        
        
    }
}


//MARK: - UICollectionViewDragDelegate

extension ImageGallaryCollectionViewController: UICollectionViewDragDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        session.localContext = collectionView
        
        let image = imagesInGallery.images[indexPath.item]
        let imageURL = image.imageURL
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL! as NSItemProviderWriting))
        dragItem.localObject = image
        return [dragItem]
    }
}




//MARK: - UICollectionViewDropDelegate

extension ImageGallaryCollectionViewController: UICollectionViewDropDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: (isSelf ? .move : .copy), intent: .insertAtDestinationIndexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        
        switch collectionView.hasActiveDrag {
            
        case true:
            return session.canLoadObjects(ofClass: URL.self)
            
        case false:
            return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        if galleryIsSelected {
            
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            
            for item in coordinator.items {
                
                label.isHidden = true
                
                if let sourceIndexPath = item.sourceIndexPath {
                    
                    if let image = item.dragItem.localObject as? ImageModel {
                        collectionView.performBatchUpdates {
                            
                            imagesInGallery.images.remove(at: sourceIndexPath.item)
                            imagesInGallery.images.insert(image, at: destinationIndexPath.item)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                            galleriesPersistData.saveData(galleries)
                            
                        }
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    }
                } else {
                    
                    // Drop from outside the app
                    
                    let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(
                            insertionIndexPath: destinationIndexPath,
                            reuseIdentifier: K.Identifiers.placeHolderCellId))
                    
                    
                    //new image object
                    
                    var newImage = ImageModel(imageURL: nil, imageHight: nil)
                    
                    // get hight of the dragget image
                    
                    item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { provider, error in
                        DispatchQueue.main.async {
                            if let image = provider as? UIImage {
                                newImage.imageHight = image.size.height
                            }
                        }
                    }
                    
                    _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { provider, error in
                        
                        DispatchQueue.main.async {
                            if let url = provider?.imageURL {
                                newImage.imageURL = url
                                placeholderContext.commitInsertion(dataSourceUpdates: { insertationIndexPath in
                                    
                                    self.imagesInGallery.images.insert(newImage, at: insertationIndexPath.item)
                                    self.galleriesPersistData.saveData(self.galleries)
                                    
                                })
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Extentions

extension ImageGallaryCollectionViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        
        return session.canLoadObjects(ofClass: URL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let imageURL = session.items.first else { return }
        guard let droppedImage = imageURL.localObject as? ImageModel else { return }
        guard let URLindex = imagesInGallery.images.firstIndex(of: droppedImage) else { return }
        
        imagesInGallery.images.remove(at: URLindex)
        galleriesPersistData.saveData(galleries)
        collectionView.reloadData()
    }
    
}

//MARK: - Constatns extension

extension ImageGallaryCollectionViewController {
    private struct K {
        struct Identifiers {
            static let cellImageId = "ImageCell"
            static let placeHolderCellId = "ImageCellPlaceholder"
        }
        struct segueID {
            static let imagePreview = "ImagePreview"
        }
        struct cellWithValues {
            static let max: CGFloat = 610.0
            static let min: CGFloat = 100
        }
    }
}
