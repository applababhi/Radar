//
//  EntListSub4VC.swift
//  Radar
//
//  Created by Shalini Sharma on 22/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class EntListSub4VC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    
    var reffTrainVC:TrainingVC!
    
    var arrData:[String] = ["title", "instruction", "points", "continue"]
    var dictQuiz:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.dataSource = self
        self.tblView.delegate = self
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        
        self.tblView.reloadData()
    }
    
}

extension EntListSub4VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 35
        }
        else if indexPath.row == 1
        {
            return UITableView.automaticDimension
        }
        else if indexPath.row == 2
        {
            return 115
        }
        else
        {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:Cell_EntListSub4_Title = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub4_Title", for: indexPath) as! Cell_EntListSub4_Title
            cell.selectionStyle = .none
            
            cell.lblTitle.text = ""
            
            if let da:[String:Any] = dictQuiz["quizz"] as? [String:Any]
            {
                if let strT:String = da["name"] as? String
                {
                    cell.lblTitle.text = strT
                }
            }
            
            return cell
        }
            else if indexPath.row == 1
            {
                let cell:Cell_EntListSub4_Instruction = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub4_Instruction", for: indexPath) as! Cell_EntListSub4_Instruction
                cell.selectionStyle = .none
                
                cell.lblTitle.text = ""
                
                if let da:[String:Any] = dictQuiz["quizz"] as? [String:Any]
                {
                    if let strT:String = da["instructions"] as? String
                    {
                        cell.lblTitle.text = strT
                    }
                }
                
                return cell
            }
            else if indexPath.row == 2
            {
                let cell:CellVisitZone_Rewards = tableView.dequeueReusableCell(withIdentifier: "CellVisitZone_Rewards", for: indexPath) as! CellVisitZone_Rewards
                cell.selectionStyle = .none
                cell.lblPoints.text = ""
                cell.lblDescription.text = ""
                
                if let da:[String:Any] = dictQuiz["reward"] as? [String:Any]
                {
                    if let strT:String = da["reward_str"] as? String
                    {
                        cell.lblPoints.text = strT
                    }
                    if let strT:String = da["description"] as? String
                    {
                        cell.lblDescription.text = strT
                    }
                }
                
                return cell
            }
        else
        {
            let cell:CellVisitZone_Submit = tableView.dequeueReusableCell(withIdentifier: "CellVisitZone_Submit", for: indexPath) as! CellVisitZone_Submit
            cell.selectionStyle = .none
            
            cell.btnSubmit.layer.cornerRadius = 8.0
            cell.btnSubmit.layer.masksToBounds = true
            cell.btnSubmit.addTarget(self, action: #selector(self.btnContinueClick), for: .touchUpInside)
            return cell
        }
        
    }
    
    @objc func btnContinueClick()
    {
        let vc: TomarTestVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "TomarTestVC_ID") as! TomarTestVC
        vc.reffTrainVC = self.reffTrainVC
        
        if let da:[String:Any] = dictQuiz["quizz"] as? [String:Any]
        {
            if let strT:String = da["name"] as? String
            {
                vc.strHeader_Title = strT
            }
            if let strI:String = da["instructions"] as? String
            {
                vc.strHeader_Instructions = strI
            }
            if let strQ:String = da["quizz_id"] as? String
            {
                vc.strQuizID = strQ
            }
            if let strC:String = da["course_id"] as? String
            {
                vc.strCourseID = strC
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
