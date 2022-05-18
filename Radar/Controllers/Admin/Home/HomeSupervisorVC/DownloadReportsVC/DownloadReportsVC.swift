//
//  DownloadReportsVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class DownloadReportsVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tfPeriod: HoshiTextField!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
            var arrPicker:[[String:Any]] = []
            var picker : UIPickerView!
            var dictPickerSelected:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Descarga de Reportes"

        tfPeriod.placeholder = "Selecciona un Periodo de Tiempo (Si Aplica)"
        tfPeriod.placeholderColor = .lightGray
        tfPeriod.borderActiveColor = k_baseColor
        tfPeriod.borderInactiveColor = .lightGray
        tfPeriod.placeholderFontScale = 1.0
        tfPeriod.delegate = self
        
        addRightPaddingTo(textField: tfPeriod, imageName: "dropDown")
        
        setupConstraints()
       
        tblView.delegate = self
        tblView.dataSource = self
        callGetReports()
    }
    
    func setupConstraints()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_ArcView_Ht.constant = 130
            c_LblTitle_Top.constant = 60
        }
        else if strModel == "iPhone Max"
        {
            c_ArcView_Ht.constant = 160
            c_LblTitle_Top.constant = 70
        }
        else if strModel == "iPhone 6+"
        {
            c_LblTitle_Top.constant = 45
        }
        else if strModel == "iPhone 6"
        {
            c_ArcView_Ht.constant = 95
        }
        else if strModel == "iPhone 5"
        {

        }
        else if strModel == "iPhone XR"
        {

        }
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

extension DownloadReportsVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showPickerView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DownloadReportsVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfPeriod.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        tfPeriod.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfPeriod.resignFirstResponder()
    }
    
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfPeriod.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: CustomFont.regular, size: 19)
        pickerLabel.textColor = UIColor.black
        pickerLabel.textAlignment = .center
        pickerLabel.text = ""
        
        let dict:[String:Any] = arrPicker[row]
        
        if let strValue:String = dict["month_name"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
        if let strTitle:String = self.dictPickerSelected["month_name"] as? String{
            self.tfPeriod.text =  strTitle
        }
    }
}

extension DownloadReportsVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let cell:CellZoneDetailList = tblView.dequeueReusableCell(withIdentifier: "CellZoneDetailList", for: indexPath) as! CellZoneDetailList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        if let str:String = dict["report_name"] as? String{
            cell.lblTitle.text = str
        }
        if let str:String = dict["file_format"] as? String{
            cell.lblSubTitle.text = str
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]

        if let strMonth:String = self.dictPickerSelected["month_id"] as? String{
            if let strReport:String = dict["report_id"] as? String{
                callGetFileDownload(report_id: strReport, period_id: strMonth)
            }
        }
    }
}

extension DownloadReportsVC
{
    func callGetReports(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_Reports, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //  print(jsonString)
            
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
                        if let js:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = js["available_periods"] as? [[String:Any]]
                            {
                                self.arrPicker = arr
                            }
                            if let arr:[[String:Any]] = js["available_reports"] as? [[String:Any]]
                            {
                                self.arrData = arr
                            }
                            
                            if self.arrPicker.count > 0
                            {
                                self.dictPickerSelected = self.arrPicker.first!
                                if let strTitle:String = self.dictPickerSelected["month_name"] as? String{
                                    self.tfPeriod.text =  strTitle
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
    
    func callGetFileDownload(report_id:String, period_id:String){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
                
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:] // ["plan_id":plan_id, "report_id":report_id, "period_id":period_id]
        let paramString = "?plan_id=\(plan_id)&report_id=\(report_id)&period_id=\(period_id)"
        print("Link to call - ", baseUrl + ServiceName.GET_ReportDownload + paramString)
        
        ///////  TEMPORARY

        let vc: NewsDetailVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
        vc.strTitle = "Report"
        vc.pdfFilePath = baseUrl + ServiceName.GET_ReportDownload + paramString
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)

        
        ///////
        
        /*
        WebService.requestService(url: ServiceName.GET_ReportDownload + paramString, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
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
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let js:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                if let url:String = js["attachment_url"] as? String
                                {
                                    if url != ""
                                    {
                                        let vc: NewsDetailVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
                                        if let titke:String = js["title"] as? String
                                        {
                                            vc.strTitle = titke
                                        }
                                        vc.pdfFilePath = url
                                        vc.modalTransitionStyle = .crossDissolve
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalPresentationCapturesStatusBarAppearance = true
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        */
    }
}
