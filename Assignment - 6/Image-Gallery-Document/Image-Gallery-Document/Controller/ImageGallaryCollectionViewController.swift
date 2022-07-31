//
//  ImageGallaryCollectionViewController.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/14/22.
//


import UIKit


class ImageGallaryCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    var gallery = GallaryModel()
    var galleryDocument: GalleryDocument?
    private weak var blurView: UIView?
    
    //MARK: - Privatre Properties
    
    private var infoView: GalleryInformationViewController?
    private let trashButton = UIButton()
    private let infoButton = UIButton()
    private let showGalleryBtn = UIButton()
    private lazy var cellWidth = collectionView.frame.width / 5
    private var label = UILabel()
    
    
    //MARK: - NSObjectProtocol Observers
    private var documentStateChangeObserver: NSObjectProtocol?
    private var galleryObserver: NSObjectProtocol?
    
    //MARK: - life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLabelIfCollectionViewIsEmpty()
        trashButtomConfiguration()
        trashButtomIsHide()
        
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        
        let pinchGestruer = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom))
        
        collectionView.addGestureRecognizer(pinchGestruer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        // GalleryDocument state change observer
        documentStateChangeObserver = NotificationCenter.default.addObserver(
            forName: UIDocument.stateChangedNotification,
            object: galleryDocument,
            queue: OperationQueue.main,
            using: { notification in
                print("DocumentState change to \(self.galleryDocument!.documentState.rawValue)")
            }
        )
        
        
        
        
        if galleryDocument?.documentState != .normal {
            galleryDocument?.open { success in
                if success {
                    self.title = self.galleryDocument?.localizedName
                    
                    self.galleryObserver = NotificationCenter.default.addObserver(
                        forName: Notification.Name.GalleryDidChange,
                        object: self,
                        queue: OperationQueue.main,
                        using: { notification in
                            self.saveDocumentChanges()
                            
                        })
                    
                    if let document = self.galleryDocument?.gallery {
                        self.gallery = document
                        self.collectionView.reloadData()
                        if !self.gallery.images.isEmpty {
                            self.label.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // change for a switch statement later
        if segue.identifier == K.segueID.imagePreview {
            
            guard let selecteItem = self.collectionView.indexPathsForSelectedItems else {print("item no found"); return}
            let indexPath = selecteItem[0].item
            
            if let previewVC = segue.destination.contents as? ImagePreviewViewController {
                
                previewVC.imageURL = gallery.images[indexPath].imageURL
            }
        } else if segue.identifier == K.segueID.galleryInfoId {
            if let infoVC = segue.destination.contents as? GalleryInformationViewController {
                galleryDocument?.thumbnail = self.collectionView.snapshot
                infoVC.galleryDocument = self.galleryDocument
                infoVC.removeBluerDelegate = self
                
                // Adds the bluer Effect when the infoVC is call
                
                DispatchQueue.main.async { [weak self] in
                    
                    if let self = self {
                        
                        
                        let blurEffect = UIBlurEffect(style: .extraLight)
                        let blurEffectView = UIVisualEffectView(effect: blurEffect)
                        blurEffectView.frame = self.view.bounds
                        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.view.addSubview(blurEffectView)
                        self.blurView = blurEffectView
                    }
                    
                }
                
            }
        }
    }
    
    
    
    //Unwind segue
    
    @IBAction func closeDocument (bySegue: UIStoryboardSegue ) {
        closeDocument()
    }
    
    
    //MARK: - @BAAction
    
    
    @IBAction func closeDocument(_ sender: UIBarButtonItem? = nil) {
        
        guard let galleyobserver = galleryObserver else {return}
        guard let galleryDocumentObserver = documentStateChangeObserver else {return}
        NotificationCenter.default.removeObserver(galleyobserver)
        
        saveDocumentChanges()
        if galleryDocument?.gallery != nil {
            galleryDocument?.thumbnail = self.collectionView.snapshot
        }
        dismiss(animated: true) {
            self.galleryDocument?.close() { success in
                NotificationCenter.default.removeObserver(galleryDocumentObserver)
            }
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
    
    @objc func presentInfoView(_ sender: UIButton) {
        performSegue(withIdentifier: K.segueID.galleryInfoId, sender: self)
    }
    
    // MARK: - UICollectionViewDataSource
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return gallery.images.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifiers.cellImageId, for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            
            if let imageURL = gallery.images[indexPath.item].imageURL{
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
    
    private func saveDocumentChanges() {
        
        galleryDocument?.gallery = gallery
        if  galleryDocument?.gallery != nil {
            galleryDocument?.updateChangeCount(.done)
        }
        
    }
    
    private func trashButtomConfiguration() {
        
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.tintColor = .systemRed
        
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        
        let dropInteraction = UIDropInteraction(delegate: self)
        trashButton.addInteraction(dropInteraction)
        
        let trashBtnBarItem = UIBarButtonItem(customView: trashButton)
        let inforBtnBarItme = UIBarButtonItem(customView: infoButton)
        
        //        navigationItem.rightBarButtonItem = trashBtnBarItem
        navigationItem.rightBarButtonItems = [ inforBtnBarItme, trashBtnBarItem]
        
        trashBtnBarItem.customView!.widthAnchor.constraint(equalToConstant: 400).isActive = true
        trashBtnBarItem.customView!.heightAnchor.constraint(equalToConstant: 25).isActive = true
        trashBtnBarItem.tintColor = .systemRed
        
        inforBtnBarItme.customView!.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inforBtnBarItme.customView!.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        infoButton.addTarget(self, action: #selector(presentInfoView), for: .touchUpInside)
    }
    
    
    private func addLabelIfCollectionViewIsEmpty() {
        
        if gallery.images.isEmpty {
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
        
        if gallery.images.isEmpty {
            
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

//MARK: - Extentions

//MARK: - UICollectionViewDelegateFlowLayout

extension ImageGallaryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let newHeight: CGFloat
        let aspectRatio: CGFloat
        
        let imageHeight = gallery.images[indexPath.item].imageHight
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
        
        let image = gallery.images[indexPath.item]
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
        
        
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            
            label.isHidden = true
            
            if let sourceIndexPath = item.sourceIndexPath {
                
                if let image = item.dragItem.localObject as? ImageModel {
                    collectionView.performBatchUpdates {
                        
                        gallery.images.remove(at: sourceIndexPath.item)
                        gallery.images.insert(image, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        NotificationCenter.default.post(name: .GalleryDidChange, object: self)
                        
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
                                
                                self.gallery.images.insert(newImage, at: insertationIndexPath.item)
                                NotificationCenter.default.post(name: .GalleryDidChange, object: self)
                                
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


//MARK: - UIDropInteractionDelegate for Delete Btn

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
        guard let URLindex = gallery.images.firstIndex(of: droppedImage) else { return }
        
        gallery.images.remove(at: URLindex)
        NotificationCenter.default.post(name: .GalleryDidChange, object: self)
        collectionView.reloadData()
    }
    
}





//MARK: - RemoveBluer Extention

extension ImageGallaryCollectionViewController: removeBlurViewDelegate {
    func removeBluer() {
        blurView?.removeFromSuperview()
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
            static let galleryInfoId = "GalleryInfo"
        }
        struct cellWithValues {
            static let max: CGFloat = 610.0
            static let min: CGFloat = 100
        }
    }
}
