//
//  DBBatcheTable.swift
//  DadPat
//
//  Created by 吴思 on 5/11/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import SQLite

struct Batche
{
    let batcheId: String;
    let batcheSource: String;
    let batcheDesc: String;
    let coverMd5: String;
    let group: String;
    let activation: Bool;
}

class DBBatcheTable: NSObject
{
    static let m_TableName: Table = Table("Batche");
    static let m_ColumnId = Expression<String>("id");
    static let m_ColumnName = Expression<String>("name");
    static let m_ColumnExplain = Expression<String>("mExplain");
    static let m_ColumnCoverMD5 = Expression<String>("coverMD5");
    static let m_ColumnGroup = Expression<String>("group");
    static let m_ColumnActivation = Expression<Bool>("activation");
    
    static func create()
    {
        
        do{
            try DataBase.instance().db!.run(m_TableName.create(ifNotExists: true){
                t in
                t.column(m_ColumnId, primaryKey: true);
                t.column(m_ColumnName);
                t.column(m_ColumnExplain);
                t.column(m_ColumnCoverMD5);
                t.column(m_ColumnGroup);
                t.column(m_ColumnActivation);
            });
        }catch {
            print("create batche table fail");
        }
    }
    
    static func drop()
    {
        do{
            try DataBase.instance().db!.run(m_TableName.drop());
        }catch{
            print("drop btache table fail");
        }
    }
    
    static func list( p_group: String ) -> Array<Batche>
    {
        var t_result: Array<Batche> = Array<Batche>();
        
        do{
            let t_all = Array(try DataBase.instance().db!.prepare(m_TableName.filter(m_ColumnGroup == p_group)));
            for t_item in t_all
            {
                t_result.append(Batche(batcheId: t_item[m_ColumnId], batcheSource: t_item[m_ColumnName], batcheDesc: t_item[m_ColumnExplain], coverMd5: t_item[m_ColumnCoverMD5], group: t_item[m_ColumnGroup], activation: t_item[m_ColumnActivation]));
            }
        }catch{
            print("get batche list fail");
        }
        
        return t_result;
    }
    
    static func append( p_batche: Batche )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.insert( m_ColumnId <- p_batche.batcheId, m_ColumnName <- p_batche.batcheSource, m_ColumnExplain <- p_batche.batcheDesc, m_ColumnCoverMD5 <- p_batche.coverMd5, m_ColumnGroup <- p_batche.group, m_ColumnActivation <- p_batche.activation ) );
        }catch{
            print("append batche fail");
        }
    }
    
    static func remove( p_batcheId: String )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_batcheId ).delete());
        }catch{
            print("remove batche fail");
        }
    }
    
    static func update( p_batche: Batche )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_batche.batcheId ).update( m_ColumnName <- p_batche.batcheSource, m_ColumnExplain <- p_batche.batcheDesc, m_ColumnCoverMD5 <- p_batche.coverMd5, m_ColumnGroup <- p_batche.group, m_ColumnActivation <- p_batche.activation ));
        }catch{
            print("update batche fail");
        }
    }
    
    static func activation( p_batcheId: String )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_batcheId ).update( m_ColumnActivation <- true ));
        }catch{
            print("activation batche fail");
        }
    }
}
