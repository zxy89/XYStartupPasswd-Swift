//
//  StartupPasswdViewController.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/10.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit


class StartupPasswdViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    private let kDeatultTableViewCellID = "UITableViewCell"
    
    private let nameArray = ["关闭","启用手势密码","启用TouchID"]
    
    private var index = 0
    
    lazy var tableView: UITableView = {
        
        let table = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        table.dataSource = self
        table.delegate = self
        
        return table
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        index = UserDefaults.standard.integer(forKey: "StartupPasswdStyle")
        
        creatStartupPasswdTableView()
        
    }

    
    func creatStartupPasswdTableView() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
            
        }
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: kDeatultTableViewCellID)
        
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kDeatultTableViewCellID, for: indexPath)
        
        cell.textLabel?.text = self.nameArray[indexPath.row]
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if self.index == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.index == indexPath.row {
            return
        }
        
        if self.index == 1 && indexPath.row == 0 {
            
            NotificationCenter.default.addObserver(self, selector: #selector(verifyGesturePasswdSuccess), name: NSNotification.Name(rawValue: "verifyGesturePasswdSuccess"), object: nil)
            
            //关闭手势密码
            let verifyGesturePasswdVc = GestureVerifyViewController()
            
            verifyGesturePasswdVc.isLogin = false
            
            self.navigationController?.pushViewController(verifyGesturePasswdVc, animated: true)
            
        }
        
        if self.index == 2 && indexPath.row == 0 {
            
            //关闭Touch ID
            setTouchID(index: indexPath.row)
            
        }
        
        switch indexPath.row {
        case 0:
            self.setCurrentIndex(index: index)
        case 1:
            
            NotificationCenter.default.addObserver(self, selector: #selector(setGesturePasswdSuccess), name: NSNotification.Name(rawValue: "setGesturePasswdSuccess"), object: nil)
            
            let drawGesturePasswdVc = DrawGesturePasswordViewController()
            
            drawGesturePasswdVc.title = "设置手势密码"
            drawGesturePasswdVc.type = GestureViewControllerType.Setting
            
            self.navigationController?.pushViewController(drawGesturePasswdVc, animated: true)
        case 2:
            setTouchID(index: indexPath.row)
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //MARK: 接到验证手势密码成功通知
    func verifyGesturePasswdSuccess() {
        
        UserDefaults.standard.set(nil, forKey: "gestureOneSaveKey")
        UserDefaults.standard.synchronize()
        
        self.setCurrentIndex(index: 0)
        
    }
    
    //MARK: 接到设置手势密码成功通知
    func setGesturePasswdSuccess() {
        
        self.setCurrentIndex(index: 1)
        
    }
    
    //MARK: 设置当前选中解锁方式并刷新UI
    func setCurrentIndex(index: NSInteger) {
        
        UserDefaults.standard.set(index, forKey: "StartupPasswdStyle")
        UserDefaults.standard.synchronize()
        
        self.index = index
        
        tableView.reloadData()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeStartupPasswd"), object: nil)
        
    }
    //MARK: 设置指纹解锁
    func setTouchID(index: NSInteger) {
        
        XYTouchID().openTouchIDVertify { (success) in
            
            if success {
                
                DispatchQueue.main.async {
                    self.setCurrentIndex(index: index)
                }
                
            }
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
