//
//  FJImageGeneratorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/29.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import RealmSwift

class FJImageGeneratorViewController: FJRootViewController {
    
    let menu = UIImageView.init(image: UIImage.init(named: "plus"))
    var menuSwitch = false
    
    let addTextButton = UIButton.init()
    let addImageButton = UIButton.init()
    let addLogoButton = UIButton.init()
    let addSaveButton = UIButton.init()
    
    let imageBoard = UIImageView.init()
    var selectImage = UIImage.init()
    
    var text:String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubViews()
        self.configImageBoard()
        self.configButtons()
    }
    
    func addSubViews() {
        self.view.addSubview(self.imageBoard)
        self.view.addSubview(self.addTextButton)
        self.view.addSubview(self.addImageButton)
        self.view.addSubview(self.addLogoButton)
        self.view.addSubview(self.addSaveButton)
        self.view.addSubview(self.menu)
        
    }
    
    func configImageBoard() {
        
        self.imageBoard.contentMode = .scaleAspectFit
        
        self.imageBoard.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
            make.right.equalToSuperview()
        }
    }
    
    func configButtons() {
        
        self.addImageButton.layer.cornerRadius = 3
        self.addImageButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addImageButton.layer.borderWidth = 2
        self.addImageButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.addImageButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.addImageButton.tag = 1
        self.addImageButton.backgroundColor = UIColor.white
        self.addImageButton.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)

        self.addTextButton.layer.cornerRadius = 3
        self.addTextButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addTextButton.layer.borderWidth = 2
        self.addTextButton.backgroundColor = UIColor.white
        self.addTextButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.addTextButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.addTextButton.tag = 2
        self.addTextButton.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        self.addLogoButton.layer.cornerRadius = 3
        self.addLogoButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addLogoButton.backgroundColor = UIColor.white
        self.addLogoButton.layer.borderWidth = 2
        self.addLogoButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.addLogoButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.addLogoButton.tag = 3
        self.addLogoButton.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        self.addSaveButton.layer.cornerRadius = 3
        self.addSaveButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addSaveButton.backgroundColor = UIColor.white
        self.addSaveButton.layer.borderWidth = 2
        self.addSaveButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.addSaveButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.addSaveButton.tag = 4
        self.addSaveButton.addTarget(self, action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        self.addTextButton.setTitle("文本", for: UIControlState.normal)
        self.addImageButton.setTitle("背景", for: UIControlState.normal)
        self.addLogoButton.setTitle("清空", for: UIControlState.normal)
        self.addSaveButton.setTitle("保存", for: UIControlState.normal)
        
        
        self.menu.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight - 20)
        }
        
        self.menu.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onMenuTap(sender:)))
        self.menu.addGestureRecognizer(tapGesture)
        
        self.addTextButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.menu.snp.centerX)
            make.centerY.equalTo(self.menu.snp.centerY)
            make.width.equalTo(50)
        }
        self.addImageButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.menu.snp.centerX)
            make.centerY.equalTo(self.menu.snp.centerY)
            make.width.equalTo(50)
        }
        self.addLogoButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.menu.snp.centerX)
            make.centerY.equalTo(self.menu.snp.centerY)
            make.width.equalTo(50)
        }
        
        self.addSaveButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.menu.snp.centerX)
            make.centerY.equalTo(self.menu.snp.centerY)
            make.width.equalTo(50)
        }

        
        self.addImageButton.alpha = 0
        self.addLogoButton.alpha = 0
        self.addTextButton.alpha = 0
        self.addSaveButton.alpha = 0
    }
    
    @objc func buttonAction(sender:UIButton) {
        if sender.tag == 1 {//image
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker,animated: true)
                
            }
        }
        else if sender.tag == 2 {//text
            //初始化UITextField
            var inputText:UITextField = UITextField();
            let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入内容，以生成二维码", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
                if((inputText.text) != ""){
                    self.handleUserInputText(text: inputText.text!)
                }
                else {
                    self.view.makeToast("内容不能为空")
                }
            }
            
            let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
                
            }
            
            msgAlertCtr.addAction(ok)
            msgAlertCtr.addAction(cancel)
            //添加textField输入框
            msgAlertCtr.addTextField { (textField) in
                //设置传入的textField为初始化UITextField
                inputText = textField
                inputText.placeholder = "输入数据"
            }
            //设置到当前视图
            self.present(msgAlertCtr, animated: true, completion: nil)
        }
        else if sender.tag == 3 {//delete
            self.text = ""
            self.imageBoard.image = nil
            self.selectImage = UIImage.init()
        }
        else if sender.tag == 4 {//保存
            self.saveQRImageToPhoto()
            
            let newQRMessage = FJQRMessage()
            newQRMessage.name = self.text
            newQRMessage.message = self.text
            newQRMessage.tag = ""
            do {
                // Get the default Realm
                let realm = try Realm()
                // Persist your data easily
                try realm.write {
                    realm.add(newQRMessage)
                }
            } catch {
                
            }

        }
    }
    
    @objc func onMenuTap(sender:UITapGestureRecognizer) {
        menuSwitch = !menuSwitch
        if menuSwitch {
            UIView.animate(withDuration: 0.2) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi*2.5 ))
                self.addImageButton.alpha = 1
                self.addLogoButton.alpha = 1
                self.addTextButton.alpha = 1
                self.addSaveButton.alpha = 1
                
                
                self.addTextButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-170)
                })
                
                self.addImageButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-130)
                })
                
                self.addLogoButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-90)
                })
                
                self.addSaveButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-50)
                })
                self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.2) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi*2.5))
                self.addImageButton.alpha = 0
                self.addLogoButton.alpha = 0
                self.addTextButton.alpha = 0
                self.addSaveButton.alpha = 0

                self.addTextButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(170)
                })
                
                self.addImageButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(130)
                })
                
                self.addLogoButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(90)
                })
                
                self.addSaveButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(50)
                })
                
                self.view.layoutIfNeeded()

            }
        }
    }
    
    func handleUserInputText(text:String) {
        self.text = text
        let qrImage = FJQRImageGenerateUtil.setupQRCodeImage(text, image: nil)
        
        if self.selectImage.size == CGSize.zero {
            self.imageBoard.image = qrImage
        }
        else {
            self.imageBoard.image = FJQRImageGenerateUtil.combineImage(selectImage, qrImage: qrImage, width: 150, height: 150)
        }
        
    }
    
    func handleUserSelectImage(selectImage:UIImage) {
        self.selectImage = selectImage
        if self.text.count > 0 {
            let qrImage = FJQRImageGenerateUtil.setupQRCodeImage(self.text, image: nil)
            self.imageBoard.image = FJQRImageGenerateUtil.combineImage(selectImage, qrImage: qrImage, width: 150, height: 150)
        }
        else {
            self.imageBoard.image = selectImage
        }
    }
    
    func callFeddBack() {
        let feedBackGenertor = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        feedBackGenertor.impactOccurred()
    }
    
    func saveQRImageToPhoto() {
        
        let image = self.imageBoard.image
        guard image != nil && image?.size != CGSize.zero else {
            self.view.makeToast("保存失败")
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        }) { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                if isSuccess {
                    self.view.makeToast("保存成功")
                } else{
                    self.view.makeToast("保存失败")
                }
            }
        }
    }


}

extension FJImageGeneratorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.handleUserSelectImage(selectImage: image)
        }
        else {
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
}

extension FJImageGeneratorViewController :UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}

