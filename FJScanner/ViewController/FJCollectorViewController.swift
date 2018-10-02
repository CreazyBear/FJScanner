//
//  FJCollectorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class FJCollectorViewController: FJRootViewController {
    
    var results:[FJQRMessage] = []
    let tableView : UITableView = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupDataSource()
        self.setupTableView()
        
    }
    
    //MARK: - setup datasource
    func setupDataSource() {

        self.results = try! Realm().objects(FJQRMessage.self).filter("message <> ''").sorted(by: { (ele1, ele2) -> Bool in
            return ele1.createDate>ele2.createDate
        })
        self.tableView.reloadData()
    }
    
    //MARK: - setup views
    func setupTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FJCollectTableViewCell.self, forCellReuseIdentifier: String.init(describing: FJCollectTableViewCell.self))
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight)
        }
    }
}


extension FJCollectorViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: String.init(describing: FJCollectTableViewCell.self), for: indexPath)
        if cell.isKind(of: FJCollectTableViewCell.self) {
            (cell as! FJCollectTableViewCell).bindData(self.results[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = FJMessageDetailViewController(qrMessage: self.results[indexPath.row])
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FJCollectTableViewCell.height(self.results[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "删除") { (action, sourceView, completionHandler) in
            
            do {
                try Realm().write {
                    try Realm().delete(self.results[indexPath.row])
                }
                self.setupDataSource()
            } catch {
                self.view.makeToast("删除失败")
            }
        }
        deleteAction.backgroundColor = UIColor.red
        
        let changeNameAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "改名") { (action, sourceView, completionhandler) in
            var inputText:UITextField = UITextField();
            let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入名称", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
                if((inputText.text) != ""){
                    let realm = try! Realm()
                    let message = self.results[indexPath.row]
                    try! realm.write() {
                        message.name = inputText.text!
                    }
                    self.setupDataSource()
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
        changeNameAction.backgroundColor = UIColor.blue
        
        let config = UISwipeActionsConfiguration.init(actions: [deleteAction,changeNameAction])
        return config
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let generateAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "生成\n二维码") { (action, sourceView, completionHandler) in
            
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
                        self.saveQRImageToPhoto(message: self.results[indexPath.row].message)
                    }
                    break
                }
            })
            
        }
        generateAction.backgroundColor = UIColor.orange
        
        
        let copyAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "复制") { (action, sourceView, handler) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = self.results[indexPath.row].message
            self.view.makeToast("复制成功")
        }
        copyAction.backgroundColor = UIColor.brown
        
        let shareAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "分享") { (action, sourceView, handler) in
            let shareText = self.results[indexPath.row].message
            let shareImage = FJQRImageGenerateUtil.setupQRCodeImage(shareText, image: nil)
            let shareItem = [shareText, shareImage] as [Any]
            let activityVC = UIActivityViewController.init(activityItems: shareItem, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToVimeo, .postToFlickr, .postToFacebook, .postToTwitter]
            self.present(activityVC, animated: true, completion: nil)
//            activityVC.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in }
            
        }
        shareAction.backgroundColor = UIColor.magenta
        
        let config = UISwipeActionsConfiguration.init(actions: [generateAction,copyAction,shareAction])
        return config

    }
    
    func saveQRImageToPhoto(message:String) {

        let image = FJQRImageGenerateUtil.setupQRCodeImage(message, image: nil)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
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
    
    //去设置权限
    func gotoSetting(){
        
        let alertController:UIAlertController = UIAlertController.init(title: "设置应用权限",
                                                                       message: "设置 -> 通用 ->",
                                                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let sure:UIAlertAction = UIAlertAction.init(title: "去开启权限", style: UIAlertActionStyle.default) { (ac) in
            
            let url=URL.init(string: UIApplicationOpenSettingsURLString)
            
            if UIApplication.shared.canOpenURL(url!){
                
                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist) in
                    
                })
            }
        }
        alertController.addAction(sure)
        self.present(alertController, animated: true, completion: nil)
    }
}
