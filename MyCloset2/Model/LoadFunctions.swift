//
//  Functions.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import Foundation
import RealmSwift
import KRProgressHUD
import UserNotifications

class LoadFunctions {
    
    //アイテムの読み込み
    func loadData(category: String) -> [Clothes] {
        //配列初期化
        var clothesArray = [Clothes]()
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("category== %@", category)
        
        clothesArray = Array(result)
        
        if clothesArray.count == 0 {
            KRProgressHUD.showMessage("登録されていません")
        }
        
        return clothesArray
    }
    
    //着用ボタン
    func didTapPutOnButton(clothes: Clothes) {
        
        //着用回数
        var putOnCount = clothes.putOnCount
        putOnCount = putOnCount + 1
        
        //着用日を取得
        let date = Date()
        let notificationId = clothes.notificationId
        //通知を作成する
        makeNotification(date: date, notificationId: notificationId!)
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first!.putOnCount = putOnCount
            
            //着用回数の履歴作成
            let dateLog = DateLog()
            dateLog.date = date
            object.first!.putOnDateArray.append(dateLog)
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

    //未着用期間の判定
    func judgeWarning(clothes: Clothes) -> Bool {
        
        let nowDate = Date()
        let putOnDate = clothes.putOnDateArray.last
        
        //時間で取得される
        let dateSubtraction: Int = Int(nowDate.timeIntervalSince(putOnDate!.date))
        
        let subtractionDate = dateSubtraction/86400
        
        if subtractionDate >= 0 {
            //警告対象
            return true
        }
        
        return false
    }
    
    //通知作成機能
    func makeNotification(date: Date, notificationId: String) {
        // ローカル通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "長期間着ていない服があるようです"
        content.body = "最後の着用から2年が経過しています"
        content.badge = 1
        
       
        
        //カレンダー型に変える
        let calendar = Calendar(identifier: .gregorian)
        let date = date
       //2年後に期日を設定
        //let notificateDate = calendar.date(byAdding: .day, value: 730, to: date)!
        
       //実験用
        let notificateDate = calendar.date(byAdding: .minute, value: 1, to: date)!
        
       //日付をカレンダーに設定して、通知に入れる
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificateDate)
               
        // ローカル通知リクエストを作成
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        
        //固有のidで通知を保存する
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                KRProgressHUD.showMessage(error.localizedDescription)
            }
        }
    }
    
    
}
