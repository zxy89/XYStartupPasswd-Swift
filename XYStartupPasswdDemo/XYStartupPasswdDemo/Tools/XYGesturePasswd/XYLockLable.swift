//
//  XYLockLable.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/12.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit


class XYLockLable: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.viewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewPrepare() {
        
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = NSTextAlignment.center
        
    }

    /*
     *  普通提示信息
     */
    func showNormalMsg(msg: String) {
        
        self.text = msg
        self.textColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
    }
    
    /*
     *  警示信息
     */
    func showWarnMsg(msg: String) {
        
        self.text = msg
        self.textColor = UIColor.init(red: 254.0/255.0, green: 82.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        
    }
    
    /*
     *  警示信息(shake)
     */
    func showWarnMsgAndShake(msg: String) {
        
        self.text = msg
        self.textColor = UIColor.init(red: 254.0/255.0, green: 82.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        
        self.layer.shake()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CALayer {
    
    func shake() {
        
        let kfa = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        let s: CGFloat = 5.0
        
        kfa.values = [-s,0,s,0,-s,0,s,0]

        kfa.duration = 0.3
        
        kfa.repeatCount = 2
        
        kfa.isRemovedOnCompletion = true
        
        self.add(kfa, forKey: "shake")
        
    }
    
}
