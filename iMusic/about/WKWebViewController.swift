//
//  WKWebControllerViewController.swift
//  iMusic
//
//  Created by MLeo on 2018/11/27.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController ,WKNavigationDelegate{

    var webView: WKWebView!
    
    var progressView:UIProgressView!
    
    var path:String!
    
    @discardableResult
    convenience init(path:String) {
        self.init()
        self.path = path
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:path)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        addProgressView()
    }
    
    
    func addProgressView(){
        progressView = UIProgressView(progressViewStyle: .bar)
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let webs = object as? WKWebView else {
            return
        }
        if "estimatedProgress" == keyPath {
            progressView.setProgress(Float(webs.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        progressView.setProgress(1, animated: true)
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    
}
