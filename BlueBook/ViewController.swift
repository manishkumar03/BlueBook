//
//  ViewController.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-07.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // Cloudant Sync
    var datastoreManager: CDTDatastoreManager?
    var datastore: CDTDatastore?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Cloudant Sync datastore
        initDatastore()
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .ean8, .pdf417]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            processBarcode(stringValue)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    func processBarcode(_ barcodeString: String) {
        print("Found Barcode:", barcodeString)
        //let barcodeString2 = "0399529209"
        let bookUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + barcodeString
        print("Book URL:", bookUrl)
        Alamofire.request(bookUrl).responseJSON { response in // method defaults to `.get`
            //let resultJson = response.result.value!
            let parsedJson = JSON(response.result.value!)
            
            //print(resultJson["ISBN:" + barcodeString2]["notes"].stringValue)
            debugPrint(parsedJson)
            
            let rev = CDTDocumentRevision()
            let bookTitle = parsedJson["items"][0]["volumeInfo"]["title"].stringValue
            let bookAuthor = parsedJson["items"][0]["volumeInfo"]["authors"][0].stringValue
            let bookImageUrl = parsedJson["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
            rev.body = ["bookTitle": bookTitle,
                        "bookAuthor": bookAuthor,
                        "bookImage": bookImageUrl
            ]
            
            do {
                let resultOfStore = try self.datastore?.createDocument(from: rev)
                print("Created document \(resultOfStore?.docId)")
                
                // Retrieve the same document
                let retrieved = try self.datastore?.getDocumentWithId(resultOfStore?.docId)
                print("Retrieved document \(retrieved?.docId)")
                
            } catch {
                fatalError("Failed to create document")
            }
            
            let remoteDbString = "https://" +
                                Global.dbkey + ":" +
                                Global.dbpwd + "@" +
                                Global.dbuser +
                                ".cloudant.com/" +
                                Global.remoteDb
            let remoteUrl = URL(string: remoteDbString)
            
            
            
            
            let pushReplication = CDTPushReplication(source: self.datastore!, target: remoteUrl)
            let replicator = CDTReplicatorFactory(datastoreManager: self.datastoreManager)
            do {
                let pushJob = try replicator?.oneWay(pushReplication)
                try pushJob?.start()
                
            } catch {
                fatalError("Failed to push to remote")
            }


        }
    }
    
    func initDatastore() {
        do {
            datastoreManager = try CDTDatastoreManager(directory: Global.storePath)
            datastore = try datastoreManager?.datastoreNamed("booksdb")
        } catch {
            fatalError("Failed to initialize datastore: \(error)")
        }
    }

}

