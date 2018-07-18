//
//  DataBase.swift
//  DadPat
//
//  Created by 吴思 on 5/4/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation
import SQLite

class DataBase : NSObject
{
    //MARK: - 创建类的静态实例变量即为单例对象 let-是线程安全的
    static let m_instance = DataBase();
    //对外提供创建单例对象的接口
    class func instance() -> DataBase {
        return m_instance;
    }
    //MARK: - 数据库操作
    //定义数据库变量
    var db: Connection? = nil;
    
    //打开数据库
    func openDB() -> Bool {
        
        if( db != nil ){
            return true;
        }
        
        //数据库文件路径
        let dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last;
        let DBPath = (dicumentPath! as NSString).appendingPathComponent("goofypapa.sqlite");
        
        do
        {
            try db = Connection( DBPath );
        }catch{
            return false;
        }
        
//        deleteTable();
        
        creatTable();
        
        return true;
    }
    //创建表
    func creatTable()
    {
        DBBatcheTable.create();
        DBCardTable.create();
        DBAudioTable.create();
        DBImageTable.create();
    }

    func deleteTable()
    {
        DBBatcheTable.drop();
        DBCardTable.drop();
        DBAudioTable.drop();
        DBImageTable.drop();
    }

    //执行建表SQL语句
    func ExecSQLList(p_sqlArr : [String]) -> Bool {
        for item in p_sqlArr {
            if execSQL(p_sql: item) == false {
                return false;
            }
        }
        return true;
    }
    //执行SQL语句
    func execSQL(p_sql : String) -> Bool {
        //错误信息
        do{
            try db!.execute(p_sql);
        }catch{
            return false;
        }
        
        return true;
    }
}
