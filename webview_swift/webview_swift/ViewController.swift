//
//  ViewController.swift
//  webview_swift
//
//  Created by allison on 2021/12/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jumpBookingSearchWKWebViewController()
    }
    
    /// 跳转极验网页版
    func jumpBookingSearchWKWebViewController() {
        let webView = GT3WKWebView.init(frame: self.view.bounds)
        webView.successCallBack  = {
            webView.removeFromSuperview()
           
        }
        webView.cancleCallBack = {
            webView.removeFromSuperview()
        }
        self.view.addSubview(webView)
    }


}

