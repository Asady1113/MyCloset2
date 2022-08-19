//
//  Clothes.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import RealmSwift
import Foundation

class Clothes: Object {
    
    @objc dynamic var id: String!
    @objc dynamic var category: String!
    @objc dynamic var name: String!
    @objc dynamic var buyDateString: String!
    @objc dynamic var buyDate: Date!
    @objc dynamic var price: String!
    @objc dynamic var comment: String!
    @objc dynamic var color: String!
    @objc dynamic var imageData: NSData!
    @objc dynamic var putOnCount: Int = 0
    
    
    
    func add(id: String, category: String, name: String, buyDateString: String, buyDate: Date, price: String, comment: String, color: String, imageData: NSData) {
        
        self.id = id
        self.category = category
        self.name = name
        self.buyDateString = buyDateString
        self.buyDate = buyDate
        self.price = price
        self.comment = comment
        self.color = color
        self.imageData = imageData
    }
    
}