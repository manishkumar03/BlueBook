//
//  CloudantFunctions.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-03-10.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

func createDocument(_ parsedJson: JSON) -> CDTDocumentRevision {
    let rev = CDTDocumentRevision()
    let bookTitle = parsedJson["book"]["title"].stringValue
    let bookAuthor = parsedJson["book"]["authors"][0].stringValue
    let bookImageLocation = parsedJson["book"]["image"].stringValue
    let bookIsbn13 = parsedJson["book"]["isbn13"].stringValue
    let bookScanDateTime = String(describing: Date())
    rev.body = ["bookTitle": bookTitle,
                "bookAuthor": bookAuthor,
                "bookImageLocation": bookImageLocation,
                "bookIsbn13": bookIsbn13,
                "bookScanDateTime": bookScanDateTime
    ]
    
    // If book cover is not found, use a standard NoCover image
    var bookCoverFound = true
    let bookImageLocationUrl = URL(string: bookImageLocation)
    if let imageData = try? Data(contentsOf: bookImageLocationUrl!) {
        print("imageData Count: \(imageData.count)")
        if imageData.count < 2000 {
            bookCoverFound = false
        }
        if bookCoverFound == true {
            let coverAttachment = CDTUnsavedDataAttachment(data: imageData,
                                                           name: bookIsbn13 + ".jpg",
                                                           type: "image/jpeg")!
            rev.attachments = [coverAttachment.name: coverAttachment]
        }
    } else {
        bookCoverFound = false
    }

    if bookCoverFound == false {
        let path = Bundle.main.path(forResource: "NoCover", ofType: "jpg")
        let coverAttachment = CDTUnsavedFileAttachment(path: path,
                                                       name: "NoCover.jpg",
                                                       type: "image/jpeg")!
        rev.attachments = [bookIsbn13: coverAttachment]
    }
    
    return rev
}
