//
//  PRKWebViewController.swift
//  prkng-ios
//
//  Created by Cagdas Altinkaya on 18/06/15.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit

class PRKWebViewController: AbstractViewController, UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "bg_login"))
    private var statusBar = UIView()
    private let webView = UIWebView()
    
    private var englishUrl: String
    private var frenchUrl: String
    
    var didFinishLoadingCallback: (() -> Bool)?
    
    private let backButton = ViewFactory.hugeButton()
    
    init(url: String) {
        self.englishUrl = url
        self.frenchUrl = url
        super.init(nibName: nil, bundle: nil)
    }

    init(englishUrl: String, frenchUrl: String) {
        self.englishUrl = englishUrl
        self.frenchUrl = frenchUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let pre: AnyObject = NSLocale.preferredLanguages()[0]
        let str = "\(pre)"
        let lang = str.substringToIndex(str.startIndex.advancedBy(2))
        
        var url : NSURL
        if lang == "fr" {
            url = NSURL(string : frenchUrl)!
        } else {
            url = NSURL(string : englishUrl)!
        }
        SVProgressHUD.show()
        webView.loadRequest(NSURLRequest(URL: url))
        
    }
    
    func setupViews() {
        
        backgroundImageView.contentMode = .ScaleAspectFill
        view.addSubview(backgroundImageView)
        
        statusBar.backgroundColor = Styles.Colors.midnight2
        view.addSubview(statusBar)
        
        webView.delegate = self
        webView.backgroundColor = UIColor.clearColor()
        view.addSubview(webView)
        
        backButton.setTitle("back".localizedString, forState: .Normal)
        backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside)
        
        backButton.layer.masksToBounds = false
        backButton.layer.shadowOffset = CGSizeMake(0, -1.0)
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOpacity = 0.1
        view.addSubview(backButton)
    }
    
    
    func setupConstraints() {
        
        backgroundImageView.snp_makeConstraints { (make) -> () in
            make.edges.equalTo(self.view)
        }
        
        statusBar.snp_makeConstraints { (make) -> () in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(20)
        }
        
        webView.snp_makeConstraints { (make) -> () in
            make.top.equalTo(self.statusBar.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.backButton.snp_top)
        }
        
        backButton.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(Styles.Sizes.hugeButtonHeight)
        }
        
    }
    
    // MARK: Button Handlers
    
    func backButtonTapped() {
        if let navVC = self.navigationController {
            navVC.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    // MARK: UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //this commented out part is to put saved cookies back into the cookie jar, but because we set our cache policy properly any UIWebView and NSURLConnection will use the cookie jar!
//        let cookieCount = NSUserDefaults.standardUserDefaults().integerForKey("prkng_cookie_count")
//        for i in 0..<cookieCount {
//            if let cookieProperties = NSUserDefaults.standardUserDefaults().objectForKey("prkng_cookie_"+String(i)) as? [String : AnyObject] {
//                if cookieProperties["Name"] as? String ?? "" == "mySession" {
//                    NSLog("MY SESH")
//                }
//                if let cookie = NSHTTPCookie(properties: cookieProperties) {
//                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
//                }
//            }
//        }

        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        
//        let response = NSURLCache.sharedURLCache().cachedResponseForRequest(webView.request!)?.response
        
        //this commented out part is to save cookies, but because we set our cache policy properly any UIWebView and NSURLConnection will use the cookie jar!
//        let capturedCookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string: englishUrl)!) ?? []
//        for i in 0..<capturedCookies.count {
//            let cookie = capturedCookies[i]
//            NSUserDefaults.standardUserDefaults().setObject(cookie.properties, forKey: "prkng_cookie_"+String(i))
//            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
//        }
//        NSUserDefaults.standardUserDefaults().setInteger(capturedCookies.count, forKey: "prkng_cookie_count")
        
        if didFinishLoadingCallback?() ?? false {
            backButtonTapped()
        }
    }
    
    
}
