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
    
    private let MaxDurationOfNotWorn = 730
    /// 服のデータをRealmから読み込む
    /// - Parameter category: 読み込みたいカテゴリを格納
    /// - Returns: カテゴリに一致する服のデータを配列化したものを返す
    func loadClothes(category: String) -> [Clothes] {
        //配列初期化
        var clothesArray = [Clothes]()
        
        if let realm = try? Realm() {
            let result = realm.objects(Clothes.self).filter("category== %@", category)
            clothesArray = Array(result)
        }
        
        if clothesArray.count == 0 {
            KRProgressHUD.showMessage("登録されていません")
        }
        return clothesArray
    }
    
    /// 服を検索する関数
    /// - Parameters:
    ///   - selectedCategory: 選択されたカテゴリ
    ///   - selectedColor: 選択されたカラー
    /// - Returns: Clothesの配列を返す
    func searchClothes(selectedCategory: String, selectedColor: String) -> [Clothes] {
        guard let realm = try? Realm() else {
            fatalError()
        }
        
        let result = realm.objects(Clothes.self).filter("category== %@ AND color== %@", selectedCategory, selectedColor)
        let clothesArray = Array(result)
        
        return clothesArray
    }
    
    /// 着用回数を1増やし、Realmに保存する
    /// - Parameter clothes: 着用ボタンを押された服の情報を格納
    func incrementPutOnCount(clothes: Clothes) {
        if let realm = try? Realm(), let clothesId = clothes.id {
            let result = realm.objects(Clothes.self).filter("id== %@", clothesId)
            //resultを配列化する
            let object = Array(result)
            //着用回数を1増やし、Realmに保存する
            try? realm.write {
                object.first?.putOnCount += 1
            }
        }
    }
    
    /// 着用履歴を更新し、Realmに保存する
    /// - Parameter clothes: 着用ボタンを押された服の情報を格納
    func appendPutOnDate(clothes: Clothes) {
        //着用日を取得
        let date = Date()
        
        if let realm = try? Realm(), let clothesId = clothes.id {
            let result = realm.objects(Clothes.self).filter("id== %@", clothesId)
            //resultを配列化する
            let object = Array(result)
            
            try? realm.write {
                //着用日の履歴作成
                let dateLog = DateLog()
                dateLog.date = date
                object.first?.putOnDateArray.append(dateLog)
            }
        }
    }
      
    /// 着用回数を1減らし、Realmに保存する
    /// - Parameter clothes: 着用キャンセルボタンを押された服の情報を格納
    func decrementPutOnCount(clothes: Clothes) {
        //Realmに更新
        if let realm = try? Realm(), let clothesId = clothes.id {
            let result = realm.objects(Clothes.self).filter("id== %@", clothesId)
            //resultを配列化する
            let object = Array(result)
            //着用回数を1増やし、Realmに保存する
            try? realm.write {
                object.first?.putOnCount -= 1
            }
        }
    }
    
    /// 着用履歴を削除し、Realmに保存する
    /// - Parameter clothes: 着用キャンセルボタンを押された服の情報を格納
    func removePutOnDate(clothes: Clothes) -> List<DateLog> {
        var putOnDateArray = clothes.putOnDateArray

        if let realm = try? Realm(), let clothesId = clothes.id {
            let result = realm.objects(Clothes.self).filter("id== %@", clothesId)
            //resultを配列化する
            let object = Array(result)
            
            try? realm.write {
                putOnDateArray.removeLast()
                object.first?.putOnDateArray = putOnDateArray
            }
        }
        return putOnDateArray
    }
    
    /// 服のデータをRealmから削除する
    /// - Parameter clothes: 削除したい服のデータを格納
    func deleteClothesData(clothes: Clothes) {
        if let realm = try? Realm(), let clothesId = clothes.id {
            let result = realm.objects(Clothes.self).filter("id== %@", clothesId)
            try? realm.write {
                realm.delete(result)
            }
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
       //2年後に期日を設定.通知時間が未来であること（差分が0より大きい）が条件（クラッシュ防止）
        if let notificateDate = calendar.date(byAdding: .day, value: MaxDurationOfNotWorn, to: date), Int(notificateDate.timeIntervalSince(date)) > 0 {
            //日付をカレンダーに設定して、通知に入れる
            let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificateDate)
            
            // ローカル通知リクエストを作成
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            
            //固有のidで通知を保存する
            let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
            
            // ローカル通知リクエストを登録
            UNUserNotificationCenter.current().add(request){ (error : Error?) in
                if let error {
                    KRProgressHUD.showMessage(error.localizedDescription)
                }
            }
        }
    }
    
}
