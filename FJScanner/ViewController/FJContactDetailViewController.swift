//
//  FJContactDetailViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/10/6.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit
import Contacts

class FJContactDetailViewController: FJRootViewController {

    var qrMsg : FJQRMessage
    
    var didSetImage : Bool = false
    
    @IBOutlet weak var userImge: UIImageView!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var tel: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var company: UITextField!
    
    init(qrMessage qrMsg:FJQRMessage) {
        self.qrMsg = qrMsg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.937, green: 0.9373, blue: 0.9569, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "联系人"
        userImge.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleAddUserImageAction(sender:)))
        userImge.addGestureRecognizer(tapGesture)
        self.detectMessage()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleAddUserImageAction(sender:UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true)
        }
    }
    
    func detectMessage() {
        
        let msg = self.qrMsg.message as NSString
        let startRange = msg.range(of: "BEGIN:VCARD")
        let endRange = msg.range(of: "END:VCARD")
        let subStr = msg.substring(with: NSRange.init(location: startRange.length, length: msg.length - startRange.length - endRange.length))
        var lines = subStr.components(separatedBy: "\n")
        if lines.count == 1 {
            lines = subStr.components(separatedBy: " ")
        }
        
        for ele in lines {
            if ele.hasPrefix("FN:") {
                let name = ele.replacingOccurrences(of: "FN:", with:"") as NSString
                if name.length > 1 {
                    self.firstName.text = name.substring(to: 1)
                    self.lastName.text = name.substring(from: 1)
                }
                else {
                    self.firstName.text = name as String
                }
            }
            else if ele.hasPrefix("TEL;CELL;VOICE:") {
                let name = ele.replacingOccurrences(of: "TEL;CELL;VOICE:", with:"")
                self.phone.text = name
            }
            else if ele.hasPrefix("TEL;WORK;VOICE:") {
                let name = ele.replacingOccurrences(of: "TEL;WORK;VOICE:", with:"")
                self.tel.text = name
            }
            else if ele.hasPrefix("EMAIL;PREF;INTERNET:") {
                let name = ele.replacingOccurrences(of: "EMAIL;PREF;INTERNET:", with:"")
                self.email.text = name
            }
            else if ele.hasPrefix("orG:") {
                let name = ele.replacingOccurrences(of: "orG:", with:"")
                self.company.text = name
            }
            else if ele.hasPrefix("ADR;WORK;POSTAL:") {
                let name = ele.replacingOccurrences(of: "ADR;WORK;POSTAL:", with: "")
                self.address.text = name
            }
            
        }
        
        

    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        func addContact (){
            //创建通讯录对象
            let store = CNContactStore()
            
            //创建CNMutableContact类型的实例
            let contactToAdd = CNMutableContact()
            
            //设置姓名
            if firstName.text != nil {
                contactToAdd.familyName = firstName.text!
            }
            
            if lastName.text != nil {
                contactToAdd.givenName = lastName.text!
            }
            
            //设置头像
            if didSetImage {
                let image = userImge.image!
                contactToAdd.imageData = UIImagePNGRepresentation(image)
            }

            //设置电话
            if phone.text != nil {
                let mobileNumber = CNPhoneNumber(stringValue: phone.text!)
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                contactToAdd.phoneNumbers = [mobileValue]
            }
            
            if tel.text != nil {
                let telNumber = CNPhoneNumber(stringValue: tel.text!)
                let telValue = CNLabeledValue(label: CNLabelWork, value: telNumber)
                contactToAdd.phoneNumbers.append(telValue)
            }

            if email.text != nil {
                //设置email
                let emailValue = CNLabeledValue(label: CNLabelWork, value: NSString.init(string: email.text!) )
                contactToAdd.emailAddresses = [emailValue]
            }
            
            if address.text != nil {
                let homeAddress = CNMutablePostalAddress()
                homeAddress.street = address.text!
                contactToAdd.postalAddresses = [CNLabeledValue(label:CNLabelWork, value:homeAddress)]
            }
            
            if company.text != nil {
                contactToAdd.organizationName = company.text!
            }
            
            //添加联系人请求
            let saveRequest = CNSaveRequest()
            saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
            
            do {
                //写入联系人
                try store.execute(saveRequest)
                self.view.makeToast("保存成功")
            } catch {
                print(error)
            }
        }
        
        
        //获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        //判断当前授权状态
        if status == .denied {
            self.gotoSetting()
            return
        }
        else if status == .restricted {
            self.view.makeToast("无法访问通讯录")
        }
        else if status == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
                if isRight {
                    DispatchQueue.main.async {
                        addContact()
                    }
                }
            }
            return
        }
        addContact()
    }
    
    
}

extension FJContactDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if image.size.width > 100 || image.size.height > 100 {
                userImge.contentMode = .scaleAspectFit
            }
            else {
                userImge.contentMode = .center
            }
            userImge.image = image
            self.didSetImage = true
        }
        else {
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
}
