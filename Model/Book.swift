//
//  Book.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-09.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit

class Book {
    var bookTitle: String
    var bookAuthor: String
    var bookCoverLocation: String
    var bookIsbn13: String
    var bookCoverImage: UIImage
    var bookScanDateTime: String
    var bookDocId: String = ""
    
    init(bookTitle: String, bookAuthor: String, bookCoverLocation: String, bookIsbn13: String) {
    
         self.bookTitle = bookTitle
         self.bookAuthor = bookAuthor
         self.bookCoverLocation = bookCoverLocation
         self.bookIsbn13 = bookIsbn13
         self.bookCoverImage = UIImage()
         self.bookScanDateTime = String(describing: Date())
    }
    
    init(doc: CDTDocumentRevision) {
        bookTitle = doc.body["bookTitle"] as! String
        bookAuthor = doc.body["bookAuthor"] as! String
        bookCoverLocation = doc.body["bookImageLocation"] as! String
        bookIsbn13 = doc.body["bookIsbn13"] as! String
        bookScanDateTime = doc.body["bookScanDateTime"] as? String ?? Date().description
        
        if let safeDocId = doc.docId {
            bookDocId = safeDocId
        } else {
            bookDocId = String()
        }
        
        
        let att = doc.attachments[bookIsbn13 + ".jpg"] as? CDTAttachment

        if let data = att?.dataFromAttachmentContent() {
            bookCoverImage = UIImage(data: data)!
        } else {
            bookCoverImage = UIImage(named: "NoCover.jpg")!
        }
    }
}
