//
//  PreviewViewController.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/25/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit
import Siesta
import WebKit
class PreviewViewController: UIViewController {

    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var posTtitle: UILabel!
    @IBOutlet weak var preview: RemoteImageView!
    
    @IBAction func closePop(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    var stringUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    //Config for set all properties & design
    func setupView() {
        webView.navigationDelegate = self
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        preview.layer.borderWidth = 10.0
        preview.layer.masksToBounds = false
        preview.layer.borderColor = UIColor.white.cgColor
        preview.layer.cornerRadius = 50
        preview.clipsToBounds = true
        posTtitle.adjustsFontSizeToFitWidth = true
        
    }
    
    /// We trigger this one from the prepare in order to be ready to load the page
    func renderPage() {
        //For load the page on the webView
        guard let urlString = stringUrl, urlString.isValidURL else { return }
        let url = URL(string: urlString)
        let requestObj = URLRequest(url: url!)
        
        webView.load(requestObj)
        indicator.startAnimating()
    }
    
    /// Give an option to the user to view the content on safari
    ///
    /// - Parameter sender:
    @IBAction func openSite(_ sender: Any) {
         guard let urlString = stringUrl, urlString.isValidURL else { return }
        guard let url = URL(string: urlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension PreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

// MARK: - Validates de string 
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
}
