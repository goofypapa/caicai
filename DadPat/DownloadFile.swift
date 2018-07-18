//
//  DownloadFile.swift
//  DadPat
//
//  Created by 吴思 on 5/8/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation

class DownloadFile: NSObject, URLSessionDownloadDelegate
{
 
    let m_dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last;

    private lazy var m_session:URLSession = {
        //只执行一次
        let config = URLSessionConfiguration.default
        let currentSession = URLSession(configuration: config, delegate: self,
                                        delegateQueue: nil)
        return currentSession
        
    }();
    
    private let m_onDownloadEnd: ((_ p_tag: NSObject, _ p_filePath: String)->())?;
    private let m_onSpeedChanged: ((_ p_tag: NSObject, _ p_filePath: String, _ p_speed: Float)->())?;
    private let m_tag: NSObject;
    private let m_url: String;
    private let m_folder: String;
    
    init( p_url: String, p_folder: String, p_tag: NSObject, p_onDownloadEnd: ((_ p_tag: NSObject, _ p_filePath: String)->())?, p_onSpeedChanged: ((_ p_tag: NSObject, _ p_filePath: String, _ p_speed: Float)->())?)
    {
        m_onDownloadEnd = p_onDownloadEnd;
        m_onSpeedChanged = p_onSpeedChanged;
        m_tag = p_tag;
        m_url = p_url;
        m_folder = p_folder;
        super.init();
    }
    
    func start()
    {
        let t_url: URL? = URL(string: m_url);
        if( t_url == nil )
        {
            print("url flaw");
            return;
        }
        let t_request: URLRequest = URLRequest(url: t_url!);
        
        let t_downloadTask = m_session.downloadTask(with: t_request);
        
        t_downloadTask.resume();
    }
    
    //下载代理方法，下载结束
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        let t_tempPath = location.path;
        
        let t_fileName = String(m_url.split(separator: "/").last!);
        
        let t_folderPath = (m_dicumentPath! as NSString).appendingPathComponent(m_folder);
        
        let t_relativePath = (m_folder as NSString).appendingPathComponent(t_fileName)
        
        let t_localPath = (m_dicumentPath! as NSString).appendingPathComponent(t_relativePath);
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: t_folderPath))
        {
            do{
                try fileManager.createDirectory(atPath: t_folderPath, withIntermediateDirectories: true, attributes: nil);
            }catch{
                print("create directory fail");
            }
        }
        
        if(fileManager.fileExists(atPath: t_localPath))
        {
            do{
                try fileManager.removeItem(atPath: t_localPath);
            }catch{
                print("delete file fail");
            }
        }
        
        try! fileManager.moveItem(atPath: t_tempPath, toPath: t_localPath);
        
        if( m_onDownloadEnd != nil )
        {
            m_onDownloadEnd!( m_tag, t_relativePath );
        }
    }
    
    //下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
    }
    
    //下载代理方法，下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }

}
