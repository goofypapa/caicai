//
//  UIImageViewGIF.swift
//  DadPat
//
//  Created by 吴思 on 5/10/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import QuartzCore

class UIImageViewGIF : UIView {
    
    var width:CGFloat{return self.frame.size.width}
    var height:CGFloat{return self.frame.size.height}
    
    private var gifUrl:NSURL!
    
    private var totalTime:Float = 0 // GIF动画时间
    
    private var imageArray:Array<CGImage> = [] // CGImage数组（存放每一帧的图片）
    private var timeArray:Array<NSNumber> = [] // DelayTime数组（存放每一帧的图片的时间）
    
    // 加载本地GIF图片
    func showGIFImageWithLocalName(name:String) {
        gifUrl = Bundle.main.url(forResource: name, withExtension: "gif")! as NSURL
        self.creatFrame()
    }
    
    // 加载网络端的GIF图片
    func showGIFImageFromNetWork(url:NSURL) {
        let fileName = self.getMD5StringFromString(string: url.absoluteString!)
        let filePath = NSHomeDirectory()+"/Library/Caches/UIImageViewGIF/" + fileName + ".gif"
        if FileManager.default.fileExists(atPath: filePath) {
            self.gifUrl = NSURL(fileURLWithPath: filePath)
            self.creatFrame()
        } else {
            let session = URLSession.shared
            let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    let path = NSURL(fileURLWithPath: filePath)
                    do {
                        try data?.write(to: path as URL)
                        self.gifUrl = NSURL(fileURLWithPath: filePath)
                        self.creatFrame()
                    } catch {
                        
                    }
                }
            })
            task.resume()
        }
    }
    
    // 获取GIF图片的每一帧
    func creatFrame() {
        let url:CFURL = gifUrl as CFURL
        let gifSource  = CGImageSourceCreateWithURL(url, nil) // GIF所有资源
        let imageCount = CGImageSourceGetCount(gifSource!) // GIF图片个数
        
        for i in 0..<imageCount { // 获取每一帧图片
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil)
            imageArray.append(imageRef!)
            
            // 解析每一帧图片
            let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as NSDictionary?
            
            // 获取图片的尺寸 (适应长宽比)
            let imageWidth = sourceDict![String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = sourceDict![String(kCGImagePropertyPixelHeight)] as! NSNumber
            if imageWidth.floatValue/imageHeight.floatValue != Float(width/height) {
                self.fitSacle(imageWidth: CGFloat(truncating: imageWidth), imageHeight: CGFloat(truncating: imageHeight))
            }
            
            let gifDict = sourceDict![String(kCGImagePropertyGIFDictionary)] as! NSDictionary
            let time = gifDict[String(kCGImagePropertyGIFDelayTime)] as! NSNumber
            timeArray.append(time)
            totalTime += time.floatValue
        }
        self.showAnimation()
    }
    
    // 展示动画
    func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []
        
        for time in timeArray {
            timeKeys.append(NSNumber(floatLiteral: Double(current/totalTime)))
            current += time.floatValue
        }
        
        animation.keyTimes = timeKeys
        animation.values = imageArray
        animation.repeatCount = HUGE;
        animation.duration = TimeInterval(totalTime)
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "UIImageViewGIF")
        
    }
    
    // 将string转为MD5
    func getMD5StringFromString(string:String) -> String {
        let str = string.cString(using: .utf8)
        let strlen = CC_LONG(string.lengthOfBytes(using: .utf8))
        let digeTlen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digeTlen)
        CC_MD5(str!, strlen, result)
        let hash = NSMutableString()
        for i in 0..<digeTlen {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash as String)
    }
    
    // 清除图片缓存方法
    func cleanCache() {
        let folderPath = NSHomeDirectory()+"/Library/Caches/UIImageViewGIF/"
        let manager = FileManager.default
        do {
            let fileName = try? manager.contentsOfDirectory(atPath: folderPath)
            for name in fileName! {
                try manager.removeItem(atPath: folderPath+name)
            }
        } catch {
            
        }
    }
    
    // 适应长宽比
    func fitSacle(imageWidth:CGFloat, imageHeight:CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWidth/imageHeight > width/height {
            newHeight = width/(imageWidth/imageHeight)
            newWidth = width
        } else {
            newWidth = height*(imageWidth/imageHeight)
            newHeight = height
        }
        let point:CGPoint = self.center
        self.frame.size = CGSize(width: newWidth, height: newHeight)
        self.center = point
    }
}
