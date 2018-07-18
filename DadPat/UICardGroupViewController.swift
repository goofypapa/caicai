//
//  CardGroupController.swift
//  DadPat
//
//  Created by 吴思 on 5/17/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

class UICardGroupViewController : UIViewController
{
    
    private var m_batche: Batche?;
    
    private var m_batcheCover: UIImageView?;
    private var m_batcheDesc: UILabel?;
    
    private var m_listOffsetY: Int = 0;
    
    private var m_cardList: Array<Card> = Array<Card>();
    
    private var m_cardImageList: Array<UIView> = Array<UIView>();
    
    private var m_webView: UIWebViewController?;
    
    init()
    {
        super.init(nibName: nil, bundle: nil);
        m_webView = UIWebViewController.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch( key )
        {
        case "batche":
            m_batche = value! as? Batche;
            reloadContent();
        break;
        default:
            print("not find key: ", key);
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        
        let t_swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UICardGroupViewController.onSwipeGesture(_:)));
        self.view.addGestureRecognizer(t_swipeGesture);
        
        let t_background: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
        t_background.image = imageWithColor(color: UIColor(red: 157.0 / 255.0, green: 213.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0));

        super.view.addSubview(t_background);
        
        //back
        let t_backImage: UIImageView = UIImageView(frame: CGRect(x: 20, y: autoAdaptY( p_y: 20 ), width: 32, height: 32));
        t_backImage.image = UIImage(named: "back");
        t_backImage.isUserInteractionEnabled = true;
        self.view.addSubview(t_backImage);
        
        let t_backClickEvent = UITapGestureRecognizer(target: self, action: #selector(UICardGroupViewController.onBackClicked(_:)));
        
        t_backImage.addGestureRecognizer(t_backClickEvent);
        
        
        //批次封面
        let t_batcheImage: Image? = DBImageTable.get(p_md5: m_batche!.coverMd5);
        
        let t_imageSize: Int = ( Int(t_windowSize.width) - 50 ) / 5 * 2;
        let t_batcheCover: UIImageView = UIImageView(frame: CGRect(x: 20, y: autoAdaptY( p_y: 80 ), width: t_imageSize, height: t_imageSize));
        if( t_batcheImage != nil ){
            t_batcheCover.image = UIImage(contentsOfFile: t_batcheImage!.path);
        }
        
        self.view.addSubview(t_batcheCover);
        m_batcheCover = t_batcheCover;
        
        
        //批次介绍
        let t_labelWidth: Int = ( Int(t_windowSize.width) - 50 ) / 5 * 3;
        let t_titleLabel: UILabel = UILabel(frame: CGRect(x: t_imageSize + 30, y: autoAdaptY( p_y: 90 ), width: t_labelWidth, height: 20));
        t_titleLabel.text = "内容简介";
        t_titleLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        t_titleLabel.font = UIFont.systemFont(ofSize: 20.0);
        
        self.view.addSubview(t_titleLabel);
        
        let t_contentLabel: UILabel = UILabel(frame: CGRect(x: t_imageSize + 30, y: autoAdaptY( p_y: 100 ), width: t_labelWidth, height: t_imageSize - 30));
        t_contentLabel.text = m_batche!.batcheDesc;
        t_contentLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        t_contentLabel.font = UIFont.systemFont(ofSize: 14.0);
        t_contentLabel.numberOfLines = 4;
        
        self.view.addSubview(t_contentLabel);
        m_batcheDesc = t_contentLabel;
        
        //卡片预览
        
        let t_spaceLintWidth: Int = (Int(t_windowSize.width) - 160 ) / 2;
        let t_spaceLintLeft: UIImageView = UIImageView(frame: CGRect(x: 30, y: autoAdaptY( p_y: 100 + t_imageSize ), width: t_spaceLintWidth , height: 1));
        t_spaceLintLeft.image = imageWithColor(color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0));
        self.view.addSubview(t_spaceLintLeft);
        
        let t_spaceLintRight: UIImageView = UIImageView(frame: CGRect(x: Int(t_windowSize.width) - 30 - t_spaceLintWidth, y: autoAdaptY( p_y: 100 + t_imageSize ), width: t_spaceLintWidth, height: 1));
        t_spaceLintRight.image = t_spaceLintLeft.image;
        self.view.addSubview(t_spaceLintRight);
        
