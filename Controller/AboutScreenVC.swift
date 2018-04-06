//
//  AboutScreenVC.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-14.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit
import WebKit

class AboutScreenVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var aboutText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myFont = "<font face='Avenir-Book' size='9' color= 'black'>%@"
        
        var html = "<HTML>"
        html += "<head>"
        html += "</head>"
        html += "<body>"
        html += "<p>BlueBook is an app which is designed to organize your books. Scan the book barcode using the rear camera on your iPhone and it will fetch the book details from ISBNdb.</p>"
        html += "<p>Created by - Manish Kumar</p>"
        html += "</body>"
        html += "</HTML>"
        aboutText = String(format: myFont, html)
        
        webView.loadHTMLString(aboutText, baseURL: nil)
    }


}
