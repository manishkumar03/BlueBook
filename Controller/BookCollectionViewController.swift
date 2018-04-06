//
//  BookCollectionViewController.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-09.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation
import Alamofire

private let reuseIdentifier = "Cell"

class BookCollectionViewController: UICollectionViewController, ScannerBarcodeDelegate, UICollectionViewDelegateFlowLayout {

    let bookViewModel = BookViewModel()
    var passedBarcode = String()
    var doesBookExist: Bool = false
    var parsedJson: JSON = JSON([:])
    let padding:CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Books"        
        bookViewModel.populateMyBooks()
        collectionView?.backgroundColor = UIColor.white
        //collectionView?.backgroundColor = UIColor(red: 0.3569, green: 0.7373, blue: 0, alpha: 1.0)
        
        if let fontStyle = UIFont(name: "Avenir-Book", size: 20) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: fontStyle]
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.6, green: 0.7882, blue: 0.4314, alpha: 1.0)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bookViewModel.getNumberSections()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookViewModel.getNumberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 3*padding)/2
        let cellSize:CGSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCell
        
            cell.cellImageView.image = bookViewModel.getBookCoverImage(row: indexPath.row)
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bookDetailsVC = storyboard?.instantiateViewController(withIdentifier: "BookDetailsVC") as? BookDetailsVC {
            bookDetailsVC.bookViewModel = bookViewModel
            bookDetailsVC.selectedRow = indexPath.row
            navigationController?.pushViewController(bookDetailsVC, animated: true)
        }
    }
    
    @IBAction func scanNewBook(_ sender: Any) {
        if let scannerVC = storyboard?.instantiateViewController(withIdentifier: "ScannerVC") as? ScannerViewController {
            scannerVC.delegate = self
            navigationController?.pushViewController(scannerVC, animated: true)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        let when = DispatchTime.now() + 2
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.collectionView?.reloadData()
//        }
//    }
    
    @IBAction func showAboutScreen(_ sender: UIBarButtonItem) {
        if let aboutScreenVC = storyboard?.instantiateViewController(withIdentifier: "AboutScreenVC") as? AboutScreenVC {
            navigationController?.pushViewController(aboutScreenVC, animated: true)
        }
    }
    
    @IBAction func refreshFromRemote(_ sender: UIBarButtonItem) {
        bookViewModel.refreshFromRemote()
        collectionView?.reloadData()
    }
    
    @IBAction func showBooksOnBluemix(_ sender: UIBarButtonItem) {
        let url = bookViewModel.getBluemixServerUrl()
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func passBarcodeBack(barcode: String) {
        self.passedBarcode = barcode
        processBarcode(passedBarcode) { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func processBarcode(_ barcodeString: String, completion: @escaping () -> Void) {
        debugPrint("Found Barcode:", barcodeString)
        
        let bookUrlString = bookViewModel.createBookUrl(scannedBarcode: barcodeString)
        
        /// API Key for ISBNDB website
        let headers = bookViewModel.getHttpHeaderApiKey()
        
        Alamofire.request(bookUrlString, headers: headers).responseJSON { response in
            if let responseFromIsbnDb = response.result.value {
                self.parsedJson = JSON(responseFromIsbnDb)
                debugPrint(self.parsedJson)
                
                // Check if the book already exists. If it does, display an error message.
                // If it's a new book, store it locally and in the cloud.
                self.doesBookExist = false
                self.doesBookExist = self.bookViewModel.checkIfBookAlreadyExists(newBookJson: self.parsedJson)
                
                if self.doesBookExist == true {
                    self.showErrMsgBookExists()
                } else {
                    self.bookViewModel.storeNewBook(newBookJson: self.parsedJson)
                    completion()
                }
            } else {
                self.showErrMsgBookNotFound()
            }
        }
    }
    
    // MARK: Error Messages
    func showErrMsgBookNotFound(){
        let ac = UIAlertController(title: "Book not found!",
                                   message: "The book you tried to scan was not found ISBNDB.com",
                                   preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) {(action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    func showErrMsgBookExists(){
        let ac = UIAlertController(title: "Book already exists!",
                                   message: "The book you tried to scan already exists in the database",
                                   preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) {(action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
}
