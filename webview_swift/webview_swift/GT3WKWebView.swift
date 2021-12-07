//
//  GT3WKWebView.swift
//  webview_swift
//
//  Created by allison on 2021/12/7.
//

import Foundation


import UIKit
import WebKit

typealias SuccessCallBack = () -> Void
typealias CancleCallBack = () -> Void


class GT3WKWebView: UIView {
    
    /// 验证成功回调
    var successCallBack:SuccessCallBack!
    
    /// 关闭回调
    var cancleCallBack :CancleCallBack!
    
    
    private lazy var webView: WKWebView = {
        //创建网页配置对象
        let config = WKWebViewConfiguration()
        // 创建设置对象
        let preference = WKPreferences()
        //设置是否支持 javaScript 默认是支持的
        preference.javaScriptEnabled = true
        // 在 iOS 上默认为 NO，表示是否允许不经过用户交互由 javaScript 自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preference
        //这个类主要用来做 native 与 JavaScript 的交互管理
        let wkUController = WKUserContentController()
        //注册一个 name 为 jsToOcNoPrams 的 js 方法 设置处理接收 JS 方法的对象
        wkUController.add(self, name: "jsToOcNoPrams")
        wkUController.add(self, name: "jsToOcWithPrams")
        config.userContentController = wkUController
        //用于进行 JavaScript 注入
        let jSString = "jsBridge"
        let wkUScript = WKUserScript(source: jSString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(wkUScript)
        webView = WKWebView(frame: CGRect(x: 20, y: 0, width: self.frame.size.width - 40, height: 280), configuration: config)
        webView.center = self.center
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        // UI 代理
        webView.uiDelegate = self
        // 导航代理
        webView.navigationDelegate = self
        //此处即需要渲染的网页
        let url = "http://wxqy.tianjin-air.com/hnatravel/signcodeIOS.html"
        if let url1 = URL(string: url) {
            webView.load(URLRequest(url: url1))
        }
        return webView
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(webView)
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        //self.backgroundColor = UIColor.clear
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(tapAction(action:)))
        self.addGestureRecognizer(tap)
    }
    
    /*轻点手势的方法*/
    @objc func tapAction(action:UITapGestureRecognizer) -> Void {
        print("轻点手势的方法*")
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GT3WKWebView : WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 此处 message.body 即传给客户端的 json 数据
        //用 message.body 获得 JS 传出的参数体
        let parameter = message.body as? [String:String]
        //JS 调用 OC
        if message.name == "jsToOcWithPrams" {
            //在此处客户端得到 js 透传数据 并对数据进行后续操作
            let params =  parameter?["params"] ?? ""
            let result =  parameter?["result"] ?? "0"
            if result == "0" { //验证通过(和前端规定好的)
                if successCallBack != nil {
                    successCallBack()
                }
            } else if result == "2" { //手动关闭
                if cancleCallBack != nil {
                    cancleCallBack()
                }
            }
        }
    }
    
    
}
