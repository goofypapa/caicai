//
//  test2ViewController.swift
//  DadPat
//
//  Created by 吴思 on 4/26/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

class Test2ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let t_windowSize: CGSize =  self.view.bounds.size
        
        let t_backgroudImage:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height))
        
        t_backgroudImage.image = UIImage(named: "background")
        t_backgroudImage.isUserInteractionEnabled = true
        
        self.view.addSubview(t_backgroudImage)
        
        let back = UITapGestureRecognizer(target: self, action: #selector(Test2ViewController.back(_:)))
        
        t_backgroudImage.addGestureRecognizer(back)
        
        
        var sourceType = UIImagePickerControllerSourceType.camera
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            sourceType = UIImagePickerControllerSourceType.photoLibrary
            
        }
        
        let picker = UIImagePickerController()

        picker.delegate = self

        picker.allowsEditing = true//设置可编辑

        picker.sourceType = sourceType

        self.present(picker, animated:true, completion:nil)//进入照相界面
    
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        //获得照片
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // 拍照
        if picker.sourceType == .camera {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
            
            
        } else {
            
            print("保存成功")
            
            
        }
    }
    
    @IBAction func back(_ sender:UITapGestureRecognizer)
    {
//        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
