//
//  Common.swift
//  DadPat
//
//  Created by 吴思 on 5/16/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import UIKit

let m_dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last;

func imageWithColor(color:UIColor) -> UIImage
{
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(rect);
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

func getFullPath( p_relativePath: String ) -> String
{
    return (m_dicumentPath! as NSString).appendingPathComponent(p_relativePath);
}
