//
//  Http.swift
//  DadPat
//
//  Created by 吴思 on 5/7/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation

class Http: NSObject
{
    static let ServiceUrl: String = "http://www.dadpat.com";
    static func Get(p_url: String,success: @escaping ((_ p_url: String, _ result: String) -> ()),failure: @escaping ((_ p_url: String, _ error: Error) -> ()))
    {
        
        let url = URL(string: (ServiceUrl as NSString).appendingPathComponent(p_url).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            
            if let data = data {
                
                if let result = String(data:data,encoding:.utf8){
                    success(p_url, result);
                }
            }else {
                failure(p_url, error!);
            }
        }
        dataTask.resume()
    }
    
    static func Download(p_url: String, p_folder: String, p_tag: NSObject, p_onDownloadEnd: ((_ p_tag: NSObject, _ p_filePath: String)->())?, p_onSpeedChanged: ((_ p_tag: NSObject, _ p_filePath: String, _ p_speed: Float)->())?)
    {
        DownloadFile(p_url: (ServiceUrl as NSString).appendingPathComponent(p_url), p_folder: p_folder, p_tag: p_tag, p_onDownloadEnd: p_onDownloadEnd, p_onSpeedChanged: p_onSpeedChanged).start();
    }
    
}
