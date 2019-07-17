//
//  ViewController.swift
//  WCDBDemo
//
//  Created by izsm on 2019/7/12.
//  Copyright © 2019 izsm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var textField1: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        textField.placeholder = "请输入name"
        textField.layer.borderColor = UIColor.darkText.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private lazy var textField2: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 150, width: 200, height: 30))
        textField.placeholder = "请输入age"
        textField.layer.borderColor = UIColor.darkText.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        return textField
    }()
    
    
    private lazy var textField3: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 200, width: 200, height: 30))
        textField.placeholder = "请输入sec"
        textField.layer.borderColor = UIColor.darkText.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    
    private lazy var textField4: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        textField.placeholder = "请输入体重"
        textField.layer.borderColor = UIColor.darkText.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(frame: CGRect(x: 20, y: 320, width: 100, height: 40))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(UIColor.darkGray, for: .normal)
        saveBtn.backgroundColor = UIColor.green
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        return saveBtn
    }()
    
    private lazy var deleteBtn: UIButton = {
        let saveBtn = UIButton(frame: CGRect(x: 150, y: 320, width: 100, height: 40))
        saveBtn.setTitle("删除", for: .normal)
        saveBtn.setTitleColor(UIColor.darkGray, for: .normal)
        saveBtn.backgroundColor = UIColor.red
        saveBtn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        return saveBtn
    }()
    
    private var model = WCDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        view.addSubview(textField4)
        view.addSubview(saveBtn)
        view.addSubview(deleteBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func textFieldDidChange(notification: Notification) {
        guard let textF = notification.object as? UITextField else { return }
        
        if textF == textField1, let text = textF.text {
            model.name = text
        }
        
        if textF == textField2, let text = textF.text, let age = Int(text) {
            model.age = age
        }
        
        if textF == textField3, let text = textF.text {
            model.sex = text
        }
        
        if textF == textField4, let text = textF.text, let weight = Int(text) {
            
        }
    }
    
    @objc private func saveBtnClick() {
        WCDBManager.share.save(object: model, table: "WCDBTable")
    }
    
    @objc private func deleteBtnClick() {
        WCDBManager.share.delete(table: "WCDBTable")
    }

}
