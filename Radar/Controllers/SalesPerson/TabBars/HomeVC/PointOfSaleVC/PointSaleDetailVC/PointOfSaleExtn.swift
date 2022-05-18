//
//  PointOfSaleExtn.swift
//  Radar
//
//  Created by Shalini Sharma on 31/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import Foundation
import UIKit

extension PointSaleDetailVC
{
    func callPosValidate(has_coordinates:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        var param: [String:Any] = [:]
        
        if has_coordinates == "0"
        {
            param = ["uuid":uuid, "has_coordinates":has_coordinates]
        }
        else
        {
            param = ["uuid":uuid, "has_coordinates":has_coordinates, "latitude":self.userCurrentLocCord.latitude, "longitude":self.userCurrentLocCord.longitude]
         //   print(param)
        }
        
        WebService.requestService(url: ServiceName.POST_POS_Validate, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //     print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                if has_coordinates == "0"
                                {
                                    // fill 3 arrays and (rewards dict in main array) - zone, type, states
                                    if let arr:[[String:Any]] = dict["zones"] as? [[String:Any]]
                                    {
                                        self.arrPicker_Zone = arr
                                        if arr.count > 0
                                        {
                                            let dk:[String:Any] = arr.first!
                                            
                                            if let str:String = dk["zone_id"] as? String
                                            {
                                                self.zone_id = str
                                            }
                                            if let str:String = dk["zone_name"] as? String
                                            {
                                                self.arrData[1] = ["type":"pickerZone", "value":dk, "string":str, "ph":"Zona", "height":70.0]
                                            }
                                        }
                                    }
                                    if let arr:[[String:Any]] = dict["pos_types"] as? [[String:Any]]
                                    {
                                        self.arrPicker_TypePos = arr
                                        if arr.count > 0
                                        {
                                            let dk:[String:Any] = arr.first!
                                            
                                            if let str:Int = dk["pos_type"] as? Int
                                            {
                                                self.pos_type = "\(str)"
                                            }
                                            if let str:String = dk["pos_type_str"] as? String
                                            {
                                                self.arrData[2] = ["type":"pickerType", "value":dk, "string":str, "ph":"Tipo", "height":70.0]                                                    
                                            }
                                        }
                                    }
                                    if let arr:[String] = dict["states"] as? [String]
                                    {
                                        self.arrPicker_State = arr
                                    }
                                    if let d:[String:Any] = dict["rewards"] as? [String:Any]
                                    {
                                        if let desc:String = d["description"] as? String
                                        {
                                            if let rewd:String = d["reward_str"] as? String
                                            {
                                                self.arrData[7] = ["type":"rewards", "description":desc, "value":rewd, "height":115.0]
                                            }
                                        }
                                    }
                                    self.tblView.reloadData()
                                }
                                else
                                {
                                    // has_coordinates == 1
                                    // fill 2 arrays and (rewards dict in main array) - zone, type
                                    
                                    if let check:Int = dict["current_zone_index"] as? Int
                                    {
                                        self.current_zone_index = check
                                    }
                                    
                                    if let check:Int = dict["place_id"] as? Int
                                    {
                                        self.place_id = "\(check)"
                                    }
                                    if let check:String = dict["place_id"] as? String
                                    {
                                        self.place_id = check
                                    }
                                    if let check:String = dict["short_formatted_address"] as? String
                                    {
                                        self.short_formatted_address = check
                                    }
                                    if let check:String = dict["address_message"] as? String
                                    {
                                        self.address_message = check
                                    }
                                    
                                    if let arr:[[String:Any]] = dict["zones"] as? [[String:Any]]
                                    {
                                        self.arrPicker_Zone = arr
                                        
                                        if self.current_zone_index != nil
                                        {
                                            if self.current_zone_index >= 0
                                            {
                                                if arr.count > 0
                                                {
                                                    let dk:[String:Any] = arr[self.current_zone_index]
                                                    
                                                    if let str:String = dk["zone_id"] as? String
                                                    {
                                                        self.zone_id = str
                                                    }
                                                    if let str:String = dk["zone_name"] as? String
                                                    {
                                                        self.arrData[1] = ["type":"pickerZone", "value":dk, "string":str, "ph":"Zona", "height":70.0]
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if let arr:[[String:Any]] = dict["pos_types"] as? [[String:Any]]
                                    {
                                        self.arrPicker_TypePos = arr
                                        if arr.count > 0
                                        {
                                            let dk:[String:Any] = arr.first!
                                            
                                            if let str:Int = dk["pos_type"] as? Int
                                            {
                                                self.pos_type = "\(str)"
                                            }
                                            if let str:String = dk["pos_type_str"] as? String
                                            {
                                                self.arrData[2] = ["type":"pickerType", "value":dk, "string":str, "ph":"Tipo", "height":70.0]
                                            }
                                        }
                                    }
                                    if let d:[String:Any] = dict["rewards"] as? [String:Any]
                                    {
                                        if let desc:String = d["description"] as? String
                                        {
                                            if let rewd:String = d["reward_str"] as? String
                                            {
                                                self.arrData[7] = ["type":"rewards", "description":desc, "value":rewd, "height":115.0]
                                            }
                                        }
                                    }
                                    
                                  //  self.callSearchAddresses_Yes()
                                    DispatchQueue.main.async {
                                        self.tblView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSearchAddresses_No()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["zone_id":zone_id, "street_name":street_name, "street_number": street_number, "neighborhood":neighborhood, "municipality":municipality, "state":state, "zip_code": zip_code]
       // print(param)
        WebService.requestService(url: ServiceName.POST_POS_SearchAddress, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                            
                            self.showAlertWithTitle(title: "Alerta", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.arrPicker_Addresses.removeAll()
                            
                            if let arr:[[String:Any]] = dict["addresses"] as? [[String:Any]]
                            {
                                for ind in 0..<arr.count
                                {
                                    var dicy:[String:Any] = arr[ind]
                                    dicy["selected"] = false
                                    self.arrPicker_Addresses.append(dicy)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSearchAddresses_Yes()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["zone_id":zone_id, "latitude":self.userCurrentLocCord.latitude, "longitude":self.userCurrentLocCord.longitude]
      //  print(param)
        WebService.requestService(url: ServiceName.POST_POS_Yes_Address, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Alerta", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                            
                            self.showAlertWithTitle(title: "Alerta", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = dict["addresses"] as? [[String:Any]]
                            {
                                if arr.count > 0
                                {
                                    let dicy:[String:Any] = arr.first!
                                    if let str:String = dict["short_formatted_address"] as? String
                                    {
                                        self.short_formatted_address = str
                                    }
                                    if let strId:String = dicy["place_id"] as? String
                                    {
                                        self.place_id = strId
                                    }
                                }
                                else
                                {
                                    if let str:String = dict["message"] as? String
                                    {
                                        self.short_formatted_address = str
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSubmitApi()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id, "pos_name":pos_name, "pos_type": pos_type, "media_id":media_id, "place_id":place_id, "in_location":in_location, "comments":comments, "street_number":street_number]
      //  print(param)
        WebService.requestService(url: ServiceName.POST_POS_Register, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //     print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            if msg == "Place ID can't be empty."{
                                self.showAlertWithTitle(title: "Radar", message: "No te encuentras presente en la zona seleccionada.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return
                            }
                            else{
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return
                            }
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                // call protocol for rewardsd popup
                               
                                var strTitle = ""
                                var strDesc = ""
                                var strRewards = ""
                                
                                if let str:String = d["title"] as? String
                                {
                                    strTitle = str
                                }
                                if let str:String = d["description"] as? String
                                {
                                    strDesc = str
                                }
                                if let str:String = d["reward_str"] as? String
                                {
                                    strRewards = str
                                }
                                
                                self.delegate.showPopUp(title: strTitle, desc: strDesc, points: strRewards)
                                
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
