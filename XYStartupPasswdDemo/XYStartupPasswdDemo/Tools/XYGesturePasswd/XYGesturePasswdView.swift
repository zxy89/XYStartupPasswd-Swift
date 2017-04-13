//
//  XYGesturePasswdView.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/11.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit



protocol XYGesturePasswdViewDelegate {
    
    //连线个数少于4个时，通知代理
    func connectCirclesLessThanNeed(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String)
    
    // 连线个数多于或等于4个，获取到第一个手势密码时通知代理
    func connectCirclesMoreThanNeedCompleteSetFirstGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String)
    
    //获取到第二个手势密码时通知代理
    func connectCirclesMoreThanNeedCompleteSetSecondGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool)
    
    //登陆或者验证手势密码输入完成时的代理方法
    func completeLoginGesture(view: XYGesturePasswdView, type: XYGesturePasswdView.GestureViewType, gesture: String, equal: Bool)
}


class XYGesturePasswdView: UIView {

    //手势密码界面用途类型
    enum GestureViewType {
        case Setting
        case Login
        case Verify
    }
    
    var type = GestureViewType.Setting
    var clip = true
    var arrow = true
    
    var circleSet = Array<XYCircle>()
    var hasClean = false
    
    var currentPoint: CGPoint = CGPoint.zero
    
    /**
     *  type    解锁类型
     *  clip    是否剪裁 default is YES
     *  arrow   是否有箭头 default is YES
     */
    init(type: GestureViewType, clip: Bool, arrow: Bool, frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 13.0/255.0, green: 52.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        
        self.type = type
        self.clip = clip
        self.arrow = arrow

        lockViewPrepare()
        
    }
    
    var delegate: XYGesturePasswdViewDelegate?
    
