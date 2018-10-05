//
//  FJMessageDetailViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/24.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import RealmSwift


class FJMessageDetailViewController: FJRootViewController {
    
    var qrMsg : FJQRMessage
    var textView = UITextView.init()
    var bottomMenu :FJBottomMenuView?
    let padding:CGFloat = 18.0
    let fontSize:CGFloat = 16.0
    
    init(qrMessage qrMsg:FJQRMessage) {
        self.qrMsg = qrMsg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupTextView()
        self.configBottonMenu()
        self.configLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "详情"
    }
    
    func setupTextView() {
        
        self.view.addSubview(self.textView)
        self.textView.text = self.qrMsg.message
        self.textView.textColor = UIColor.black
        self.textView.textAlignment = .center
        self.textView.font = UIFont.systemFont(ofSize: self.fontSize)
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .all
        let heightOfTextView = self.qrMsg.message.stringHeightWith(fontSize: self.fontSize, width: kFJWindowWidth - CGFloat(2 * padding), lineSpace: 0)
        var topPadding = (kFJWindowHeight - kFJNavigationBarHeight - heightOfTextView)/2
        if topPadding > 100 {
            topPadding -= kFJNavigationBarHeight
        }
        self.textView.contentInset = UIEdgeInsetsMake(topPadding, padding, padding, padding)
    }
    
    
    
    func configBottonMenu() {
        var menuArray:[FJBottomMenuItem] = []
        
        let menuItem1 = FJBottomMenuItem()
        menuItem1.imageName = "contact"
        menuItem1.action = {
            let vc = FJContactDetailViewController.init(qrMessage: self.qrMsg)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        menuArray.append(menuItem1)
        
        let menuItem2 = FJBottomMenuItem()
        menuItem2.imageName = "qrcode"
        menuItem2.action = {
            PHPhotoLibrary.requestAuthorization({ (status) in
                
                switch status {
                case .notDetermined:
                    self.gotoSetting()
                    break
                case .restricted:
                    //此应用程序没有被授权访问的照片数据
                    self.view.makeToast("此应用程序没有被授权访问的照片数据")
                    break
                case .denied:
                    //用户已经明确否认了这一照片数据的应用程序访问
                    self.gotoSetting()
                    break
                case .authorized:
                    DispatchQueue.main.async {
                        FJQRImageGenerateUtil.saveQRImageToPhoto(message: self.qrMsg.message, completionHandler: { (success, error) in
                            DispatchQueue.main.async {
                                if success {
                                    self.view.makeToast("二维码图片已成功保存到相册")
                                } else{
                                    self.view.makeToast("二维码图片创建失败")
                                }
                            }
                        })
                    }
                    break
                }
            })

        }
        menuArray.append(menuItem2)

        let menuItem3 = FJBottomMenuItem()
        menuItem3.imageName = "copy"
        menuItem3.action = {
            let pasteboard = UIPasteboard.general
            pasteboard.string = self.qrMsg.message
            self.view.makeToast("复制成功")
        }
        menuArray.append(menuItem3)
        
        let menuItem4 = FJBottomMenuItem()
        menuItem4.imageName = "rename"
        menuItem4.action = {
            var inputText:UITextField = UITextField();
            let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入名称", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
                if((inputText.text) != ""){
                    let realm = try! Realm()
                    let message = self.qrMsg
                    try! realm.write() {
                        message.name = inputText.text!
                    }
                    self.view.makeToast("名称修改成功")
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
            }
            //设置到当前视图
            self.present(msgAlertCtr, animated: true, completion: nil)

        }
        menuArray.append(menuItem4)

        let menuItem5 = FJBottomMenuItem()
        menuItem5.imageName = "delete"
        menuItem5.action = {
            do {
                try Realm().write {
                    try Realm().delete(self.qrMsg)
                    self.view.makeToast("已从收藏中移除")
                }
            } catch {
                self.view.makeToast("删除失败")
            }
        }
        menuArray.append(menuItem5)

        let menuItem6 = FJBottomMenuItem()
        menuItem6.imageName = "share"
        menuItem6.action = {
            let shareText = self.qrMsg.message
            let shareImage = FJQRImageGenerateUtil.setupQRCodeImage(shareText, image: nil)
            let shareItem = [shareText, shareImage] as [Any]
            let activityVC = UIActivityViewController.init(activityItems: shareItem, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToVimeo, .postToFlickr, .postToFacebook, .postToTwitter]
            self.present(activityVC, animated: true, completion: nil)
        }
        menuArray.append(menuItem6)

        self.bottomMenu = FJBottomMenuView.init(items: menuArray)
        self.view.addSubview(self.bottomMenu!)
        
    }
    
    func configLayout() {
        
        self.textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(self.view.frame.size.height - self.bottomMenu!.viewHeight - kFJNavigationBarHeight)
        }

        self.bottomMenu?.snp.makeConstraints({ (make) in

            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.textView.snp.bottom)
            make.height.equalTo(self.bottomMenu!.viewHeight)
        })
        

    }
}
