//
//  DatePicker.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/10/16.
//

import UIKit

class DatePicker {
    var datePicker: UIDatePicker
    var textField: UITextField
    var view: UIView
    
    init(datePicker: UIDatePicker, textField: UITextField, view: UIView) {
        self.datePicker = datePicker
        self.textField = textField
        self.view = view
    }
    
    // DatePickerを設定
    func setUpDatePicker(with doneSelector: Selector) {
        //  購入日のシステム
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        textField.inputView = datePicker
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSelector)
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
}
