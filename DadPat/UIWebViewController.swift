//
//  UICardViewController.swift
//  DadPat
//
//  Created by 吴思 on 5/18/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

import JavaScriptCore

class UIWebViewController: UIViewController, UIWebViewDelegate
{
    
    private var m_cardId: String = "";
    private var m_webView: UIWebView?;
    
    var context = JSContext();
    var jsContext: JSContext?;
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch( key )
        {
        case "cardId":
            m_cardId = value! as! String;
            loadWeb();
            break;
        default:
            print("not find key: ", key);
            break;
        }
    }
    
    init()
    {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        let t_startBarHeight: Int = (t_windowSize.height == 812.0 ? 44 : 20);
        
        let t_swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UIWebViewController.onSwipeGesture(_:)));
        self.view.addGestureRecognizer(t_swipeGesture);
        
        let t_headMark: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(t_windowSize.width), height: t_startBarHeight));
        t_headMark.image = imageWithColor(color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0));
        self.view.addSubview(t_headMark);
        
    }
    
    func loadWeb()
    {
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        let t_startBarHeight: Int = (t_windowSize.height == 812.0 ? 44 : 20);
        let t_webView: UIWebView = UIWebView.init(frame: CGRect(x: 0, y: t_startBarHeight, width: Int(t_windowSize.width), height: Int(t_windowSize.height) - t_startBarHeight ));
        t_webView.delegate = self;
        t_webView.scalesPageToFit = true;
        
        t_webView.backgroundColor = UIColor(red: 0x27 / 255.0, green: 0x2E / 255.0, blue: 0x38 / 255.0, alpha: 1.0);
        
        /**
         是否使用内联播放器
         */
        t_webView.allowsInlineMediaPlayback = true;
        /**
         是否允许自动播放
         */
        t_webView.mediaPlaybackRequiresUserAction = true;
        /**
         设置是否将数据加载如内存后渲染界面
         */
        t_webView.suppressesIncrementalRendering = true;
        /**
         设置用户交互模式
         */
        t_webView.keyboardDisplayRequiresUserAction = true;
        /**
         设置音频播放是否支持ari play功能
         */
        t_webView.mediaPlaybackAllowsAirPlay = true;
        
        
        
        if(m_webView != nil)
        {
            m_webView!.removeFromSuperview();
        }
        
        m_webView = t_webView;
        self.view.addSubview(t_webView);
        
        m_webView!.loadRequest(URLRequest(url: URL(string: "http://www.dadpat.com/dist/dadpat01/details.html?resourceId=" + m_cardId )!));
    }
    
    // TODO:  网页开始加载时候调用
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
    }
    // MARK: 网页加载失败的时候调用
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("didFailLoadWithError")
    }
    // MARK: 网页加载完成时候调用
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        self.context = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        // JS调用了无参数swift方法
        let back: @convention(block) () ->() = {
            self.back();
        }
        self.context!.setObject(unsafeBitCast(back, to: AnyObject.self), forKeyedSubscript: "goofyPapa_back" as NSCopying & NSObjectProtocol);
        
    }
    // TODO: 是网页发起请求前,询问是否可以发起请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    @IBAction func onSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        let direction = sender.direction;
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.right:
//            self.navigationController?.popViewController(animated: true);
            back();
            break;
        default:
            break;
        }
    }
    
    //swift调用js
    func back() {
        DispatchQueue.main.async {
            if( self.m_webView!.canGoBack )
            {
                self.m_webView!.goBack();
            }else{
                self.navigationController?.popViewController(animated: true);
            }
        }
    }

}
