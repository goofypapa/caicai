//
//  DBImageTable.swift
//  DadPat
//
//  Created by 吴思 on 5/11/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import SQLite

struct Image{
    let md5: String;
    let path: String;
}

class DBImageTable: NSObject
{
    static let m_TableName: Table = Table("Image");
    
    static let m_ColumnMD5 = Expression<String>("md5");
    static let m_ColumnPath = Expression<String>("path");
    
    static func create()
    {
        do{
            try DataBase.instance().db!.run(m_TableName.create(ifNotExists: true){
                t in
                t.column(m_ColumnMD5, primaryKey: true);
                t.column(m_ColumnPath);
            });
        }catch {
            print("create table audio fail");
        }
    }
    
    static func drop()
    {
        do{
            try DataBase.instance().db!.run(m_TableName.drop());
        }catch{
            print("drop table image fail");
        }
    }
    
    static func get( p_md5: String ) -> Image?
    {
        var t_result: Image? = nil;
        
        do{
            let t_all = Array(try DataBase.instance().db!.prepare(m_TableName.filter(m_ColumnMD5 == p_md5)));
            if(t_all.count > 0)
            {
                t_result = Image(md5: t_all[0][m_ColumnMD5], path: getFullPath(p_relativePath: t_all[0][m_ColumnPath]) );
            }
        }catch{
            print("get image fail");
        }
        
        return t_result;
    }
    
    static func append( p_image: Image )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.insert( m_ColumnMD5 <- p_image.md5, m_ColumnPath <- p_image.path ) );
        }catch{
            print("append image fail");
        }
    }
    
    static func remove( p_image: Image )
    {
        do{
            
            let fileManager = FileManager.default;
            
            if(fileManager.fileExists(atPath: p_image.path))
            {
                do{
                    try fileManager.removeItem(atPath: p_image.path);
                }catch{
                    print("delete local image file fail");
                }
            }
            
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnMD5 == p_image.md5 ).delete());
            //删除本地文件
            
        }catch{
            print("remove image fail");
        }
    }
    
}
