//
//  XYTouchID.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/10.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit
import LocalAuthentication

class XYTouchID: NSObject {

    func openTouchIDVertify(result:@escaping (Bool) -> Void){
        let laContext = LAContext()
        var error: NSError?
        
        if laContext.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: &error) {
            
            laContext.evaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, localizedReason: "请用指纹解锁", reply: { (success, error) in
                
                if success {
                    
                    result(success)
                    
                }
                
                if let error = error as NSError? {
                    
                    let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                    
                    print(message)
                    
                }
                
            })
            
        }else{
            
            print("您的设备不支持Touch ID")
            
        }
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            //            showPassWordInput()
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
}
