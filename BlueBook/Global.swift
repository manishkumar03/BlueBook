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
    static let dbkey = "xxxxxxxx"
    static let dbpwd = "xxxxxx"
    static let dbuser = "xxxxxxxx"
    static let remoteDbString = "https://" +
        Global.dbkey + ":" +
        Global.dbpwd + "@" +
        Global.dbuser +
        ".cloudant.com/" +
        Global.remoteDb
    static let remoteUrl = URL(string: remoteDbString)
    
}

