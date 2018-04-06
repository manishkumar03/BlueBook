//
//  DatabaseClient.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-03-10.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit

class DatabaseClient {
    
    // Cloudant Sync
    var datastoreManager: CDTDatastoreManager?
    var datastore: CDTDatastore?
    
    init() {
        do {
            datastoreManager = try CDTDatastoreManager(directory: Global.storePath)
            datastore = try datastoreManager?.datastoreNamed("booksdb")
        } catch {
            fatalError("Failed to initialize datastore: \(error)")
        }
    }
    
    func pullChangesFromRemote(){
        let pullReplication = CDTPullReplication(source: Global.remoteUrl,target: datastore!)
        let replicator = CDTReplicatorFactory(datastoreManager: datastoreManager)
        do {
            let pullJob = try replicator?.oneWay(pullReplication)
            try pullJob?.start()
            
        } catch {
            fatalError("Failed to pull changes from remote")
        }
    }
    
    func pushChangesToRemote(){
        let pushReplication = CDTPushReplication(source: datastore!, target: Global.remoteUrl)
        let replicator = CDTReplicatorFactory(datastoreManager: datastoreManager)
        do {
            let pushJob = try replicator?.oneWay(pushReplication)
            try pushJob?.start()
            
        } catch {
            fatalError("Failed to push to remote")
        }
    }
        
    func storeDocumentLocally(_ newDocument: CDTDocumentRevision) {
        do {  
            let resultOfStore = try datastore?.createDocument(from: newDocument)
            debugPrint("Created document \(String(describing: resultOfStore?.docId))")
        } catch {
            fatalError("Failed to create document")
        }
    }
    
    func deleteDocumentLocally(_ docId: String) {
        do {
            //let toBeDeletedBookDoc = try datastore?.getDocumentWithId(docId)
            try datastore?.deleteDocument(withId: docId)
            debugPrint("Deleted document ", docId)
        } catch {
            fatalError("Failed to delete document")
        }
    }

}
