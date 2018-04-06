//
//  BookDetailsVC.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-14.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit
import WebKit

class BookDetailsVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var selectedRow: Int = 0
    var imageUrl = ""
    var bookViewModel: BookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteBookButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBook))
        navigationItem.rightBarButtonItem = deleteBookButton
        
        let bookAuthor = bookViewModel.getBookAuthorAt(row: selectedRow)
        let bookTitle = bookViewModel.getBookTitleAt(row: selectedRow)
        let CoverImage = bookViewModel.getBookCoverImage(row: selectedRow)
        if let data = UIImagePNGRepresentation(CoverImage) {
            let base64 = data.base64EncodedString(options: [])
            imageUrl = "data:aplication/png;base64," + base64
        }
        
        let myFont = "<font face='Avenir-Book' size='11' color= 'black'>%@"
        
        var html = "<HTML>"
        html += "<head>"
        html += "</head>"
        html += "<body>"
        html += "<center><img src=\(imageUrl) width=200></center>"
        html += "<p><b>Author:</b> \(bookAuthor)</p>"
        html += "<p><b>Title:</b> \(bookTitle)</p>"
        html += "</body>"
        html += "</HTML>"
        let aboutText = String(format: myFont, html)
        
        webView.loadHTMLString(aboutText, baseURL: nil) 
    }
    
    @objc func deleteBook() {
        print("deleteBook")
        let toBeDeletedBookId = bookViewModel.getBookDocId(row: selectedRow)
        bookViewModel.deleteBook(row:selectedRow, docId: toBeDeletedBookId)
        navigationController?.popToRootViewController(animated: true)
    }



}
