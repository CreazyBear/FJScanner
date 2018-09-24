//
//  FJCollectorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import RealmSwift

class FJCollectorViewController: FJRootViewController {
    
    var results:[FJQRMessage] = []
    let tableView : UITableView = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.navigationController!.tabBarItem.title
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
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FJCollectTableViewCell.height(self.results[indexPath.row])
    }
}
