//
//  DBAudioTable.swift
//  DadPat
//
//  Created by 吴思 on 5/11/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import SQLite

struct Audio
{
    let id: Int;
    let cardId: Int;
    let md5: String;
    let type: Int;
    let path: String;
}

class DBAudioTable: NSObject
{
    static let m_TableName: Table = Table("Audio");
    
    static let m_ColumnId = Expression<Int>("id");
    static let m_ColumnCardId = Expression<Int>("cardId");
    static let m_ColumnMD5 = Expression<String>("md5");
    static let m_ColumnAudioType = Expression<Int>("audioType");
    static let m_ColumnPath = Expression<String>("path");
    
    static func create()
    {
        
        do{
            try DataBase.instance().db!.run(m_TableName.create(ifNotExists: true){
                t in
                t.column(m_ColumnId, primaryKey: .autoincrement);
                t.column(m_ColumnCardId);
                t.column(m_ColumnMD5);
                t.column(m_ColumnAudioType);
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
            print("drop table audio fail");
        }
    }
    
    static func list( p_cardId: Int ) -> Array<Audio>
    {
        var t_result: Array<Audio> = Array<Audio>();
        do{
            let t_all = Array(try DataBase.instance().db!.prepare(m_TableName.filter(m_ColumnCardId == p_cardId)));
            for t_item in t_all
            {
                t_result.append( Audio(id: t_item[m_ColumnId], cardId: t_item[m_ColumnCardId], md5: t_item[m_ColumnMD5], type: t_item[m_ColumnAudioType], path: getFullPath(p_relativePath: t_item[m_ColumnPath]) ) );
            }
        }catch{
            print("get audio list fail");
        }
        return t_result;
    }
    
    static func append( p_audio: Audio )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.insert( m_ColumnCardId <- p_audio.cardId, m_ColumnMD5 <- p_audio.md5, m_ColumnAudioType <- p_audio.type, m_ColumnPath <- p_audio.path ) );
        }catch{
            print("append audio fail");
        }
    }
    
    static func remove( p_audio: Audio )
    {
        do{
            
            let fileManager = FileManager.default;
            
            if(fileManager.fileExists(atPath: p_audio.path))
            {
                do{
                    try fileManager.removeItem(atPath: p_audio.path);
                }catch{
                    print("delete local audio file fail");
                }
            }
            
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_audio.id ).delete());
        }catch{
            print("remove audio fail");
        }
    }
    
    static func update( p_audio: Audio )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_audio.id ).update( m_ColumnId <- p_audio.id, m_ColumnCardId <- p_audio.cardId, m_ColumnMD5 <- p_audio.md5, m_ColumnAudioType <- p_audio.type  ));
        }catch{
            print("update audio fail");
        }
    }
}
