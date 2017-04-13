//
//  GestureVerifyViewController.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/13.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class GestureVerifyViewController: BaseViewController, XYGesturePasswdViewDelegate {

    var isLogin = false
    
    var msgLable: XYLockLable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(red: 13.0/255.0, green: 52.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        
        self.title = "验证手势解锁"
        
        let gesturePasswdView = XYGesturePasswdView(type: XYGesturePasswdView.GestureViewType.Verify, clip: true, arrow: true, frame: CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: self.view.frame.size.height-160))
        
        gesturePasswdView.delegate = self
        
        self.view.addSubview(gesturePasswdView)
        
        self.msgLable = XYLockLable(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 14))
        self.msgLable?.center = CGPoint(x: self.view.frame.size.width/2.0, y: 120)
        
        self.view.addSubview(self.msgLable!)
        
    }

    func connectCirclesLessThanNeed(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String) {
        
    }
    
    func connectCirclesMoreThanNeedCompleteSetFirstGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String) {
        
    }
    
    func connectCirclesMoreThanNeedCompleteSetSecondGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool) {
        
    }
    
    func completeLoginGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool) {
        
        if type == XYGesturePasswdView.GestureViewType.Verify {
            
            if equal {
                
                //验证成功
                if isLogin {
                    
                    let mainVc = MainViewController()
                    mainVc.title = "首页"
                    let mainNc = UINavigationController(rootViewController: mainVc)
                    
                    let myVc = MyViewController()
                    myVc.title = "我的"
                    let myNc = UINavigationController(rootViewController: myVc)
                    
                    let tc = UITabBarController()
                    tc.viewControllers = [mainNc,myNc]
                    
                    let app = UIApplication.shared.delegate as! AppDelegate
                    
                    app.window?.rootViewController = tc
                    
                    
                }else{
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "verifyGesturePasswdSuccess"), object: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
            }else{
                
                self.msgLable?.showWarnMsgAndShake(msg: "密码错误")
                
            }
            
        }
        
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
