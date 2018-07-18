//
//  DBCardTable.swift
//  DadPat
//
//  Created by 吴思 on 5/11/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import SQLite

struct Card
{
    let id: Int;
    let serviceId: String;
    let coverMD5: String;
    let lineDrawingMD5: String;
    let batcheId: String;
    let activation: Bool;
}

class DBCardTable: NSObject
{
    static let m_TableName: Table = Table("Card");
    static let m_ColumnId = Expression<Int>("id");
    static let m_ColumnServiceId = Expression<String>("serviceId");
    static let m_ColumnCoverImageMD5 = Expression<String>("coverImageMD5");
    static let m_ColumnLineDrawingMD5 = Expression<String>("lineDrawingMD5");
    static let m_ColumnBatcheId = Expression<String>("batcheId");
    static let m_ColumnActivation = Expression<Bool>("activation");
    static func create()
    {
        do{
            try DataBase.instance().db!.run(m_TableName.create(ifNotExists: true){
                t in
                t.column(m_ColumnId, primaryKey: true);
                t.column(m_ColumnServiceId);
                t.column(m_ColumnCoverImageMD5);
                t.column(m_ColumnLineDrawingMD5);
                t.column(m_ColumnBatcheId);
                t.column(m_ColumnActivation);
            });
        }catch {
            print("create card table fail");
        }
    }
    
    static func drop()
    {
        do{
            try DataBase.instance().db!.run(m_TableName.drop());
        }catch{
            print("drop card table fail");
        }
    }
    
    static func list( p_batcheId: String ) -> Array<Card>
    {
        var t_result: Array<Card> = Array<Card>();
        
        do{
            let t_all = Array(try DataBase.instance().db!.prepare(m_TableName.filter(m_ColumnBatcheId == p_batcheId)));
            for t_item in t_all
            {
                t_result.append(Card(id: t_item[m_ColumnId], serviceId: t_item[m_ColumnServiceId], coverMD5: t_item[m_ColumnCoverImageMD5], lineDrawingMD5: t_item[m_ColumnLineDrawingMD5], batcheId: t_item[m_ColumnBatcheId], activation: t_item[m_ColumnActivation]));
            }
        }catch{
            print("get card list fail");
        }
        
        return t_result;
    }
    
    static func append( p_card: Card )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.insert( m_ColumnId <- p_card.id, m_ColumnServiceId <- p_card.serviceId, m_ColumnBatcheId <- p_card.batcheId, m_ColumnCoverImageMD5 <- p_card.coverMD5, m_ColumnLineDrawingMD5 <- p_card.lineDrawingMD5, m_ColumnActivation <- p_card.activation ) );
        }catch{
            print("append card fail");
        }
    }
    
    static func remove( p_cardId: Int )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_cardId ).delete());
        }catch{
            print("remove card fail");
        }
    }
    
    static func update( p_card: Card )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_card.id ).update( m_ColumnServiceId <- p_card.serviceId, m_ColumnBatcheId <- p_card.batcheId, m_ColumnCoverImageMD5 <- p_card.coverMD5, m_ColumnLineDrawingMD5 <- p_card.lineDrawingMD5 ));
        }catch{
            print("update card fail");
        }
    }
    
    static func activation( p_cardId: Int )
    {
        do{
            try DataBase.instance().db!.run( m_TableName.filter( m_ColumnId == p_cardId ).update( m_ColumnActivation <- true ));
        }catch{
            print("activation card fail");
        }
    }
    
}
