//
//  Helper.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Helper: NSObject {

    static let shared = Helper()
    private override init() {}
    
    var tempRegisterDict: [String:Any] = [:]
    var arrTomar_QA:[[String:Any]] = []
    var canUploadWithoutWifi:Bool = false
    var userImage:UIImage!
    var baseGlobalDict:[String:Any] = [:]
}