        let t_spaceLabel: UILabel = UILabel(frame: CGRect(x: 0, y: autoAdaptY( p_y: 85 + t_imageSize ), width: Int(t_windowSize.width), height: 30));
        t_spaceLabel.text = "卡片预览";
        t_spaceLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        t_spaceLabel.font = UIFont.systemFont(ofSize: 18.0);
        t_spaceLabel.textAlignment = NSTextAlignment.center;
        
        self.view.addSubview(t_spaceLabel);
        
        m_listOffsetY = autoAdaptY( p_y: 120 + t_imageSize );
        
        
        let t_bottomOffsetY: Int = Int( t_windowSize.height ) - autoAdaptY( p_y: 50 );
        let t_bottomImage: UIImageView = UIImageView(frame: CGRect(x: 0, y: t_bottomOffsetY , width: Int(t_windowSize.width), height: autoAdaptY( p_y: 50 ) ));
        t_bottomImage.image = imageWithColor(color: UIColor(red: 0xFE / 255.0, green: 0xCF / 255.0, blue: 0x3E / 255.0, alpha: 1.0));
        
        self.view.addSubview(t_bottomImage);
        
        let t_buyLabel: UILabel = UILabel(frame: CGRect(x: 0, y: t_bottomOffsetY, width: Int(t_windowSize.width), height: 50));
        t_buyLabel.text = "点击购买此套卡片";
        t_buyLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 );
        t_buyLabel.font = UIFont.systemFont(ofSize: 20);
        t_buyLabel.textAlignment = NSTextAlignment.center;
        
        self.view.addSubview(t_buyLabel);
        

        reloadContent();
        
    }

    
    @IBAction func onBackClicked(_ sender:UITapGestureRecognizer)
    {
        print("back click");
        self.navigationController?.popViewController(animated: true);
    }
    
    func autoAdaptY( p_y: Int ) -> Int
    {
        let t_windowSize: CGSize =  self.view.bounds.size;
        
        let t_headHeight = t_windowSize.height == 812.0 ? 40 : 10;
        
        return t_headHeight + p_y;
    }
    
    func reloadContent()
    {
        if( m_batcheCover != nil && m_batcheDesc != nil )
        {
            let t_batcheImage: Image? = DBImageTable.get(p_md5: m_batche!.coverMd5);
            if( t_batcheImage != nil ){
                m_batcheCover!.image = UIImage(contentsOfFile: t_batcheImage!.path);
            }
            
            m_batcheDesc!.text = m_batche!.batcheDesc;
            
            m_cardList = DBCardTable.list(p_batcheId: m_batche!.batcheId);
            
            let t_column: Int = 4;
            let t_windowSize: CGSize =  self.view.bounds.size;
            
            let t_spaceWidth = 20;
            let t_imageWidth = ( Int(t_windowSize.width ) - t_spaceWidth * (t_column + 1) ) / t_column;
            
            for item: UIView in m_cardImageList
            {
                item.removeFromSuperview();
            }
            m_cardImageList.removeAll();
            
            for (index, item) in m_cardList.enumerated()
            {
                let t_cardCover: UIImageView = UIImageView(frame: CGRect(x: index % t_column * (t_spaceWidth + t_imageWidth) + t_spaceWidth, y: m_listOffsetY + index / t_column * (t_spaceWidth + t_imageWidth), width: t_imageWidth, height: t_imageWidth));
                
                let t_image: Image? = DBImageTable.get(p_md5: (item.activation ? item.coverMD5 : item.lineDrawingMD5) );
   
                if( t_image != nil ){
                    t_cardCover.image = UIImage(contentsOfFile: t_image!.path);
                }else{
                    t_cardCover.image = UIImage(named: "defaultCard");
                }
                t_cardCover.isUserInteractionEnabled = true;
                t_cardCover.tag = index;
                
                let t_cardClickEvent = UITapGestureRecognizer(target: self, action: #selector(UICardGroupViewController.onCardClicked(_:)));
                t_cardCover.addGestureRecognizer(t_cardClickEvent);
                
                self.view.addSubview(t_cardCover);
                m_cardImageList.append(t_cardCover);

            }
            
        }
    }
    
    @IBAction func onCardClicked(_ sender:UITapGestureRecognizer)
    {
        print("Card click ", sender.view!.tag);
        m_webView!.setValue(m_cardList[sender.view!.tag].serviceId, forKey: "cardId") ;
        self.navigationController?.pushViewController(m_webView!, animated: true);
    }
    
    @IBAction func onSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        let direction = sender.direction;
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.right:
            self.navigationController?.popViewController(animated: true);
            break;
        default:
            break;
        }
    }
    
}
