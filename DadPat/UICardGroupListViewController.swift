//
//  CardGroupListViewController.swift
//  DadPat
//
//  Created by 吴思 on 5/4/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

class UICardGroupListViewController : UIViewController
{
 
    var m_columnImageView: UIImageView?;
    var m_scrollView: UIScrollView?;
    private var m_batcheGroup: String = "";
    var m_batcheList: Array<Batche>?;
    
    var m_showClolumn: Int = 2;
    
    var m_batcheViewList: Array<UIView> = Array<UIView>();
    
    var m_cardGroupView: UICardGroupViewController?;
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "batcheGroup":
            let t_batcheGroup = value! as! String;
            if( m_batcheGroup != t_batcheGroup ){
                m_batcheGroup = t_batcheGroup;
                m_batcheList = DBBatcheTable.list(p_group: m_batcheGroup);
                
                loadList(p_column: m_showClolumn);
            }
        default:
            print("not find key: ", key);
        }
    }
    
    
    let m_fileManager = FileManager.default;
    
    init()
    {
        super.init(nibName: nil, bundle: nil);
        
        m_cardGroupView = UICardGroupViewController.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        
        let t_swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(UICardGroupListViewController.onSwipeGesture(_:)));
        self.view.addGestureRecognizer(t_swipeGesture);
        
//        let t_background: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
//        t_background.image = imageWithColor(color: UIColor(red: 157.0 / 255.0, green: 213.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0));
//
//        super.view.addSubview(t_background);
        
        
        //scroll
        let t_scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
        t_scrollView.backgroundColor = UIColor(red: 157.0 / 255.0, green: 213.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0);
        t_scrollView.showsVerticalScrollIndicator = true;
        t_scrollView.bounces = true;
        t_scrollView.alwaysBounceVertical = true;
        
        t_scrollView.contentSize = CGSize(width: t_scrollView.frame.size.width, height: t_scrollView.frame.size.height);
        
        super.view.addSubview(t_scrollView);
        m_scrollView = t_scrollView;
        
        
        
        //back
        let t_backImage: UIImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 32, height: 32));
        t_backImage.image = UIImage(named: "back");
        t_backImage.isUserInteractionEnabled = true;
        t_scrollView.addSubview(t_backImage);
        
        let t_backClickEvent = UITapGestureRecognizer(target: self, action: #selector(UICardGroupListViewController.onBackClicked(_:)));
        
        t_backImage.addGestureRecognizer(t_backClickEvent);

        //column
        let t_columnImage: UIImageView = UIImageView(frame: CGRect(x: t_windowSize.width - 20 - 32, y: 20, width: 32, height: 32));
        t_columnImage.image = UIImage(named: "column2");
        t_columnImage.isUserInteractionEnabled = true;
        
        t_scrollView.addSubview(t_columnImage);
        
        m_columnImageView = t_columnImage;
        
        let t_columnClickEvent = UITapGestureRecognizer(target: self, action: #selector(UICardGroupListViewController.onColumnClicked(_:)));
        
        t_columnImage.addGestureRecognizer(t_columnClickEvent);
        
        
        //title
        let t_titleLabel: UILabel = UILabel(frame: CGRect(x: 30, y: 30, width: t_windowSize.width, height: 100));
        t_titleLabel.text = "动物世界";
        t_titleLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        t_titleLabel.font = UIFont.boldSystemFont(ofSize: 30.0);
        
        t_scrollView.addSubview(t_titleLabel);
        
    }
    
    func loadList( p_column: Int )
    {
        let t_windowSize: CGSize =  self.view.bounds.size;

        let t_spaceWidht: Int = 20;
        let t_imageSize: Int = ( Int(t_windowSize.width) - (p_column + 1) * t_spaceWidht) / p_column;
        let t_nameHeight: Int = 34;
        let t_headHeight = 120;
        
        let t_pageHeight = t_headHeight + m_batcheList!.count / p_column * ( t_imageSize + t_nameHeight );
        
        m_scrollView?.contentSize = CGSize(width: Int(t_windowSize.width), height: t_pageHeight);
        
        for item in m_batcheViewList
        {
            item.removeFromSuperview();
        }
        m_batcheViewList.removeAll();
        
        for (index, item) in m_batcheList!.enumerated()
        {
            let t_offsetX: Int = index % p_column * ( t_imageSize + t_spaceWidht ) + t_spaceWidht;
            let t_offsetY: Int = t_headHeight + index / p_column * ( t_imageSize + t_nameHeight );
            
            print( String(format: "index: %d, point(%d, %d), size(%d, %d)", index, t_offsetX, t_offsetY, t_imageSize, t_imageSize ) );
            
            let t_batcheImage: UIImageView = UIImageView(frame: CGRect(x: t_offsetX, y: t_offsetY, width: t_imageSize, height: t_imageSize));
            
            t_batcheImage.isUserInteractionEnabled = true;
            
            var t_isLocalImage: Bool = false;
            let t_image: Image? = DBImageTable.get(p_md5: item.coverMd5);
            if( t_image != nil ){
                print( "file path:", t_image!.path );
                if( m_fileManager.fileExists(atPath: t_image!.path) ){
                    t_isLocalImage = true;
                }
            }
            
            
            if( t_isLocalImage ){
                t_batcheImage.image = UIImage(contentsOfFile: t_image!.path);
            }else{
                
            }
            
            t_batcheImage.tag = index;
            
            m_scrollView!.addSubview(t_batcheImage);
            
            let t_batcheClickEvent = UITapGestureRecognizer(target: self, action: #selector(UICardGroupListViewController.onBatcheClicked(_:)));
            t_batcheImage.addGestureRecognizer(t_batcheClickEvent);
            
            let t_batcheName: UILabel = UILabel(frame: CGRect(x: t_offsetX, y: t_offsetY + t_imageSize, width: t_imageSize, height: t_nameHeight - 10));
            t_batcheName.text = item.batcheSource;
            t_batcheName.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
            t_batcheName.font = UIFont.boldSystemFont(ofSize: 20.0);
            t_batcheName.textAlignment = NSTextAlignment.center;
            
            m_scrollView!.addSubview(t_batcheName);
            
            m_batcheViewList.append(t_batcheImage);
            m_batcheViewList.append(t_batcheName);
            
        }
        
    }
    
    @IBAction func onBackClicked(_ sender:UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func onBatcheClicked(_ sender:UITapGestureRecognizer)
    {
        m_cardGroupView!.setValue(m_batcheList![sender.view!.tag], forKey: "batche") ;
        self.navigationController?.pushViewController(m_cardGroupView!, animated: true);
    }
    
    @IBAction func onColumnClicked(_ sender:UITapGestureRecognizer)
    {
        m_showClolumn = m_showClolumn == 1 ? 2 : 1;
        m_columnImageView!.image = UIImage(named: m_showClolumn == 1 ? "column1" : "column2");
        loadList(p_column: m_showClolumn);
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
