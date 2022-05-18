//
//  RecompensasDetailVC.swift
//  Radar
//
//  Created by Shalini Sharma on 4/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class RecompensasDetailVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var check_DisableViewDetailOnceSuccessClick = false
    var codeID = ""
    var dictMain:[String:Any] = [:]

    var arrData:[[String:Any]] = [["type":"imageview", "height":130.0],
                                  ["type":"label", "title":"", "ph":"Producto", "height":"automatic"],
                                  ["type":"label", "title":"", "ph":"Marca", "height":"automatic"],
                                  ["type":"label", "title":"", "ph":"Denominación", "height":"automatic"],
                                  ["type":"label", "title":"", "ph":"Comó Redimirlo", "height":"automatic"],
                                  ["type":"hyperlink", "link":"https://www.gmail.com", "title":"Ver Términos y Condiciones", "height":45.0],
                                  ["type":"hyperlink", "link":"https://www.yahoo.com", "title":"Ver Aviso de Privacidad", "height":45.0],
                                  ["type":"radio", "title":"Acepto que he leído los Términos y Condiciones así como el Aviso de Privacidad", "selected":false, "height":100]]
    
    //  ["type":"copy", "ph":"Código", "code":"DJFJS-937FJ-DKDU4", "height":75.0],  add this when user click on radio button and call api
        //        ["type":"submit", "height":60.0]]

    var arrItemsArray:[[String:Any]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Recompensa"
        setupConstraints()
        
        setupData()
       
        tblView.delegate = self
        tblView.dataSource = self
        tblView.estimatedRowHeight = 20
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    func setupData()
    {
        if let str:String = dictMain["gift_name"] as? String
        {
            var d:[String:Any] = arrData[1]
            d["title"] = str
            arrData[1] = d
        }
        if let str:String = dictMain["brand"] as? String
        {
            var d:[String:Any] = arrData[2]
            d["title"] = str
            arrData[2] = d
        }
        if let str:String = dictMain["points_str"] as? String
        {
            var d:[String:Any] = arrData[3]
            d["title"] = str
            arrData[3] = d
        }
        if let str:String = dictMain["instructions"] as? String
        {
            var d:[String:Any] = arrData[4]
            d["title"] = str
            arrData[4] = d
        }
        if let str:String = dictMain["terms_conditions_url"] as? String
        {
            var d:[String:Any] = arrData[5]
            d["link"] = str
            arrData[5] = d
        }
        if let str:String = dictMain["privacy_advice_url"] as? String
        {
            var d:[String:Any] = arrData[6]
            d["link"] = str
            arrData[6] = d
        }
        if let arr:[[String:Any]] = dictMain["items"] as? [[String:Any]]
        {
            arrItemsArray = arr
        }
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

extension RecompensasDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let d:[String:Any] = arrData[indexPath.row]
        if let height:Double = d["height"] as? Double{
            return CGFloat(height)
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            if strType == "imageview"
            {
                let cell:CellRecompensasDetail_Image = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasDetail_Image", for: indexPath) as! CellRecompensasDetail_Image
                cell.selectionStyle = .none

                cell.imgHeader.layer.cornerRadius = 45.0
                cell.imgHeader.layer.masksToBounds = true
                
                if let str:String = dictMain["logo_url"] as? String
                {
                    cell.imgHeader.setImageUsingUrl(str)
                }
                
                return cell
            }
            else if strType == "label"
            {
                let cell:CellRecompensasDetail_Labels = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasDetail_Labels", for: indexPath) as! CellRecompensasDetail_Labels
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.lblPH.text = ""
                
                if let str:String = dict["title"] as? String
                {
                    cell.lblTitle.text = str
                }
                if let str:String = dict["ph"] as? String
                {
                    cell.lblPH.text = str
                }
                
                return cell
            }
            else if strType == "hyperlink"
            {
                let cell:CellRecompensasDetail_Hyperlink = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasDetail_Hyperlink", for: indexPath) as! CellRecompensasDetail_Hyperlink
                cell.selectionStyle = .none
                
                cell.btnLink.isUserInteractionEnabled = false
                cell.btnLink.setTitle("", for: .normal)
                if let str:String = dict["title"] as? String
                {
                    cell.btnLink.setTitle(str, for: .normal)
                }
                return cell
            }
            else if strType == "radio"
            {
                let cell:CellRecompensasDetail_Radio = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasDetail_Radio", for: indexPath) as! CellRecompensasDetail_Radio
                cell.selectionStyle = .none
                
                cell.btnRadio.setImage(UIImage(named: "unsel"), for: .normal)
                cell.btnRadio.isUserInteractionEnabled = false

                if let check:Bool = dict["selected"] as? Bool
                {
                    if check == true{
                        cell.btnRadio.setImage(UIImage(named: "radioUn"), for: .normal) // selected image
                    }
                }

                cell.btnViewDetail.tag = indexPath.row
                cell.btnViewDetail.layer.cornerRadius = 8.0
                cell.btnViewDetail.layer.masksToBounds = true
                cell.btnViewDetail.addTarget(self, action: #selector(self.btnViewDetailClick(btn:)), for: .touchUpInside)
                
                return cell
            }
            else if strType == "copy"
            {
                let cell:CellRecompensasDetail_Copy = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasDetail_Copy", for: indexPath) as! CellRecompensasDetail_Copy
                cell.selectionStyle = .none
                
                cell.lblCode.text = ""
                
                if let str:String = dict["code"] as? String
                {
                    cell.lblCode.text = str
                }
                
                return cell

            }
            else if strType == "submit"
            {
                let cell:CellVisitZone_Submit = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Submit", for: indexPath) as! CellVisitZone_Submit
                cell.selectionStyle = .none
                
//                cell.btnSubmit.setTitle("", for: .normal)
                cell.btnSubmit.layer.cornerRadius = 8.0
                cell.btnSubmit.layer.masksToBounds = true
                cell.btnSubmit.addTarget(self, action: #selector(self.downloadPDF(btn:)), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            
            if strType == "hyperlink"
            {
                if let str:String = dict["link"] as? String
                {
                    // open url
                    if let url = URL(string: str)
                    {
                        // print(url)
                        UIApplication.shared.open(url)
                    }
                }
            }
            else if strType == "radio"
            {
                if let check:Bool = dict["selected"] as? Bool
                {
                    dict["selected"] = !check
                    arrData[indexPath.row] = dict
                    tblView.reloadData()
                }
            }
            else if strType == "copy"
            {
                if let str:String = dict["code"] as? String
                {
                    UIPasteboard.general.string = str
                    
                    self.showAlertWithTitle(title: "Radar", message: "Código copiado", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                }
            }
        }
    }
    
    @objc func btnViewDetailClick(btn:UIButton)
    {
        if self.check_DisableViewDetailOnceSuccessClick == true{
            return
        }
        
        if let id:String = dictMain["code_id"] as? String{
            
            let dict:[String:Any] = arrData[btn.tag]
            if let check:Bool = dict["selected"] as? Bool
            {
                if check == true
                {
                    self.callAcceptTermsCode(codeId: id)
                }
            }
        }
    }
    
    @objc func downloadPDF(btn:UIButton)
    {
        var id = ""
        if let idT:String = dictMain["requested_code_id"] as? String
        {
            id = idT
        }
        
        let urlToPass:String = "\(baseUrl)" + "gifts/codes/reports/code_request" + "?code_request_id=\(id)"
        
        let vc: NewsDetailVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
        vc.modalTransitionStyle = .crossDissolve
        vc.strTitle = "Documento"

        vc.pdfFilePath = urlToPass
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true, completion: nil)
    }
}

extension RecompensasDetailVC
{
    func callAcceptTermsCode(codeId:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code_id":codeId]
        
        WebService.requestService(url: ServiceName.PUT_AcceptTermsWalletGift, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let msg:String = json["message"] as? String
                        {
                            self.check_DisableViewDetailOnceSuccessClick = true
                           // self.showAlertWithTitle(title: "Cuervo", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        }
                        DispatchQueue.main.async {
                            
                            //  ["type":"copy", "ph":"Código", "code":"DJFJS-937FJ-DKDU4", "height":75.0],  add this to main arr when user click on radio button and call api
                                //        ["type":"submit", "height":60.0]]

                            for di in self.arrItemsArray
                            {
                                var dToAdd:[String:Any] = ["type":"copy", "ph":"", "code":"", "height":75.0]
                                if let str:String = di["item_name"] as? String
                                {
                                    dToAdd["ph"] = str
                                }
                                if let str:String = di["item_content"] as? String
                                {
                                    dToAdd["code"] = str
                                }
                                self.arrData.append(dToAdd)
                            }
                            
                            self.arrData.append(["type":"submit", "height":60.0])
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
