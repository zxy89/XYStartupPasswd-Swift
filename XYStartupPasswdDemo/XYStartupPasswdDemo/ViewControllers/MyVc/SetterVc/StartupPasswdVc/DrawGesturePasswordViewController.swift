//
//  DrawGesturePasswordViewController.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/11.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit


enum GestureViewControllerType {
    case Setting
    case Login
}

class DrawGesturePasswordViewController: BaseViewController, XYGesturePasswdViewDelegate {

    
    var gesturePasswdView: XYGesturePasswdView?
    
    var msgLabel: XYLockLable?
    
    var infoView: XYCircleInfoView?
    
    var type: GestureViewControllerType = GestureViewControllerType.Setting
    
    var reset: UIButton?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set(nil, forKey: "gestureOneSaveKey")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(red: 13.0/255.0, green: 52.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        
        self.setupSameUI()
        
        self.setupDifferentUI()
    }
    
    //MARK: 创建ResetButton
    func creatResetButton() {
        
        self.reset = UIButton(type: .custom)
        self.reset?.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.reset?.setImage(UIImage(named: "reset_drawGesture"), for: .normal)
        self.reset?.addTarget(self, action: #selector(resetClick), for: .touchUpInside)
        self.reset?.isHidden = true
        
        let rightItem = UIBarButtonItem(customView: self.reset!)
        
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    func resetClick() {
        
        // 1.隐藏按钮
        self.reset?.isHidden = true
        // 2.infoView取消选中
        self.infoViewDeselectedSubviews()
        // 3.msgLabel提示文字复位
        self.msgLabel?.showNormalMsg(msg: "绘制解锁图案")
        // 4.清除之前存储的密码
        UserDefaults.standard.set(nil, forKey: "gestureOneSaveKey")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: 界面不同部分生成器
    func setupDifferentUI() {
        
        switch self.type {
        case GestureViewControllerType.Setting:
            self.setupSubViewsSettingVc()
        case GestureViewControllerType.Login:
            self.setupSubViewsLoginVc()
        }
        
    }
    
    //MARK: 界面相同部分生成器
    func setupSameUI() {
        
        self.creatResetButton()
        
        self.gesturePasswdView = XYGesturePasswdView(type: XYGesturePasswdView.GestureViewType.Setting, clip: true, arrow: true, frame: CGRect(x: 0, y: 160, width: self.view.frame.size.width, height: self.view.frame.size.height-160))
        
        gesturePasswdView?.delegate = self
        
        self.view.addSubview(gesturePasswdView!)
        
        self.msgLabel = XYLockLable(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 14))
        self.msgLabel?.center = CGPoint(x: self.view.frame.size.width/2.0, y: 140)
        
        self.view.addSubview(self.msgLabel!)
  
    }
    //MARK: 设置手势密码界面
    func setupSubViewsSettingVc() {
        
        self.gesturePasswdView?.type = XYGesturePasswdView.GestureViewType.Setting
        
        self.msgLabel?.showNormalMsg(msg: "绘制解锁图案")
        
        self.infoView = XYCircleInfoView(frame: CGRect(x: 0, y: 0, width: 30.0*2.0*0.6, height:30.0*2.0*0.6))
        
        self.infoView?.center = CGPoint(x: self.view.frame.size.width/2.0, y: (self.msgLabel?.frame.origin.y)!-30.0*2.0*0.6/2.0-10)
        
        self.view.addSubview(self.infoView!)
        
    }
    //MARK: 登陆手势密码界面
    func setupSubViewsLoginVc() {
        
        self.gesturePasswdView?.type = XYGesturePasswdView.GestureViewType.Login
        
    }
    //MARK: XYGesturePasswdView - delegate - setting
    func connectCirclesLessThanNeed(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String) {
        
        let gestureOne = UserDefaults.standard.string(forKey: "gestureOneSaveKey")
        
        if gestureOne == nil {
            
            print("密码长度不合法\(gesture)")
            self.msgLabel?.showWarnMsgAndShake(msg: "最少连接4个点，请重新输入")
            
        }else{
            self.reset?.isHidden = false
            self.msgLabel?.showWarnMsgAndShake(msg: "与上次绘制不一致，请重新绘制")
        }
        
    }
    
    func connectCirclesMoreThanNeedCompleteSetFirstGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String) {
        
        self.msgLabel?.showWarnMsg(msg: "再次绘制解锁图案")
        
        self.infoViewSelectedSubviewsSameAsCircleView(circleView: view)
        
    }
    
    func connectCirclesMoreThanNeedCompleteSetSecondGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool) {
        
        if equal {
            
            UserDefaults.standard.set(gesture, forKey: "gestureFinalSaveKey")
            
            self.msgLabel?.showWarnMsg(msg: "设置成功")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setGesturePasswdSuccess"), object: nil)
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
            
            self.reset?.isHidden = false
            self.msgLabel?.showWarnMsgAndShake(msg: "与上次绘制不一致，请重新绘制")
            print("两次手势不匹配！")
            
        }
        
    }
    
    //MARK: XYGesturePasswdView delegate login or verify gesture
    func completeLoginGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool) {
        
        if type == XYGesturePasswdView.GestureViewType.Login {
            if equal {
                
                //登陆成功
                
            }else{
                self.msgLabel?.showWarnMsgAndShake(msg: "密码错误")
            }
        }else if type == XYGesturePasswdView.GestureViewType.Verify{
            
            if equal {
                print("验证成功，跳转到设置手势界面")
            }else{
                print("原手势密码输入错误！")
            }
            
        }
        
    }
    
    //MARK: 让infoView(缩略图)对应按钮选中
    func infoViewSelectedSubviewsSameAsCircleView(circleView: XYGesturePasswdView) {
        
        for k in 0..<circleView.subviews.count {
            
            let circle = circleView.subviews[k] as! XYCircle
            if circle.state == XYCircle.XYCircleState.Selected || circle.state == XYCircle.XYCircleState.LastOneSelected {
                
                for m in 0..<(self.infoView?.subviews)!.count {
                    let infoCircle = self.infoView?.subviews[m] as! XYCircle
                    if infoCircle.tag == circle.tag {
                        infoCircle.state = XYCircle.XYCircleState.Selected
                    }
                }
                
            }
            
        }
        
    }

    //MARK: 让infoView(缩略图)对应按钮取消选
    func infoViewDeselectedSubviews() {
        
        for k in 0..<(self.infoView?.subviews.count)! {
            
            let infoCircle = self.infoView?.subviews[k] as! XYCircle
            
            infoCircle.state = XYCircle.XYCircleState.Normal
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you willvarten want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
