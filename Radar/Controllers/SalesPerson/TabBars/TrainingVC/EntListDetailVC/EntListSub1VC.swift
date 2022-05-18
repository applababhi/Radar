//
//  EntListSub1VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListSub1VC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []
    var imgHeaderUrl = ""
    var courseID = ""
    var strHeaderTitle = ""
    var dictQuiz:[String:Any] = [:]

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.dataSource = self
        self.tblView.delegate = self
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension

        self.tblView.reloadData()
    }
    
    @IBAction func btnTomarClick(btn:UIButton)
    {
        print("Navigate to Q/A")
      //  callGetQuiz()
    }
}

extension EntListSub1VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count + 1 // 1 for Header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 215
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:Cell_EntListSub1_Header = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub1_Header", for: indexPath) as! Cell_EntListSub1_Header
            cell.selectionStyle = .none

            cell.imgView.setImageUsingUrl(imgHeaderUrl)
            cell.lblTitle.text = strHeaderTitle
            
            return cell
        }
        else
        {
            let dict: [String:Any] = arrData[indexPath.row - 1]
            let cell:Cell_EntListSub1 = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub1", for: indexPath) as! Cell_EntListSub1
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblDesc.text = ""
            
            if let str:String = dict["title"] as? String
            {
                cell.lblTitle.text = str
            }
            if let str:String = dict["content"] as? String
            {
                cell.lblDesc.text = str
            }
            
            return cell
        }

    }
}
