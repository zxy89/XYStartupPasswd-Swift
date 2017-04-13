//
//  XYCircle.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/11.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class XYCircle: UIView {
    
    //单个圆的各种状态
    enum XYCircleState {
        case Normal
        case Selected
        case Error
        case LastOneSelected
        case LastOneError
    }
    
    //单个圆的用途类型
    enum XYCircleType {
        case Gesture
        case Info
    }
    
    var type = XYCircleType.Gesture
    
    var newState: XYCircleState?
    var state: XYCircleState{
        set{
            newState = newValue
            self.setNeedsDisplay()
        }
        get{
            return newState!
        }
    }
    var newAngle: CGFloat = 0.0
    var angle: CGFloat {
        set{
            newAngle = newValue
            self.setNeedsDisplay()
        }
        get{
            return newAngle
        }
    }
    var arrow = true
    
    var outCircleColor: UIColor {
        
        get{
            switch self.state {
            case XYCircleState.Normal:
                return CircleStateNormalOutsideColor
            case XYCircleState.Selected:
                return CircleStateSelectedOutsideColor
            case XYCircleState.Error:
                return CircleStateErrorOutsideColor
            case XYCircleState.LastOneSelected:
                return CircleStateSelectedOutsideColor
            case XYCircleState.LastOneError:
                return CircleStateErrorOutsideColor
            }
        }
        
    }
    
    var inCircleColor: UIColor {
        
        get{
            switch self.state {
            case XYCircleState.Normal:
                return CircleStateNormalInsideColor
            case XYCircleState.Selected:
                return CircleStateSelectedInsideColor
            case XYCircleState.Error:
                return CircleStateErrorInsideColor
            case XYCircleState.LastOneSelected:
                return CircleStateSelectedInsideColor
            case XYCircleState.LastOneError:
                return CircleStateErrorInsideColor
            }
        }
        
    }
    
    var trangleColor: UIColor{
        get{
            switch self.state {
            case XYCircleState.Normal:
                return CircleStateNormalTrangleColor
            case XYCircleState.Selected:
                return CircleStateSelectedTrangleColor
            case XYCircleState.Error:
                return CircleStateErrorTrangleColor
            case XYCircleState.LastOneSelected:
                return CircleStateNormalTrangleColor
            case XYCircleState.LastOneError:
                return CircleStateNormalTrangleColor
            }
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        var radio: CGFloat
        let circleRect =  CGRect(x: CircleEdgeWidth, y: CircleEdgeWidth, width: rect.size.width - 2 * CircleEdgeWidth, height: rect.size.height - 2 * CircleEdgeWidth)
        
        if self.type == XYCircleType.Gesture {
            radio = CircleRadio
        }else{
            radio = 1.0
        }
        
        self.transForm(ctx: ctx!, rect: rect)
        self.drawEmptyCircle(ctx: ctx!, rect: circleRect, color: self.outCircleColor)
        self.drawSolidCircle(ctx: ctx!, rect: rect, radio: radio, color: self.inCircleColor)
        
        if self.arrow {
            self.drawTrangle(ctx: ctx!, point: CGPoint(x: rect.size.width/2.0, y: 10), length: kTrangleLength, color: self.trangleColor)
        }
        
    }
    
    //上下文旋转
    func transForm(ctx: CGContext, rect: CGRect) {
        
        let translateXY = rect.size.width * 0.5
        
        //平移
        ctx.translateBy(x: translateXY, y: translateXY)
        ctx.rotate(by: self.angle)
        
        //再平移回来
        ctx.translateBy(x: -translateXY, y: -translateXY)
        
    }
    //MARK: 画圆环
    func drawEmptyCircle(ctx: CGContext, rect: CGRect, color: UIColor) {
        
        let circlePath = CGPath(ellipseIn: rect, transform: nil)
        
        ctx.addPath(circlePath)
        ctx.setLineWidth(CircleEdgeWidth)
        ctx.setStrokeColor(color.cgColor)
        ctx.strokePath()
    
    }
    //MARK: 画实心圆
    func drawSolidCircle(ctx: CGContext, rect: CGRect, radio:CGFloat, color: UIColor) {
        
        let circlePath = CGPath(ellipseIn: CGRect(x: rect.size.width/2 * (1-radio) + CircleEdgeWidth, y: rect.size.height/2*(1-radio) + CircleEdgeWidth, width: rect.size.width * radio - CircleEdgeWidth * 2, height: rect.size.height * radio - CircleEdgeWidth * 2), transform: nil)
        
        ctx.addPath(circlePath)
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
        
    }
    //MARK: 画三角
    func drawTrangle(ctx: CGContext, point: CGPoint, length: CGFloat, color: UIColor) {
        
        ctx.move(to: point)
        ctx.addLine(to: CGPoint(x: point.x-length/2.0, y: point.y+length/2.0))
        ctx.addLine(to: CGPoint(x: point.x+length/2.0, y: point.y+length/2.0))
        ctx.closePath()
        ctx.fillPath()
        ctx.setFillColor(color.cgColor)
        
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
