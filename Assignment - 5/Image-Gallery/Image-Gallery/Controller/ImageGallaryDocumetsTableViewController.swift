//
//  ImageGallaryDocumetsTableViewController.swift
//  Image-Gallery
//
//  Created by Kevin Martinez on 6/14/22.
//


//TODO: finish UIText to name each gallery and to delete each gallery. and add edit name capability

import UIKit



class ImageGallaryDocumetsTableViewController: UITableViewController {
    
    //MARK: - IBOUtlets
    
    @IBOutlet weak private var galleryEditBtn: UIBarButtonItem!
    @IBOutlet weak private var addGalleryBtn: UIBarButtonItem!
    
    
    //MARK: - Properties
    
    private var gallaries = [GallaryModel]()
    private var deletedGalleries = [GallaryModel]()
    private var autoSelectRow = true
    private let galleriesPersistData = galleriesDataPersistance()
    private let deletedGalleriesPersistData = DeletedgalleriesDataPersistance()
    
    
    //MARK: - Life Cicly
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        gallaries = galleriesPersistData.loadItems()
        deletedGalleries = deletedGalleriesPersistData.loadItems()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .oneOverSecondary {
            splitViewController?.preferredDisplayMode = .oneOverSecondary
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gallaries.isEmpty {
            createNewGallery()
        }
        
        
        if autoSelectRow {
            autoSelectGallery()
            autoSelectRow = false
        }
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.TableViewRowSize.heigth
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        editBtnisEnable()
        
        if section == 0 {
            return gallaries.count
        } else {
            return deletedGalleries.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if section == 1 && deletedGalleries.count > 0 {
            return K.TableViewSectionNames.recentDeleted
        } else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.cellId, for: indexPath)
            
            if let titleCell = cell as? GalleryTableViewCell {
                
                titleCell.titleTextField.isEnabled = false
                titleCell.titleTextField.text = gallaries[indexPath.row].tite
                
                let dobleTapGesture = UITapGestureRecognizer(target: self, action: #selector(editTitle(_:)))
                dobleTapGesture.numberOfTapsRequired = 2
                titleCell.addGestureRecognizer(dobleTapGesture)
                
                
            }
            
            return cell
            
        } else {
            let deletedCell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.deleteCellID, for: indexPath)
            deletedCell.textLabel?.text = deletedGalleries[indexPath.row].tite
            return deletedCell
            
        }
        
        
    }
    
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: K.segueID.goToImages, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                let galleryToMove = gallaries[indexPath.row]
                // Delete the row from the data source
                
                
                tableView.performBatchUpdates { [weak self] in
                    self?.gallaries.remove(at: indexPath.row)
                    self?.deletedGalleries.append(galleryToMove)
                    tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
                    self?.galleriesPersistData.saveData(gallaries)
                    self?.deletedGalleriesPersistData.saveData(deletedGalleries)
                    
                } completion: { _ in
                    if self.gallaries.isEmpty {
                        self.createNewGallery()
                        self.autoSelectGallery()
                    }
                    self.reloadTableViewInMainTreat()
                }
                
            }  else {
                tableView.performBatchUpdates {
                    deletedGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    //ADD save data for the deletedGalleries
                    deletedGalleriesPersistData.saveData(deletedGalleries)
                    reloadTableViewInMainTreat()
                }
            }
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        gallaries.swapAt(fromIndexPath.row, to.row)
        galleriesPersistData.saveData(gallaries)
        
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            
            var actions = [UIContextualAction]()
            
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") {action, view,_ in
                
                let recovery = self.deletedGalleries[indexPath.row]
                
                tableView.performBatchUpdates { [weak self] in
                    self?.deletedGalleries.remove(at: indexPath.row)
                    self?.gallaries.append(recovery)
                    tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                    self?.galleriesPersistData.saveData(self!.gallaries)
                    self?.deletedGalleriesPersistData.saveData(self!.deletedGalleries)
                } completion: { _ in
                    self.reloadTableViewInMainTreat()
                }
            }
            
            actions.append(recoverAction)
            return UISwipeActionsConfiguration(actions: actions)
            
        } else {
            return nil
        }
    }
    
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationVC = segue.destination.contents as? ImageGallaryCollectionViewController {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destinationVC.label.removeFromSuperview()
                destinationVC.galleryIsSelected = true
                destinationVC.imagesInGallery = gallaries[indexPath.row]
                destinationVC.title = gallaries[indexPath.row].tite
                destinationVC.galleries = gallaries
            }
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction private func newGallery(_ sender: UIBarButtonItem) {
        
        createNewGallery()
        
    }
    
    @IBAction private func editGalleries(_ sender: UIBarButtonItem) {
        
        //        tableView.isEditing = !tableView.isEditing
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if self.tableView.isEditing  {
                self.tableView.isEditing = false
                self.addGalleryBtn.isEnabled = true
            } else {
                self.tableView.isEditing = true
                self.addGalleryBtn.isEnabled = false
            }
        }
    }
    
    //MARK: - @objc Methods
    
    @objc private func editTitle(_ sender: UITapGestureRecognizer){
        switch sender.state {
        case .ended: print("Doble tap reconized")
            
            if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
                if let cell = tableView.cellForRow(at: indexPath) as? GalleryTableViewCell {
                    cell.titleTextField.isEnabled = true
                    cell.titleTextField.text = nil
                    cell.titleTextField.becomeFirstResponder()
                    cell.resignationHandler = { [weak self, unowned cell] in
                        
                        if let title = cell.titleTextField.text?.isEmpty {
                            
                            if title == false {
                                self?.gallaries[indexPath.row].tite = cell.titleTextField.text
                                cell.titleTextField.isEnabled = false
                                self?.reloadTableViewInMainTreat()
                                self?.galleriesPersistData.saveData(self!.gallaries)
                            } else  {
                                self?.gallaries[indexPath.row].tite = "Untitled"
                                cell.titleTextField.isEnabled = false
                                self?.reloadTableViewInMainTreat()
                                self?.galleriesPersistData.saveData(self!.gallaries)
                                
                            }
                        }
                    }
                }
            }
            
        default: break
        }
    }
    
    //MARK: - Methods
    
    private func reloadTableViewInMainTreat(){
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func editBtnisEnable() {
        
        if gallaries.isEmpty {
            galleryEditBtn.isEnabled = false
            
        } else {
            galleryEditBtn.isEnabled = true
        }
    }
    
    private func autoSelectGallery() {
        
        if gallaries.count >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.tableView.selectRow(at: [0,0], animated: false, scrollPosition: .none)
                self?.performSegue(withIdentifier: K.segueID.goToImages, sender: self)
                self?.tableView.deselectRow(at: [0,0], animated: false)
            }
        }
    }
    
    private func createNewGallery() {
        let newGallery = GallaryModel()
        newGallery.tite = "Untitled"
        gallaries.insert(newGallery, at: 0)
        galleriesPersistData.saveData(gallaries)
        reloadTableViewInMainTreat()
    }
    
}

//MARK: - Constants extension

extension ImageGallaryDocumetsTableViewController {
    private struct K {
        struct Identifiers {
            static let cellId = "DocumentCell"
            static let deleteCellID = "DeleteGalleryCell"
        }
        struct segueID {
            static let goToImages = "Images"
        }
        struct TableViewRowSize {
            static let heigth: CGFloat = 50.0
        }
        struct TableViewSectionNames {
            static let recentDeleted = "Recently Deleted"
        }
    }
}


