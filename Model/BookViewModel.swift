//
//  BookViewModel.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-03-10.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class BookViewModel {
    let databaseClient: DatabaseClient!
    var allBooks: [Book]
    
    init() {
        self.databaseClient = DatabaseClient()
        self.allBooks = []        
    }
    
    func populateMyBooks() {
        databaseClient.pullChangesFromRemote()
        let allLocalBookDocuments = databaseClient.datastore?.getAllDocuments() as! [CDTDocumentRevision]
        allBooks.removeAll()
        for localBookDocument in allLocalBookDocuments {
            let newBook = Book(doc: localBookDocument)
            allBooks.append(newBook)
        }
        allBooks.sort{$0.bookScanDateTime > $1.bookScanDateTime}
    }
    
    func createBookUrl(scannedBarcode: String) -> String {
        return "https://api.isbndb.com/book/" + scannedBarcode        
    }
    
    func getHttpHeaderApiKey() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "X-API-KEY": "DNTZCfj1jP7Gsz3XoXJ4P3iaLsfwTv4t4CiBr94q",
            "Accept": "application/json"
        ]        
        return headers
    }
    
    func getBluemixServerUrl() -> URL {
        return URL(string: "https://bluebookserver.mybluemix.net/books")!
    }
    
    func checkIfBookAlreadyExists(newBookJson: JSON) -> Bool {
        var doesBookExist = false
        let tempBookIsbn13 = newBookJson["book"]["isbn13"].stringValue
        for book in allBooks {
            if book.bookIsbn13 == tempBookIsbn13 {
                doesBookExist = true
                break
            }
        }
        return doesBookExist
    }
    
    func refreshFromRemote() {
        populateMyBooks()        
    }
    
    func storeNewBook(newBookJson: JSON) {
        let newDocument = createDocument(newBookJson)
        let newBook = Book(doc: newDocument)
        debugPrint("Book created at: \(Date())")
        allBooks.insert(newBook, at: 0)
        databaseClient.storeDocumentLocally(newDocument)
        databaseClient.pushChangesToRemote()
    }
    
    func deleteBook(row:Int, docId: String) {
        allBooks.remove(at: row)
        databaseClient.deleteDocumentLocally(docId)
        databaseClient.pushChangesToRemote()
    }
    
    func getNumberSections () -> Int {
        return 1
    }
    
    func getNumberOfItemsInSection (_ section: Int) -> Int {
        return allBooks.count
    }
    
    func getBookAt(indexPath: IndexPath) -> Book {
        return allBooks[indexPath.row]
    }
    
    func getBookAuthorAt(row: Int) -> String {
        return allBooks[row].bookAuthor
    }
    
    func getBookTitleAt(row: Int) -> String {
        return allBooks[row].bookTitle
    }
    
    func getBookCoverImage(row: Int) -> UIImage {
        return allBooks[row].bookCoverImage
    }
    
    func getBookDocId(row: Int) -> String {
        return allBooks[row].bookDocId
    }
    

}
