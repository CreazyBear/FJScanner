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
    var qrImageView = UIImageView.init()
    var maskView = UIView()
    
    var text:String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubViews()
        self.configImageBoard(false)
        self.configImageBoardGesture()
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
    
    func bringMenuToFront() {
        self.view.bringSubview(toFront: self.addTextButton)
        self.view.bringSubview(toFront: self.addImageButton)
        self.view.bringSubview(toFront: self.addLogoButton)
        self.view.bringSubview(toFront: self.addSaveButton)
        self.view.bringSubview(toFront: self.menu)
    }
    
    func configImageBoard(_ isUpdate:Bool) {
        
        self.imageBoard.contentMode = .scaleAspectFit
        self.imageBoard.isUserInteractionEnabled = true
        
        if isUpdate {
            self.imageBoard.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(0)
                make.top.equalToSuperview().offset(kFJNavigationBarHeight)
                make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
            }
        }
        else {
            self.imageBoard.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(kFJNavigationBarHeight)
                make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
            }
        }
    }
    
    func configImageBoardGesture() {
        // 监听移动手势
        self.imageBoard.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleQrImagePangeGesture(gesture:)))
        self.imageBoard.addGestureRecognizer(panGesture)
        
        // 监听旋转手势
        let rotationGestureRecgonizer = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotationGesture(_:)))
        rotationGestureRecgonizer.delegate = self
        self.imageBoard.addGestureRecognizer(rotationGestureRecgonizer)
        
        // 监听缩放手势
        let pinchGestureRecgonizer = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGestureRecgonizer.delegate = self
        self.imageBoard.addGestureRecognizer(pinchGestureRecgonizer)
        
    }

    func configQRImageViewgGesture() {
        // 监听移动手势
        self.qrImageView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleQrImagePangeGesture(gesture:)))
        self.qrImageView.addGestureRecognizer(panGesture)
        
        // 监听旋转手势
        let rotationGestureRecgonizer = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotationGesture(_:)))
        rotationGestureRecgonizer.delegate = self
        self.qrImageView.addGestureRecognizer(rotationGestureRecgonizer)
        
        // 监听缩放手势
        let pinchGestureRecgonizer = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGestureRecgonizer.delegate = self
        self.qrImageView.addGestureRecognizer(pinchGestureRecgonizer)
        
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
            
            let textInputVC = FJTextInputViewController()
            textInputVC.resultBlock = {
                (content: String) -> Void in
                if(content != ""){
                    self.handleUserInputText(text: content)
                }
                else {
                    self.view.makeToast("内容不能为空")
                }
            }
            self.navigationController?.pushViewController(textInputVC, animated: true)
        }
        else if sender.tag == 3 {//delete
            self.text = ""
            self.imageBoard.image = nil
            self.removeBorderOfImageBoard()
            self.maskView.removeFromSuperview()
            self.qrImageView.image = nil;
            self.qrImageView.removeFromSuperview()
            self.selectImage = UIImage.init()
        }
        else if sender.tag == 4 {//保存
            guard imageBoard.image != nil else {
                self.view.makeToast("还没有添加内容呢~")
                return
            }
            guard self.qrImageView.image != nil else {
                self.view.makeToast("还没有添加二维码")
                return
            }
            
            var finalImage:UIImage
            if self.selectImage.size != CGRect.zero.size {
                //TODO: the user had selected an image as background image, combine two image
                var finalFrame = CGRect.zero
                var finalScale:CGFloat = 1.0
                if self.selectImage.size.height > self.selectImage.size.width {
                    finalScale = (kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)/selectImage.size.height
                }
                else {
                    finalScale = kFJWindowWidth/selectImage.size.width
                }
                let qrImageFrame = self.qrImageView.frame
                finalFrame.origin.x = qrImageFrame.origin.x / finalScale
                finalFrame.origin.y = qrImageFrame.origin.y / finalScale
                finalFrame.size.height = qrImageFrame.size.height / finalScale
                finalFrame.size.width = qrImageFrame.size.width / finalScale
                
                finalImage = FJQRImageGenerateUtil.combineImage(self.imageBoard.image!, qrImage: self.qrImageView.image!, frame: finalFrame)
            }
            else {
                //TODO: Just output the qrimage
                finalImage = imageBoard.image!
            }
            FJQRImageGenerateUtil.saveQRImageToPhoto(image:finalImage) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.view.makeToast("二维码图片已成功保存到相册")
                    } else{
                        self.view.makeToast("二维码图片创建失败")
                    }
                }
            }
            
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
            self.qrImageView.removeFromSuperview()
            self.imageBoard.image = qrImage
        }
        else {
            let widthOfQRCode = self.imageBoard.frame.size.width>self.imageBoard.frame.size.height ? self.imageBoard.frame.size.height/2 : self.imageBoard.frame.size.width/2
            qrImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: widthOfQRCode, height: widthOfQRCode))
            qrImageView.image = qrImage
            self.imageBoard.addSubview(qrImageView)
            self.configQRImageViewgGesture()
