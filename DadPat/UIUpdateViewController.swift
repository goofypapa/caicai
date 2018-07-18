//
//  UpdateViewController.swift
//  DadPat
//
//  Created by 吴思 on 5/7/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit


struct DownloadTask
{
    let url: String;
    let md5: String;
    let folder: String;
    var image: Image?;
    var audio: Audio?;
}

class DownloadTaskObj: NSObject
{
    public var downloadTask: DownloadTask;
    
    init( p_downloadTask: DownloadTask )
    {
        downloadTask = p_downloadTask;
    }
}

class UIUpdateViewController : UIViewController
{
    static let batcheCoverFolder: String = "Image/Batche";
    static let downloadPipe: Int = 5;
    let m_dataBase: DataBase = DataBase.instance();
    var m_requests: [String] = [String]();
    var m_downloadList: Array<DownloadTask> = Array<DownloadTask>();
    
    var m_downloadIndex: Int = 0;
    var m_downloadedCount: Int = 0;
    
    var m_message: UILabel? = nil;
    
    var m_mainView: UIMainViewController? = nil;
    
    let m_fileManager = FileManager.default;
    
    init()
    {
        super.init(nibName: nil, bundle: nil);
        
        if( !m_dataBase.openDB() )
        {
            print("open DB fail");
            return;
        }
        
        self.m_mainView = UIMainViewController.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let t_windowSize: CGSize =  self.view.bounds.size;
        
        let t_background: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: t_windowSize.width, height: t_windowSize.height));
        t_background.image = imageWithColor(color: UIColor(red: 157.0 / 255.0, green: 213.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0));

        super.view.addSubview(t_background);
        
        let t_loading: UIImageViewGIF = UIImageViewGIF(frame: CGRect(x: (t_windowSize.width - 120 ) / 2, y: (t_windowSize.height - 120) / 2.5, width: 120, height: 120));
        t_loading.showGIFImageWithLocalName(name: "loading");
        
        super.view.addSubview(t_loading);
        
        let t_message: UILabel = UILabel(frame: CGRect(x: 0, y: (t_windowSize.height - 120) / 2.5 + 120, width: t_windowSize.width, height: 50));

        t_message.text = "check update";
        t_message.textColor = UIColor(white: 1.0, alpha: 1.0);
        t_message.textAlignment = NSTextAlignment.center;
        t_message.font = UIFont.systemFont(ofSize: 30.0);
        
        super.view.addSubview(t_message);
        
        m_message = t_message;
        
        updateBatche();
    }
    
    func updateBatche()
    {
        let t_url: String = "/resource/batch/list/summary.do";
        m_requests.append(t_url);
        Http.Get(p_url: t_url, success: { (p_url: String, response: String) in
            
            let jsonData = response.data(using: String.Encoding.utf8)!;
            let decoder = JSONDecoder();
            do
            {
                let t_json: serviceBatchListSummaryResponse = try decoder.decode(serviceBatchListSummaryResponse.self, from: jsonData);
                if( !t_json.success ){
                    print( p_url, " response ", t_json.success );
                    self.urlResponse(p_url: p_url);
                    return;
                }
                
                var t_batcheList: Array<Batche> = DBBatcheTable.list(p_group: "animal");
                
                for item in t_json.data {
                    
                    var t_exist: Bool = false;
                    
                    let t_batche: Batche = Batche(batcheId: item.batchId, batcheSource: item.batchSource, batcheDesc: (item.batchDesc == nil ? "" : item.batchDesc!), coverMd5: item.coverMd5, group: "animal", activation: false);
                    
                    for (index, t_item) in t_batcheList.enumerated()
                    {
                        if( t_item.batcheId == t_batche.batcheId ){
                            t_exist = true;
                            
                            if( t_item.batcheSource != t_batche.batcheSource ||
                                t_item.batcheDesc != t_batche.batcheDesc ||
                                t_item.coverMd5 != t_batche.coverMd5 ||
                                t_item.group != t_batche.group )
                            {
                                //如果是图片改变
                                if( t_item.coverMd5 != t_batche.coverMd5 )
                                {
                                    //删除旧图片
                                    let t_image: Image? = DBImageTable.get(p_md5: t_item.coverMd5);
                                    
                                    if(t_image != nil)
                                    {
                                        DBImageTable.remove(p_image: t_image!);
                                    }
                                }
                                
                                //更新批次信息
                                DBBatcheTable.update( p_batche: t_batche );
                            }
                            
                            t_batcheList.remove(at: index);
                            break;
                        }
                    }
                    
                    if( !t_exist ){
                        DBBatcheTable.append(p_batche: t_batche );
                    }
                    
                    //下载图片 不下载本地已有素材
                    let t_image: Image? = DBImageTable.get(p_md5: t_batche.coverMd5);
                    
                    var t_needDownload: Bool = t_image == nil;
                    
                    if( t_image != nil )
                    {
                        if( self.m_fileManager.fileExists(atPath: t_image!.path) )
                        {
                            t_needDownload = false;
                        }
                    }
                    
                    if( t_needDownload ){
                        self.m_downloadList.append(DownloadTask(url: item.coverImage, md5: t_batche.coverMd5, folder: UIUpdateViewController.batcheCoverFolder, image: Image(md5: t_batche.coverMd5, path: ""), audio: nil));
                    }
                }
                
                //删除本地多余批次
                for item in t_batcheList
                {
                    let t_image: Image? = DBImageTable.get(p_md5: item.coverMd5);
                    
                    if(t_image != nil)
                    {
                        DBImageTable.remove(p_image: t_image!);
                    }
                    
                    //删除数据库数据
                    DBBatcheTable.remove(p_batcheId: item.batcheId);
                }
                
            }catch let err as NSError{
                print( err.description );
            }
            
            
            DispatchQueue.main.async {
                let t_localBatcheList: Array<Batche> = DBBatcheTable.list(p_group: "animal");

                for item in t_localBatcheList.enumerated()
                {
                    self.updateCard(p_batcheId: item.element.batcheId);
                }
                
                self.urlResponse(p_url: p_url);
            }
            
        }, failure: { (p_url: String, err: Error) in
            print(err);
            DispatchQueue.main.async {
                self.urlResponse(p_url: p_url);
            }
        });
    }
    
    func updateCard( p_batcheId: String )
    {
        let t_url: String = "/resource/card/list.do?batchId=" + p_batcheId;
        
        print( t_url );
        
        m_requests.append(t_url);
        
        Http.Get(p_url: t_url, success: { (p_url: String, response: String) in
            
            let jsonData = response.data(using: String.Encoding.utf8)!;
            let decoder = JSONDecoder();
            do
            {
                let t_json: serviceCardListResponse = try decoder.decode(serviceCardListResponse.self, from: jsonData);
                if( !t_json.success ){
                    print( p_url, " response ", t_json.success );
                    self.urlResponse(p_url: p_url);
                    return;
                }
                
                var t_cardList: Array<Card> = Array<Card>();
                
                for (index, item) in t_json.data.enumerated()
                {
                    if( index == 0 ){
                        t_cardList = DBCardTable.list(p_batcheId: item.ownerId);
                    }
                    
                    let t_card: Card = Card(id: item.rfId, serviceId: item.resourceId, coverMD5: item.coverImage == nil ? "" : item.coverImage!.md5 , lineDrawingMD5: item.handDrawImage == nil ? "" : item.handDrawImage!.md5, batcheId: item.ownerId, activation: false);
                    
                    var t_localCard: Card? = nil;
                    var t_localCardIndex: Int = 0;
                    for item in t_cardList.enumerated()
                    {
                        if( t_card.id == item.element.id ){
                            t_localCardIndex = item.offset;
                            t_localCard = item.element;
                            break;
                        }
                    }
                    
                    if( t_localCard == nil )
                    {
                        DBCardTable.append(p_card: t_card);
                    }else{
                        
                        //更新本地卡片信息
                        if( t_localCard!.serviceId != t_card.serviceId || t_localCard!.coverMD5 != t_card.coverMD5 || t_localCard!.batcheId != t_card.batcheId || t_localCard!.lineDrawingMD5 != t_card.lineDrawingMD5 ){
                            DBCardTable.update(p_card: t_card);
                        }
                        
                        //删除旧封面
                        if( t_localCard!.coverMD5 != t_card.coverMD5 ){
                            print("===============old: %s, new: %s", t_localCard!.coverMD5, t_card.coverMD5 );
                            let t_image: Image? = DBImageTable.get(p_md5: t_localCard!.coverMD5);
                            if( t_image != nil ){
                                DBImageTable.remove(p_image: t_image!);
                            }
                        }
                        
                        //删除旧简笔画
                        if( t_localCard!.lineDrawingMD5 != t_card.lineDrawingMD5 ){
                            let t_image: Image? = DBImageTable.get(p_md5: t_localCard!.lineDrawingMD5);
                            if( t_image != nil ){
                                DBImageTable.remove(p_image: t_image!);
                            }
                        }
                        
                        // 更新音频
                        if( t_localCard!.activation )
                        {
                            var t_audioList: Array<Audio> = DBAudioTable.list(p_cardId: t_localCard!.id);
                            var t_newAudioList: Array<DownloadTask> = Array<DownloadTask>();
                            if( item.audios != nil ){
                                
                                for audioItem in item.audios!
                                {
                                    t_newAudioList.append( DownloadTask(url: audioItem.attUrl, md5: audioItem.md5, folder: "Card/" + t_card.serviceId + "/Audio", image: nil, audio: Audio(id: 0, cardId: item.rfId, md5: audioItem.md5, type: 0, path: "")) );
                                }
                            }
                            
                            if( item.pronAudio != nil ){
                                t_newAudioList.append( DownloadTask(url: item.pronAudio!.attUrl, md5: item.pronAudio!.md5, folder: "Card/" + t_card.serviceId + "/Audio", image: nil, audio: Audio(id: 0, cardId: item.rfId, md5: item.pronAudio!.md5, type: 0, path: "")) );
                            }
                            
                            if( item.descAudio != nil ){
                                t_newAudioList.append( DownloadTask(url: item.descAudio!.attUrl, md5: item.descAudio!.md5, folder: "Card/" + t_card.serviceId + "/Audio", image: nil, audio: Audio(id: 0, cardId: item.rfId, md5: item.descAudio!.md5, type: 0, path: "")) );
                            }
                            
                            
                            for downloadTask in t_newAudioList{
                                var t_isExit: Bool = false;
                                for localAudioItem in t_audioList.enumerated()
                                {
                                    if( localAudioItem.element.md5 == downloadTask.audio!.md5 ){
                                        
                                        //找不到文件
                                        if( !self.m_fileManager.fileExists(atPath: localAudioItem.element.path) ){
                                            break;
                                        }
                                        
                                        t_isExit = true;
                                        t_audioList.remove(at: localAudioItem.offset);
                                        break;
                                    }
                                }
                                if( !t_isExit ){
                                    // 下载音频
                                    self.m_downloadList.append(downloadTask);
                                }
                            }
                            
                            //删除无用音频
                            for localAudio in t_audioList{
                                DBAudioTable.remove(p_audio: localAudio);
                            }
                            
                        }
                        
                        t_cardList.remove(at: t_localCardIndex);
                    }
                    
                    //下载封面图片
                    let t_image: Image? = DBImageTable.get(p_md5: t_card.coverMD5);
                    if( t_card.coverMD5 != "" && t_image == nil ){
                        self.m_downloadList.append(DownloadTask(url: item.coverImage!.attUrl, md5: t_card.coverMD5, folder: "Card/" + t_card.serviceId + "/Image", image: Image(md5: item.coverImage!.md5, path: ""), audio: nil));
                    }
                    
                    //下载简笔画
                    let t_lineDrawing: Image? = DBImageTable.get(p_md5: t_card.lineDrawingMD5);
                    if( t_card.lineDrawingMD5 != "" && t_lineDrawing == nil ){
                        self.m_downloadList.append(DownloadTask(url: item.handDrawImage!.attUrl, md5: t_card.lineDrawingMD5, folder: "Card/" + t_card.serviceId + "/Image", image: Image(md5: item.handDrawImage!.md5, path: ""), audio: nil));
                    }
                }
                
                self.urlResponse(p_url: p_url);
            }catch let err as NSError{
                print( err.description );
                self.urlResponse(p_url: p_url);
            }
        }, failure: { (p_url: String, err: Error) in
            print(err);
            self.urlResponse(p_url: p_url);
        });
    }
    
    func urlResponse( p_url: String )
    {
        let t_index: Int? = self.m_requests.index(of: p_url);
        if(t_index != nil )
        {
            self.m_requests.remove(at: t_index!);
        }
        
        if(self.m_requests.isEmpty)
        {
            DispatchQueue.main.async {
                
                if( self.m_downloadList.count > 0 ){
                    self.m_message!.text = "before download";
                    //download file
                    self.startDownload();
                }else{
                    self.m_message!.text = "no download";
                    self.navigationController?.pushViewController(self.m_mainView!, animated: true);
                }
            }
        }
    }
    
    func startDownload()
    {
        for _ in 0...(UIUpdateViewController.downloadPipe - 1 < m_downloadList.count ? UIUpdateViewController.downloadPipe - 1 : m_downloadList.count )
        {
            download();
        }
    }
    
    func download()
    {
        if( m_downloadIndex >= m_downloadList.count  ){
            return;
        }
        let t_downloadTask: DownloadTask = m_downloadList[ m_downloadIndex ];
        m_downloadIndex += 1;
        Http.Download(p_url: t_downloadTask.url, p_folder: t_downloadTask.folder, p_tag: DownloadTaskObj(p_downloadTask: t_downloadTask), p_onDownloadEnd: { (p_tag: NSObject, p_filePath: String) in
            
            DispatchQueue.main.async {
                
                let t_fileMD5: String? = self.md5File(url: URL(string: getFullPath( p_relativePath: p_filePath) )! );
                let t_downloadTask: DownloadTask = (p_tag as! DownloadTaskObj).downloadTask;
                
                if( t_fileMD5 != nil && t_fileMD5! == t_downloadTask.md5 ){
                    
                    print("download md5: ", t_downloadTask.md5);
                    
                    //下载成功
                    if( t_downloadTask.image != nil )
                    {
                        DBImageTable.append(p_image: Image(md5: t_downloadTask.md5, path: p_filePath) )
                    }
                    
                    if( t_downloadTask.audio != nil )
                    {
                        DBAudioTable.append(p_audio: Audio(id: 0, cardId: t_downloadTask.audio!.cardId, md5: t_downloadTask.audio!.md5, type: t_downloadTask.audio!.type, path: p_filePath));
                    }
                }
                
                self.m_downloadedCount += 1;
                
                self.m_message!.text = String(format: "downloading %.2f", Float(self.m_downloadedCount) / Float(self.m_downloadList.count) * 100.0) + "%";
                
                if( self.m_downloadedCount == self.m_downloadList.count ){
                    self.m_message!.text = "download success";
                    self.navigationController?.pushViewController(self.m_mainView!, animated: true);
                }else{
                    self.download();
                }
            }
            //下载结束处理
        }) { (p_tag: NSObject, p_filePath: String, p_speed: Float) in
            //下载进度更新
        }
    }
    
    func md5File(url: URL) -> String? {
        
        let bufferSize = 1024 * 1024
        
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            //初始化内容
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
            
            //计算Md5摘要
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &context)
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
            
        } catch {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
    }
}
