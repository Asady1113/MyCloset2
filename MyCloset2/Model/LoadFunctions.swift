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
    
    let MaxDurationOfNotWorn = 730
    /// 服のデータをRealmから読み込む
    /// - Parameter category: 読み込みたいカテゴリを格納
    /// - Returns: カテゴリに一致する服のデータを配列化したものを返す
    func loadClothes(category: String) -> [Clothes] {
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
    
    /// 着用回数を1増やし、Realmに保存する
    /// - Parameter clothes: 着用ボタンを押された服の情報を格納
    func incrementPutOnCountAndRecordDate(clothes: Clothes) {
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
    
    /// 着用回数を1減らし、Realmに保存する
    /// - Parameter clothes: 着用キャンセルボタンを押された服の情報を格納
    func decrementPutOnCountAndRecordDate(clothes: Clothes) {
        var putOnCount = clothes.putOnCount
        var putOnDateArray = clothes.putOnDateArray
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            if putOnCount > 0 {
               putOnCount = putOnCount - 1
               //着用履歴も消去
               putOnDateArray.removeLast()
            
               //通知も再設定（最新のdateで設定）
               let date = putOnDateArray.last!.date
               makeNotification(date: date, notificationId: clothes.notificationId)
            }
            object.first!.putOnCount = putOnCount
            object.first!.putOnDateArray = putOnDateArray
        }
    }
    
    /// 服のデータをRealmから削除する
    /// - Parameter clothes: 削除したい服のデータを格納
    func deleteClothesData(clothes: Clothes) {
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothes.id)
        
        try! realm.write {
            realm.delete(result)
        }
    }

    /// 最後の着用履歴から定められた期間が経っているか判定する
    /// - Parameter clothes: 選択された服のデータを格納
    /// - Returns: true：定められた期間経っている。false：2年経っていない
    func isOverMaxDurationSinceLastWorn(clothes: Clothes) -> Bool {
        if let putOnDate = clothes.putOnDateArray.last {
            let nowDate = Date()
            //秒数で取得される
            let dateSubtraction = Int(nowDate.timeIntervalSince(putOnDate.date))
            
            //日付に変換する
            let secondsPerDay = 86400
            let subtractionDate = dateSubtraction / secondsPerDay
            
            //期日以上差があったなら
            if subtractionDate >= MaxDurationOfNotWorn {
                //警告対象
                return true
            }
        }
        return false
    }
    
    /// 通知を作成する
    /// - Parameters:
    ///   - date: アクションを起こした日の日付
    ///   - notificationId: 通知を識別するためのid
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
       //期日を設定
        let notificateDate = calendar.date(byAdding: .day, value: MaxDurationOfNotWorn, to: date)!
        
        //通知する時間と今の時間の差分を計算
        let dateSubtraction = Int(notificateDate.timeIntervalSince(date))
       
        //通知時間が未来であること（差分が0より大きい）が条件（クラッシュ防止）
        if dateSubtraction > 0 {
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
    
}
