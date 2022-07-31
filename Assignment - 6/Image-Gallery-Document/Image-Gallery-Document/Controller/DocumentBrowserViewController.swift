//
//  DocumentBrowserViewController.swift
//  Image-Gallery-Document
//
//  Created by Kevin Martinez on 7/12/22.
//

import UIKit

// create the docuement template in view will apper in the catche app directory to create a template

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    private var template: URL?
    private var galleryTemplate = GallaryModel()
    private var userDefault = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        
    // this will create the templated in the catche directory only once when the app is launch for first time to dont load the catche directory with multiple templates, in case the template in viewDidLoad cannot create the template. the custom extention created .igd stants for image gallery docuement.
        
        if  userDefault.value(forKey: "CreateTemplateInCache") == nil {
        if let json = galleryTemplate.json {
            if let url = try? FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Untitled-Gallery.igd"){
                do {
                    try json.write(to: url)
                    userDefault.set(true,forKey: "CreateTemplateInCache")
                    print("template created in catche")
                } catch let error{
                    print("Coulnd't create template in cache directory \(error)")
                }
            }
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Untitled-Gallery.igd")
                    if template != nil {
                        allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
                    }
                }
        }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoart = UIStoryboard(name: "Main", bundle: nil)
        
        let galleryVC = storyBoart.instantiateViewController(withIdentifier: "GalleryVC")
        if let imageGalleryCollectionView = galleryVC.contents as? ImageGallaryCollectionViewController {
            imageGalleryCollectionView.galleryDocument = GalleryDocument(fileURL: documentURL)
            galleryVC.modalPresentationStyle = .fullScreen
            present(galleryVC, animated: true)
        }
      
    }
}

