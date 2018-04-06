//
//  Global.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-08.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit

class Global {
    static let fm = FileManager.default
    static let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).last!
    static let storePath  = Global.documentsDirectory.appendingPathComponent("books-datastore").path
    static let remoteDb = "booksdb"
    static let dbkey = "tsearnothereparzanderehu"
    static let dbpwd = "a0e72f3181e6855c15c74c74775a19f9a8a7d3e9"
    static let dbuser = "bdbf2b08-fb3b-4a6f-aab2-1429e419b68d-bluemix"
    static let remoteDbString = "https://" +
        Global.dbkey + ":" +
        Global.dbpwd + "@" +
        Global.dbuser +
        ".cloudant.com/" +
        Global.remoteDb
    static let remoteUrl = URL(string: remoteDbString)
    
}