    func lockViewPrepare() {

        for _ in 0..<9 {
            let circle = XYCircle(frame: self.frame)
            circle.type = XYCircle.XYCircleType.Gesture
            circle.state = XYCircle.XYCircleState.Normal
            circle.arrow = true
            self.addSubview(circle)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.circleSet.count == 0 {
            return
        }
        var color: UIColor = UIColor.init(red: 34.0/255.0, green: 178.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        if self.getCircleState() == XYCircle.XYCircleState.Error {
            color = UIColor.init(red: 254.0/255.0, green: 82.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        }
        
        self.connectCircles(rect: rect, color: color)
        
    }
    
    //MARK: 连线绘制图案(以设定颜色绘制)
    func connectCircles(rect: CGRect, color: UIColor) {
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        //添加路径
        ctx?.addRect(rect)
        
        //是否剪裁
        self.clipSubviewsWhenConnect(ctx: ctx!, clip: self.clip)
        
        //剪裁上下文
        ctx?.clip()
        
        for k in 0..<self.circleSet.count {
            
            let circle = self.circleSet[k]
            
            if k==0 {
                ctx?.move(to: CGPoint(x: circle.center.x, y: circle.center.y))
            }else{
                ctx?.addLine(to: CGPoint(x: circle.center.x, y: circle.center.y))
            }
            
        }
        
        // 连接最后一个按钮到手指当前触摸得点
        if !(self.currentPoint.x == CGPoint.zero.x && self.currentPoint.y == CGPoint.zero.y) {
            
            for _ in 0..<self.subviews.count {
                
//                let circle = self.subviews[k] as! XYCircle
                
                if self.getCircleState() == XYCircle.XYCircleState.Error || self.getCircleState() == XYCircle.XYCircleState.LastOneError {
                    
                } else {
                  ctx?.addLine(to: self.currentPoint)
                }
                
            }
            
        }
        
        //线条转角样式
        ctx?.setLineCap(CGLineCap.round)
        ctx?.setLineJoin(CGLineJoin.round)
        
        // 设置绘图的属性
        ctx?.setLineWidth(1.0)
        
        // 线条颜色
        ctx?.setStrokeColor(color.cgColor)
        
        //渲染路径
        ctx?.strokePath()
        
    }
    //MARK: 是否剪裁子控件
    func clipSubviewsWhenConnect(ctx: CGContext, clip: Bool) {
        
        if clip {
            for k in 0..<self.subviews.count {
                let circle = self.subviews[k] as! XYCircle
                ctx.addEllipse(in: circle.frame)    // 确定"剪裁"的形状
            }
        }
        
    }
    
    //MARK: 获取当前选中圆的状态
    func getCircleState() -> XYCircle.XYCircleState {
        return (self.circleSet.first?.state)!
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let itemViewWH: CGFloat = CircleRadius*2.0
        let marginValue = (self.frame.size.width - 3.0 * itemViewWH) / 3.0;
        
        for k in 0..<self.subviews.count {
            
            let row = k%3
            let col = k/3
            let x: CGFloat = marginValue*CGFloat(row)+CGFloat(row)*itemViewWH+marginValue/2.0
            let y: CGFloat = marginValue*CGFloat(col)+CGFloat(col)*itemViewWH+marginValue/2.0
            
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            subviews[k].tag = k+1
            
            subviews[k].frame = frame
            
        }
        
    }
    //MARK: touch began - moved - end
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("-----")
        
        self.gestureEndResetMembers()
        
        self.currentPoint = CGPoint.zero
        let touch = touches.first
        let point = touch?.location(in: self)
        
        for k in 0..<self.subviews.count {
            let circle = self.subviews[k] as! XYCircle
            
            if (point?.x)! >= circle.frame.origin.x && (point?.x)! <= circle.frame.origin.x+circle.frame.size.width && (point?.y)! >= circle.frame.origin.y && (point?.y)! <= circle.frame.origin.y+circle.frame.size.height {
                
                circle.state = XYCircle.XYCircleState.Selected
             
                self.circleSet.append(circle)
            }
        }
        
        self.circleSetLastObject(state: XYCircle.XYCircleState.Selected)
        
        self.setNeedsDisplay()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.currentPoint = CGPoint.zero
        let touch = touches.first
        let point = touch?.location(in: self)
        
        
        for k in 0..<self.subviews.count {
            let circle = self.subviews[k] as! XYCircle
         
            if (point?.x)! >= circle.frame.origin.x && (point?.x)! <= circle.frame.origin.x+circle.frame.size.width && (point?.y)! >= circle.frame.origin.y && (point?.y)! <= circle.frame.origin.y+circle.frame.size.height {
                
                if self.circleSet.contains(circle) {
                    
                }else{
                    self.circleSet.append(circle)
                    
                    // move过程中的连线（包含跳跃连线的处理）
                    self.calAngleAndconnectTheJumpedCircle()
                }
                
            }else{
                
                self.currentPoint = point!
                
            }
            
        }
        
        for k in 0..<self.circleSet.count {
            
            let circle = self.circleSet[k]
            
            if self.type != GestureViewType.Setting {
                
                circle.state = XYCircle.XYCircleState.Selected
                
            }
            
        }
        
        self.circleSetLastObject(state: XYCircle.XYCircleState.Selected)
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.hasClean = false
        
        let gesture = self.getGestureResult(circleSet: self.circleSet)
        
        let length = (gesture as NSString).length
        
        if length == 0 {
            return
        }
        
        switch self.type {
        case GestureViewType.Setting:
            self.gestureEndByTypeSetting(gesture: gesture, length: CGFloat(length))
        case GestureViewType.Login:
            self.gestureEndByTypeLogin(gesture: gesture, length: CGFloat(length))
        case GestureViewType.Verify:
            self.gestureEndByTypeVerify(gesture: gesture, length: CGFloat(length))
        }
        
        // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
        self.errorToDisplay()
        
    }
    //MARK: 是否错误回显重绘
    func errorToDisplay() {
        
        if self.getCircleState() == XYCircle.XYCircleState.Error || self.getCircleState() == XYCircle.XYCircleState.LastOneError {
            
            DispatchQueue.main.async {
                
                self.gestureEndResetMembers()
                
            }
            
        }else{
            
            self.gestureEndResetMembers()
            
        }
        
    }
    //MARK: // 手势绘制结果处理
    func gestureEndByTypeSetting(gesture: String, length: CGFloat) {
        
        if length < 4 {
            // 连接少于最少个数 （<4个）
            // 1.通知代理
            self.delegate?.connectCirclesLessThanNeed(view: self, type: self.type, gesture: gesture)
            
            self.changeCircleInCircleSet(state: XYCircle.XYCircleState.Error)
        }else{// 连接多于最少个数 （>=4个）
            
            let gestureOne = UserDefaults.standard.string(forKey: "gestureOneSaveKey")
            
            if gestureOne == nil || (gestureOne! as NSString).length < 4 {
                // 记录第一次密码
                UserDefaults.standard.set(gesture, forKey: "gestureOneSaveKey")
                UserDefaults.standard.synchronize()
                // 通知代理
                self.delegate?.connectCirclesMoreThanNeedCompleteSetFirstGesture(view: self, type: self.type, gesture: gesture)
                
            }else{
                
                let equal = (gesture as NSString).isEqual(to: UserDefaults.standard.string(forKey: "gestureOneSaveKey")!)  //匹配两次手势
                
                self.delegate?.connectCirclesMoreThanNeedCompleteSetSecondGesture(view: self, type: self.type, gesture: gesture, equal: equal)
                
                if equal {
                    UserDefaults.standard.set(gesture, forKey: "gestureFinalSaveKey")
                    UserDefaults.standard.synchronize()
                }else{
                    self.changeCircleInCircleSet(state: XYCircle.XYCircleState.Error)
                }
                
            }
            
        }
        
    }
    
    //MARK: 解锁类型：登陆 手势路径的处理
    func gestureEndByTypeLogin(gesture: String, length: CGFloat) {
        
        let passwd = UserDefaults.standard.string(forKey: "gestureFinalSaveKey")
        
        let equal = (gesture as NSString).isEqual(to: passwd!)
        
        self.delegate?.completeLoginGesture(view: self, type: self.type, gesture: gesture, equal: equal)
        
        if equal {
            
        }else{
            
            self.changeCircleInCircleSet(state: XYCircle.XYCircleState.Error)
            
        }
        
    }
    
    //MARK: 解锁类型：验证 手势路径的处理
    func gestureEndByTypeVerify(gesture: String, length: CGFloat) {
        self.gestureEndByTypeLogin(gesture: gesture, length: length)
    }
    
    //MARK: 将circleSet数组解析遍历，拼手势密码字符串
    func getGestureResult(circleSet: Array<XYCircle>) -> String {
        
        var gesture: String = String()
        
        for k in 0..<self.circleSet.count {
            let circle = self.circleSet[k]
            gesture.append("\(circle.tag)")
        }
        
        return gesture
    }
    
    //MARK: 每添加一个圆，就计算一次方向
    func calAngleAndconnectTheJumpedCircle() {
        
        if self.circleSet.count == 0 {
            return
        }
        
        let lastOne = self.circleSet.last
        
        let lastTwo = self.circleSet[self.circleSet.count-2]
        
        let last_1_x = lastOne?.center.x
        let last_1_y = lastOne?.center.y
        
        let last_2_x = lastTwo.center.x
        let last_2_y = lastTwo.center.y
        
        let angle: CGFloat = atan2(last_1_y!-last_2_y, last_1_x!-last_2_x) + CGFloat(M_PI_2)
        
        lastTwo.angle = angle
        
        //处理跳跃连线
        let center = self.centerPoint(pointOne: (lastOne?.center)!, pointTwo: lastTwo.center)
        
        let centerCircle = self.enumCircleSetToFindWhichSubviewContainTheCenterPoint(point: center)
        
        if centerCircle != nil {
            
            // 把跳过的圆加到数组中，它的位置是倒数第二个
            if !self.circleSet.contains(centerCircle!) {
                self.circleSet.insert(centerCircle!, at: self.circleSet.count-1)
            }
            
        }
        
    }
    
    /**
     *  给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
     *
     *  @param point 当前点
     *
     *  @return 点所在的圆
     */
    func enumCircleSetToFindWhichSubviewContainTheCenterPoint(point: CGPoint) ->XYCircle? {
        
        var centerCircle: XYCircle?
        
        for k in 0..<self.subviews.count {
            let circle = self.subviews[k] as! XYCircle
            
            if (point.x) >= circle.frame.origin.x && (point.x) <= circle.frame.origin.x+circle.frame.size.width && (point.y) >= circle.frame.origin.y && (point.y) <= circle.frame.origin.y+circle.frame.size.height {
                centerCircle = circle
            }
        }
        
        if centerCircle != nil {
            if !self.circleSet.contains(centerCircle!) {
                centerCircle?.angle = self.circleSet[self.circleSet.count - 2].angle
            }
            return centerCircle!
        }else{
            return nil// 注意：可能返回的是nil，就是当前点不在圆内
        }
        
    }
    
    //MARK: 处理跳跃连线
    func centerPoint(pointOne: CGPoint, pointTwo: CGPoint) -> CGPoint {
        
        let x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x
        let x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x
        let y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y
        let y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y
        
        return CGPoint(x: (x1+x2)/2, y: (y1+y2)/2)
        
    }
    
    //MARK: 数组中最后一个对象的处理
    func circleSetLastObject(state: XYCircle.XYCircleState) {
        
        self.circleSet.last?.state = state
        
    }
    
    //MARK: 手势结束时的清空操作
    func gestureEndResetMembers() {
        
        if !hasClean {
            // 手势完毕，选中的圆回归普通状态
            self.changeCircleInCircleSet(state: XYCircle.XYCircleState.Normal)
            
            self.circleSet.removeAll()
            
            self.hasClean = true
        }
        
    }
    //MARK: 改变选中数组CircleSet子控件状态
    func changeCircleInCircleSet(state: XYCircle.XYCircleState) {
        
        for k in 0..<self.circleSet.count {
            
            let circle = self.circleSet[k]
            
            circle.state = state
            
            if state == XYCircle.XYCircleState.Error {
                if k==self.circleSet.count-1 {
                    circle.state = XYCircle.XYCircleState.LastOneError
                }
            }
            
        }
        
        self.setNeedsDisplay()
        
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
