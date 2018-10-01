//
//  FJImageGeneratorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/29.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit
import SnapKit

class FJImageGeneratorViewController: FJRootViewController {
    
    let menu = UIImageView.init(image: UIImage.init(named: "plus"))
    var menuSwitch = false
    
    let addTextButton = UIButton.init()
    let addImageButton = UIButton.init()
    let addLogoButton = UIButton.init()
    
    let imageBoard = UIImageView.init()
    let qrImageBoard = UIImageView.init()
    let photoBoard = UIImageView.init()
    
    var totalDegree:Int64 = 0
    
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
        self.view.addSubview(self.menu)
        
    }
    
    func configImageBoard() {
        self.imageBoard.addSubview(self.photoBoard)
        self.imageBoard.addSubview(self.qrImageBoard)
        
        self.imageBoard.contentMode = .scaleAspectFit
        self.qrImageBoard.contentMode = .scaleAspectFit
        self.photoBoard.contentMode = .scaleAspectFit
        
        self.imageBoard.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
            make.right.equalToSuperview()
        }
//        self.photoBoard.frame = self.imageBoard.bounds
//        self.qrImageBoard.frame = self.imageBoard.bounds

// 监听移动手势
//        self.qrImageBoard.isUserInteractionEnabled = true
//        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleQrImagePangeGesture(gesture:)))
//        self.qrImageBoard.addGestureRecognizer(panGesture)

//  监听旋转手势
//        let rotationGestureRecgonizer = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotationGesture(_:)))
//        rotationGestureRecgonizer.delegate = self
//        self.qrImageBoard.addGestureRecognizer(rotationGestureRecgonizer)

// 监听缩放手势
//        let pinchGestureRecgonizer = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
//        pinchGestureRecgonizer.delegate = self
//        self.qrImageBoard.addGestureRecognizer(pinchGestureRecgonizer)
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
        
        self.addTextButton.setTitle("文本", for: UIControlState.normal)
        self.addImageButton.setTitle("背景", for: UIControlState.normal)
        self.addLogoButton.setTitle("删除", for: UIControlState.normal)
        
        
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
        
        self.addImageButton.alpha = 0
        self.addLogoButton.alpha = 0
        self.addTextButton.alpha = 0
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
            self.qrImageBoard.image = nil
            self.photoBoard.image = nil
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
                
                
                self.addTextButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-130)
                })
                
                self.addImageButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(-90)
                })
                
                self.addLogoButton.snp.updateConstraints({ (make) in
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

                self.addTextButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(130)
                })
                
                self.addImageButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(90)
                })
                
                self.addLogoButton.snp.updateConstraints({ (make) in
                    make.centerY.equalTo(self.menu).offset(50)
                })
                self.view.layoutIfNeeded()

            }
        }
    }
    
    func handleUserInputText(text:String) {
        
        let qrImage = FJQRImageGenerateUtil.setupQRCodeImage(text, image: nil)
        if self.photoBoard.image == nil {
            self.qrImageBoard.frame = self.imageBoard.bounds
        }
        else {
            if self.text.count <= 0 {
                self.qrImageBoard.frame = CGRect.init(x: 20, y: 20, width: 200, height: 200)
            }
        }
        self.qrImageBoard.image = qrImage
        self.text = text
    }
    
    func handleUserSelectImage(selectImage:UIImage) {
        if self.text.count > 0 {
            if self.photoBoard.image == nil {
                self.qrImageBoard.frame = CGRect.init(x: 20, y: 20, width: 200, height: 200)
            }
            self.photoBoard.image = selectImage
            
        }
        else {
            self.photoBoard.frame = self.imageBoard.bounds
            self.photoBoard.image = selectImage
        }
    }
    
    @objc func handleQrImagePangeGesture(gesture:UIPanGestureRecognizer) {
        let targetView = gesture.view
        guard targetView != nil else {
            return
        }
        if photoBoard.image == nil {
            return
        }
        let transP = gesture.translation(in: targetView)
        targetView!.transform = targetView!.transform.translatedBy(x: transP.x, y: transP.y)
        gesture.setTranslation(CGPoint.zero, in: targetView)
    }
    
    @objc func handleRotationGesture(_ gesture:UIRotationGestureRecognizer) {
        let targetView = gesture.view
        guard targetView != nil else {
            return
        }
        if photoBoard.image == nil {
            return
        }
        targetView!.transform = targetView!.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0

        
        
        //TODO: 手平时反馈
//        let centerPointX = targetView!.convert(targetView!.center, to: self.imageBoard).x
//        let originPointX = targetView?.frame.origin.x ?? 0
//        let width = targetView?.frame.width ?? 0
//        let height = targetView?.frame.height ?? 0
//
//        if fabs(centerPointX - originPointX)/width <= 0.1 {
////            self.callFeddBack()
//        }
//        else if  fabs(fabs(centerPointX - originPointX) - width/2)/width <= 0.095 {
//            self.callFeddBack()
//        }
//        else if fabs(fabs(centerPointX - originPointX) - height/2)/height <= 0.095 {
//            self.callFeddBack()
//        }

    }
    
    @objc func handlePinchGesture(_ gesture:UIPinchGestureRecognizer) {
        let targetView = gesture.view
        guard targetView != nil else {
            return
        }
        if photoBoard.image == nil {
            return
        }
        targetView!.transform = targetView!.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
        
    }
    
    func callFeddBack() {
        let feedBackGenertor = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        feedBackGenertor.impactOccurred()
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

