//
//  TomarTestVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class TomarTestVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!    
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!

    var strHeader_Title = ""
    var strHeader_Instructions = ""
    var strQuizID = ""
    var strCourseID = ""
    
    var reffTrainVC:TrainingVC!

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   print(k_helper.arrTomar_QA)
        
        setUpTopBar()
        lblTitle.text = "Examen"
        tblView.delegate = self
        tblView.dataSource = self
        self.tblView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tblView.estimatedSectionHeaderHeight = 25;
        tblView.reloadData()
    }

    @IBAction func backClicked(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpTopBar()
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
}

extension TomarTestVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension TomarTestVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellTomar_Header = tableView.dequeueReusableCell(withIdentifier: "CellTomar_Header") as! CellTomar_Header
        headerCell.selectionStyle = .none
        
        headerCell.lblTitle.text = strHeader_Title
        headerCell.lblDesc.text = strHeader_Instructions
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // UITableView.automaticDimension  // Hiding the section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return k_helper.arrTomar_QA.count + 1  // 1 for last button cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == k_helper.arrTomar_QA.count
        {
            // last cell Button
            return 70
        }
        else
        {
            let dict: [String:Any] = k_helper.arrTomar_QA[indexPath.row]
            if let arr:[[String:Any]] = dict["aArray"] as? [[String:Any]]
            {
                return CGFloat(70 + (60 * arr.count)) // 70 for question, 60 for each answer
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == k_helper.arrTomar_QA.count
        {
            // last cell Button
            
            let cell:CellExchange_NextBtn = tableView.dequeueReusableCell(withIdentifier: "CellExchange_NextBtn", for: indexPath) as! CellExchange_NextBtn
            cell.selectionStyle = .none
            
            cell.btnNext.layer.cornerRadius = 5.0
            cell.btnNext.layer.masksToBounds = true
            cell.btnNext.addTarget(self, action: #selector(self.btnNextClick(btn:)), for: .touchUpInside)

            return cell
        }
        else
        {
            let dict: [String:Any] = k_helper.arrTomar_QA[indexPath.row]

            let cell:CellTomar_Question = tableView.dequeueReusableCell(withIdentifier: "CellTomar_Question", for: indexPath) as! CellTomar_Question
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            
            if let str:String = dict["qTitle"] as? String
            {
                cell.lblTitle.text = "\(indexPath.row + 1)" + ") " + str
            }
            
            cell.setTableAtIndex(index: indexPath.row)
            return cell
        }
    }
    
    @objc func btnNextClick(btn:UIButton)
    {
        var arrAnswer2Pas:[[String:Any]] = []
        
        for index in 0..<k_helper.arrTomar_QA.count
        {
            var dicAnswer2Pas:[String:Any] = [:]
            
            let dict: [String:Any] = k_helper.arrTomar_QA[index]
            if let arr:[[String:Any]] = dict["aArray"] as? [[String:Any]]
            {
                for ind in 0..<arr.count
                {
                    let dic: [String:Any] = arr[ind]
                    if let check:Bool = dic["selection"] as? Bool
                    {
                        if check == true
                        {
                            if let aID:String = dic["aId"] as? String
                            {
                                dicAnswer2Pas["option_id"] = aID
                            }
                            if let qID:String = dict["qId"] as? String
                            {
                                dicAnswer2Pas["question_id"] = qID
                            }
                            arrAnswer2Pas.append(dicAnswer2Pas) // if any1 true then only add Dict
                        }
                    }
                }
            }
        }
        
        if k_helper.arrTomar_QA.count == arrAnswer2Pas.count
        {
            // call Api
            print("call Api")
            var uuid = ""
            if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
            {
                uuid = id
            }
            
            let di2Pas:[String:Any] = ["answers": arrAnswer2Pas, "quizz_id":strQuizID, "uuid":uuid]
            callSubmitAnswers(dict: di2Pas)
        }
        else
        {
            self.showAlertWithTitle(title: "Validación", message: "Uno de sus campos de entrada está vacío. Por favor ingrese todos los campos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
}

extension TomarTestVC
{
    func callSubmitAnswers(dict:[String:Any])
    {
        // print(dict)
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = dict
        WebService.requestService(url: ServiceName.POST_SubmitQuiz, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: TomarTestResultVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "TomarTestResultVC_ID") as! TomarTestResultVC
                                if let msg:String = di["explanation"] as? String
                                {
                                    vc.strHeadertext = msg
                                }
                                if let arr:[[String:Any]] = di["questions"] as? [[String:Any]]
                                {
                                    vc.arrData = arr
                                }
                                if let df:[String:Any] = di["reward"] as? [String:Any]
                                {
                                    vc.d_Rewards = df
                                }
                                vc.delegate = self.reffTrainVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

