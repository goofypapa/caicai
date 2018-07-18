//
//  testControlView.swift
//  DadPat
//
//  Created by 吴思 on 4/26/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

class UIMainViewController : UIViewController
{
    
    var t_test2 : UIViewController?;
    private var m_blueManager: BlueManager?;
    private var m_cardGroupList: UICardGroupListViewController?;

    init()
    {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
//        let url = URL(string: "App-Prefs:root=Bluetooth")
//        if UIApplication.shared.canOpenURL(url!) {
//            UIApplication.shared.open(url!, options: [:]){ (res) in
//                print(res);
//            }
//        }
        
        
        t_test2 = Test2ViewController.init();
        
        m_blueManager = BlueManager.init();
        
        m_cardGroupList = UICardGroupListViewController.init();
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        
        let t_isIPhoneX = (t_windowSize.height == 812.0);
        
        let t_backgroudImage: UIImageView, t_logo: UIImageView, t_blueState: UIImageView, t_menuAnimal: UIImageView, t_menuSong: UIImageView, t_menuEnglish: UIImageView, t_menuMap: UIImageView, t_menuPlant: UIImageView, t_menuBook: UIImageView, t_mainBottom: UIImageView;
        
        
        //--------------------------------布局适配 开始
        
        if(t_isIPhoneX)
        {
            //iphoneX
            //背景图片
            t_backgroudImage = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
            
            t_backgroudImage.image = UIImage(named: "background_X");
            
            //logo
            let t_logoSize:CGSize = CGSize(width: 140, height: 42);
            t_logo = UIImageView(frame: CGRect(x: (t_windowSize.width - t_logoSize.width) / 2, y: 44, width: t_logoSize.width, height: t_logoSize.height));
            
            //blue
            let t_blueStateSize: CGSize = CGSize(width: 32, height: 38);
            t_blueState = UIImageView(frame: CGRect(x: t_windowSize.width - t_blueStateSize.width - 20, y: 44, width: t_blueStateSize.width, height: t_blueStateSize.height));
            
            //menu
            
            //menu_animal
            t_menuAnimal = UIImageView(frame: CGRect(x: 3, y: 168, width: 132, height: 132));
            
            //menu_song
            t_menuSong = UIImageView(frame: CGRect(x: 141, y: 226, width: 97, height: 97));
            
            //menu_english
            t_menuEnglish = UIImageView(frame: CGRect(x: 240, y: 255, width: 130, height: 130));
            
            //menu_map
            t_menuMap = UIImageView(frame: CGRect(x: 66, y: 310, width: 106, height: 106));
            
            //menu_plant
            t_menuPlant = UIImageView(frame: CGRect(x: 180, y: 382, width: 98, height: 98));
            
            //menu_book
            t_menuBook = UIImageView(frame: CGRect(x: 105, y: 440, width: 74, height: 74));
            
            //main_bottom
            let t_mainBottomSize: CGSize = CGSize(width: 344, height: 180);
            t_mainBottom = UIImageView(frame: CGRect(x: (t_windowSize.width - t_mainBottomSize.width) / 2, y: t_windowSize.height - t_mainBottomSize.height - 50, width: t_mainBottomSize.width, height: t_mainBottomSize.height));
            
        }else{
            //iphone 5 6 7 8(plus)
            //背景图片
            t_backgroudImage = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
            
            t_backgroudImage.image = UIImage(named: "background");
            
            //logo
            let t_logoSize:CGSize = CGSize(width: t_windowSize.width * 0.32, height: t_windowSize.height * 0.06);
            t_logo = UIImageView(frame: CGRect(x: (t_windowSize.width - t_logoSize.width) / 2, y: t_windowSize.height * 0.04, width: t_logoSize.width, height: t_logoSize.height));
            
            //blue
            let t_blueStateSize: CGSize = CGSize(width: t_windowSize.width * 0.078, height: t_windowSize.height * 0.05);
            t_blueState = UIImageView(frame: CGRect(x: t_windowSize.width - t_blueStateSize.width - t_windowSize.height * 0.027, y: t_windowSize.height * 0.04, width: t_blueStateSize.width, height: t_blueStateSize.height));
            
            //menu
            
            //menu_animal
            t_menuAnimal = UIImageView(frame: CGRect(x: t_windowSize.width * 0.06, y: t_windowSize.height * 0.22, width: t_windowSize.width * 0.32, height: t_windowSize.width * 0.32));
            
            //menu_song
            t_menuSong = UIImageView(frame: CGRect(x: t_windowSize.width * 0.39, y: t_windowSize.height * 0.3, width: t_windowSize.width * 0.24, height: t_windowSize.width * 0.24));
            
            //menu_english
            t_menuEnglish = UIImageView(frame: CGRect(x: t_windowSize.width * 0.63, y: t_windowSize.height * 0.34, width: t_windowSize.width * 0.31, height: t_windowSize.width * 0.31));
            
            //menu_map
            t_menuMap = UIImageView(frame: CGRect(x: t_windowSize.width * 0.21, y: t_windowSize.height * 0.42, width: t_windowSize.width * 0.26, height: t_windowSize.width * 0.26));
            
            //menu_plant
            t_menuPlant = UIImageView(frame: CGRect(x: t_windowSize.width * 0.48, y: t_windowSize.height * 0.51, width: t_windowSize.width * 0.24, height: t_windowSize.width * 0.24));
            
            //menu_book
            t_menuBook = UIImageView(frame: CGRect(x: t_windowSize.width * 0.3, y: t_windowSize.height * 0.59, width: t_windowSize.width * 0.18, height: t_windowSize.width * 0.18));
            
            //main_bottom
            let t_mainBottomSize: CGSize = CGSize(width: t_windowSize.width * 0.83, height: t_windowSize.height * 0.24);
            t_mainBottom = UIImageView(frame: CGRect(x: (t_windowSize.width - t_mainBottomSize.width) / 2, y: t_windowSize.height - t_mainBottomSize.height - t_windowSize.height * 0.025, width: t_mainBottomSize.width, height: t_mainBottomSize.height));
        }
        
        //---------------------------------------布局适配 结束
        
        //background
        self.view.addSubview(t_backgroudImage);
        
        
        //logo
        t_logo.image = UIImage(named: "logo");
        
        self.view.addSubview(t_logo);
        
        //blueState
        t_blueState.image = UIImage(named: "blueStateNoConnected");
        t_blueState.isUserInteractionEnabled = true;
        self.view.addSubview(t_blueState);
        
        let t_blueClickEvent = UITapGestureRecognizer(target: self, action: #selector(UIMainViewController.on_blueStateClicked(_:)));
        
        t_blueState.addGestureRecognizer(t_blueClickEvent);
        
        //menu
        
        //menu_animal
        t_menuAnimal.image = UIImage(named: "menu_animal");
        t_menuAnimal.isUserInteractionEnabled = true;
        
        self.view.addSubview(t_menuAnimal);
        
        let t_menuAnimalClickEvent = UITapGestureRecognizer(target: self, action: #selector(UIMainViewController.onMenuAnimalClicked(_:)));
        t_menuAnimal.addGestureRecognizer(t_menuAnimalClickEvent);
        
        //menu_song
        t_menuSong.image = UIImage(named: "menu_song");
        
        self.view.addSubview(t_menuSong);
        
        //menu_english
        t_menuEnglish.image = UIImage(named: "menu_english");
        
        self.view.addSubview(t_menuEnglish);
        
        //menu_map
        t_menuMap.image = UIImage(named: "menu_map");
        
        self.view.addSubview(t_menuMap);
        
        //menu_plant
        t_menuPlant.image = UIImage(named: "menu_plant");
        
        self.view.addSubview(t_menuPlant);
        
        //menu_book
        t_menuBook.image = UIImage(named: "menu_book");
        
        self.view.addSubview(t_menuBook);
        
        
        //main_bottom
        t_mainBottom.image = UIImage(named: "main_bottom");
        
        self.view.addSubview(t_mainBottom);
        
    }
    
    
    @IBAction func on_blueStateClicked(_ sender:UITapGestureRecognizer)
    {
        print("blueState click");
        self.navigationController?.pushViewController(t_test2!, animated: true);
    }
    
    @IBAction func onMenuAnimalClicked(_ sender:UITapGestureRecognizer)
    {
        print("menuAnimal click");
        m_cardGroupList!.setValue("animal", forKey: "batcheGroup");
        self.navigationController?.pushViewController(m_cardGroupList!, animated: true);
    }
    
    
}
