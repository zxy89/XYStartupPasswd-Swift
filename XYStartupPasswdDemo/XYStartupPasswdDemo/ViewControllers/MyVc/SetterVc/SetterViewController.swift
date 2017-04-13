//
//  SetterViewController.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/10.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit
import SwiftyJSON

class SetterViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var json: JSON = nil
    
    let kSetterTableViewCellID = "SetterTableViewCell"
    
    lazy var tableView: UITableView = {
        
        let table = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        table.dataSource = self
        table.delegate = self
        
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getSetterContentFromSetterPlist()
        
        creatSetterTableView()
        
    }
    
    func creatSetterTableView() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
            
        }
        
        self.tableView.register(SetterTableViewCell.classForCoder(), forCellReuseIdentifier: kSetterTableViewCellID)
        
    }

    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return json["section"].count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json["section"][section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SetterTableViewCell = tableView.dequeueReusableCell(withIdentifier: kSetterTableViewCellID, for: indexPath) as! SetterTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let detail: String?
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                switch UserDefaults.standard.integer(forKey: "StartupPasswdStyle") {
                case 0:
                    detail = "无"
                case 1:
                    detail = "手势密码"
                case 2:
                    detail = "Touch ID"
                default:
                    detail = "无"
                }
            default:
                detail = nil
            }
        default:
            detail = nil
        }
        
        cell.displayData(name: json["section"][indexPath.section][indexPath.row].rawString()!, detail: detail!)
        
        return cell
        
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                
                
                
                NotificationCenter.default.addObserver(self, selector: #selector(changeStartupPasswd), name: NSNotification.Name(rawValue: "changeStartupPasswd"), object: nil)
                
                let startupVc = StartupPasswdViewController()
                startupVc.title = "启动密码"
                
                self.navigationController?.pushViewController(startupVc, animated: true)
            default:
                break
            }
        default:
            break
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        }
        return 6
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == json["section"].count - 1 {
            return 12
        }
        return 6
    }
    
    //MARK: 接到更换启动密码方式的通知
    func changeStartupPasswd() {
        
        self.tableView.reloadData()
        
    }
    
    //MARK: 获取设置列表项
    func getSetterContentFromSetterPlist() {
        
        let dic = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "setter", ofType: ".plist")!)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dic!, options: .prettyPrinted)
        
        json = JSON(data: jsondata!)
        
        print(json)
        
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
