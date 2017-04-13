//
//  MyViewController.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/10.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        creatNavBarRightSetterItem()
        
    }
    
    //MARK: 创建导航栏右侧设置按钮
    func creatNavBarRightSetterItem() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "my_navbar_setter"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightItemClick))
        
    }
    
    //MARK: 设置按钮事件
    func rightItemClick() {
        
        let setterVc = SetterViewController()
        setterVc.title = "设置"
        setterVc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(setterVc, animated: true)
        
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
