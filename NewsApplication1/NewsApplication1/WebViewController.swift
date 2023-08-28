//
//  WebViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 27/08/23.
//

import Foundation
import UIKit
import WebKit

class  WebViewController : UIViewController, WKNavigationDelegate{
    
    @IBOutlet var newsWebView: WKWebView!
    var urlForNews : String = ""
    override func viewDidLoad() {
        
        newsWebView.navigationDelegate = self
        if urlForNews == ""{
           urlForNews = "https://www.ndtv.com/india-news/tripta-tyagi-muslim-student-slapped-up-school-muzaffarpur-small-matter-teacher-who-was-seen-asking-students-to-slap-muslim-boy-4331332"
        }
        newsWebView.load(URLRequest(url: URL(string: urlForNews)!))
    }
//    override func updateViewConstraints() {
//        self.view.frame.size.height = UIScreen.main.bounds.height - 150
//        self.view.frame.origin.y =  150
//        self.view.layer.cornerRadius = 7
//        self.view.layer.borderWidth = 1
//        super.updateViewConstraints()
//    }
}
