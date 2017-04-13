//
//  XYCircleInfoView.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/12.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class XYCircleInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.lockViewPrepare()
    }
    
    func lockViewPrepare() {
        
        self.backgroundColor = UIColor.clear
        
        for _ in 0..<9 {
            let circle = XYCircle(frame: self.frame)
            circle.type = XYCircle.XYCircleType.Info
            circle.state = XYCircle.XYCircleState.Normal
            self.addSubview(circle)
        }
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let itemViewWH: CGFloat = CircleInfoRadius*2.0
        let marginValue: CGFloat = (self.frame.size.width-3.0*itemViewWH)/3.0
        
        for k in 0..<self.subviews.count {
            
            let row = k%3
            let col = k/3
            
            let x: CGFloat = marginValue * CGFloat(row) + CGFloat(row) * itemViewWH + marginValue/2.0
            let y: CGFloat = marginValue * CGFloat(col) + CGFloat(col) * itemViewWH + marginValue/2.0
            
            let frame: CGRect = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            self.subviews[k].tag = k+1
            
            self.subviews[k].frame = frame
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
