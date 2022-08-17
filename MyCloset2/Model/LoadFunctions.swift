//
//  Functions.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import Foundation
import RealmSwift

class LoadFunctions {
    
    //アイテムの読み込み
    func loadData(category: String) -> [Clothes] {
        //配列初期化
        var clothesArray = [Clothes]()
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("category== %@", category)
        
        clothesArray = Array(result)
        
        return clothesArray
    }
    
    //着用ボタン
    func didTapPutOnButton(clothes: Clothes) {
        
        var putOnCount = clothes.putOnCount
        putOnCount = putOnCount + 1
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first!.putOnCount = putOnCount
        }
        
    }
    
    //着用キャンセルボタン
    func didTapCancelButton(clothes: Clothes) {
        
        var putOnCount = clothes.putOnCount
        
        if putOnCount > 0 {
           putOnCount = putOnCount - 1
        } else if putOnCount == 0 {
            putOnCount = 0
        }
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first!.putOnCount = putOnCount
        }
        
    }
    
    //削除ボタン
    func didTapDeleteButton(clothes: Clothes) {
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        try! realm.write {
            realm.delete(result)
        }
        
    }
    
    
    
}