//            self.imageBoard.image = FJQRImageGenerateUtil.combineImage(selectImage, qrImage: qrImage, width: 200, height: 200)
            
        }
        
    }
    
    func handleUserSelectImage(selectImage:UIImage) {
        self.configImageBoard(true)
        self.maskView.removeFromSuperview()
        self.removeBorderOfImageBoard()
        self.selectImage = selectImage
        var imageBoardFrame = CGRect.zero
        if self.text.count > 0 {
            self.qrImageView.removeFromSuperview()
            self.imageBoard.image = selectImage
            
            //config frame for imageboard
            var scale:CGFloat = 1.0
            if selectImage.size.width >= selectImage.size.height {
                scale = self.imageBoard.frame.size.width/selectImage.size.width
                let frame = CGRect.init(x: 0, y: kFJNavigationBarHeight, width: kFJWindowWidth, height: kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)
                let topOffset = (frame.size.height - selectImage.size.height*scale)/2
                let bottomOffset = frame.size.height - selectImage.size.height*scale - topOffset
                imageBoardFrame = CGRect.init(x: 0, y: topOffset - kFJNavigationBarHeight, width: kFJWindowWidth, height: selectImage.size.height*scale)
                self.imageBoard.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(0)
                    make.right.equalToSuperview().offset(0)
                    make.top.equalToSuperview().offset(topOffset)
                    make.bottom.equalToSuperview().offset(-bottomOffset)
                }
            }
            else {
                scale = (kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)/selectImage.size.height
                let rightOffset = (kFJWindowWidth - selectImage.size.width*scale)/2
                let leftOffset = rightOffset
                imageBoardFrame = CGRect.init(x: rightOffset, y: 0, width: kFJWindowWidth - 2*rightOffset, height: kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)
                self.imageBoard.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(leftOffset)
                    make.right.equalToSuperview().offset(-rightOffset)
                    make.top.equalToSuperview().offset(kFJNavigationBarHeight)
                    make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
                }
            }
            
            let qrImage = FJQRImageGenerateUtil.setupQRCodeImage(self.text, image: nil)
            qrImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.imageBoard.frame.size.width/2, height: self.imageBoard.frame.size.height/2))
            qrImageView.image = qrImage
            self.imageBoard.addSubview(qrImageView)
            self.configQRImageViewgGesture()
            self.addBorderToImageBoard()
            self.addMaskView(imageBoardFrame)
//            self.imageBoard.image = FJQRImageGenerateUtil.combineImage(selectImage, qrImage: qrImage, width: 200, height: 200)
        }
        else {
            self.imageBoard.image = selectImage

            //config frame for imageboard
            if selectImage.size.width >= selectImage.size.height {
                var scale:CGFloat = 1.0
                scale = kFJWindowWidth/selectImage.size.width
                let frame = CGRect.init(x: 0, y: kFJNavigationBarHeight, width: kFJWindowWidth, height: kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)
                let topOffset = (frame.size.height - selectImage.size.height*scale)/2 + kFJNavigationBarHeight
                let bottomOffset = kFJWindowHeight - topOffset - selectImage.size.height*scale
                imageBoardFrame = CGRect.init(x: 0, y: topOffset - kFJNavigationBarHeight, width: kFJWindowWidth, height: selectImage.size.height*scale)
                self.imageBoard.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(0)
                    make.right.equalToSuperview().offset(0)
                    make.top.equalToSuperview().offset(topOffset)
                    make.bottom.equalToSuperview().offset(-bottomOffset)
                }
            }
            else {
                var scale:CGFloat = 1.0
                scale = (kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)/selectImage.size.height
                let rightOffset = (kFJWindowWidth - selectImage.size.width*scale)/2
                let leftOffset = rightOffset
                imageBoardFrame = CGRect.init(x: rightOffset, y: 0, width: kFJWindowWidth - 2*rightOffset, height: kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)
                self.imageBoard.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(leftOffset)
                    make.right.equalToSuperview().offset(-rightOffset)
                    make.top.equalToSuperview().offset(kFJNavigationBarHeight)
                    make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
                }
            }
            self.addBorderToImageBoard()
            self.addMaskView(imageBoardFrame)

        }
    }
    
    func callFeddBack() {
        let feedBackGenertor = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        feedBackGenertor.impactOccurred()
    }
    
    @objc func handleQrImagePangeGesture(gesture:UIPanGestureRecognizer) {
        let targetView = self.qrImageView
        guard targetView.image?.size != CGRect.zero.size else {
            return
        }
        if imageBoard.image == nil {
            return
        }
        let transP = gesture.translation(in: targetView)
        targetView.transform = targetView.transform.translatedBy(x: transP.x, y: transP.y)
        gesture.setTranslation(CGPoint.zero, in: targetView)
    }
    
    @objc func handleRotationGesture(_ gesture:UIRotationGestureRecognizer) {
        let targetView = self.qrImageView
        guard targetView.image?.size != CGRect.zero.size else {
            return
        }
        if imageBoard.image == nil {
            return
        }
        targetView.transform = targetView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func handlePinchGesture(_ gesture:UIPinchGestureRecognizer) {
        let targetView = self.qrImageView
        guard targetView.image?.size != CGRect.zero.size else {
            return
        }
        if imageBoard.image == nil {
            return
        }
        targetView.transform = targetView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
        
    }

    func addBorderToImageBoard() {
        self.imageBoard.layer.borderWidth = 2
        self.imageBoard.layer.borderColor = UIColor.orange.cgColor
        self.imageBoard.layer.cornerRadius = 2
    }
    
    func removeBorderOfImageBoard() {
        self.imageBoard.layer.borderWidth = 0
        self.imageBoard.layer.cornerRadius = 0
    }
    
    func addMaskView(_ imageBoardFrame:CGRect) {
        let frame = CGRect.init(x: 0, y: kFJNavigationBarHeight, width: kFJWindowWidth, height: kFJWindowHeight - kFJTabBarHeight - kFJNavigationBarHeight)
        self.maskView = UIView.init(frame: frame)
        self.maskView.isUserInteractionEnabled = false
        self.view.addSubview(self.maskView)
        self.bringMenuToFront()
        self.maskView.backgroundColor = UIColor.white
        self.maskView.alpha = 0.9
        let bezierPath = UIBezierPath.init(rect: maskView.bounds)
        bezierPath.append(UIBezierPath.init(rect: imageBoardFrame).reversing())
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = bezierPath.cgPath
        self.maskView.layer.mask = shapeLayer
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

