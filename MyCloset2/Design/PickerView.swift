//
//  PickerView.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/10/16.
//

import UIKit

class PickerView {
    var pickerView: UIPickerView
    var textField: UITextField
    var view: UIView
    
    init(pickerView: UIPickerView, textField: UITextField, view: UIView) {
        self.pickerView = pickerView
        self.textField = textField
        self.view = view
    }
    
    // PickerViewを設定
    func setUpColorPickerView(with doneSelector: Selector) {
        // 決定バーの生成
        let colorToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let colorSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let colorDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSelector)
        colorToolBar.setItems([colorSpacelItem, colorDoneItem], animated: true)
        
        // インプットビュー設定
        textField.inputView = pickerView
        textField.inputAccessoryView = colorToolBar
    }

}
