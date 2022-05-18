//
//  CellTomar_Question.swift
//  Unefon
//
//  Created by Shalini Sharma on 8/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellTomar_Question: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblViewInner:UITableView!
    
    var arrInner:[[String:Any]] = []
    var indexToUpdateInMainArray:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTableAtIndex(index:Int)
    {
        indexToUpdateInMainArray = index
        
        let dict: [String:Any] = k_helper.arrTomar_QA[index]
        if let arr:[[String:Any]] = dict["aArray"] as? [[String:Any]]
        {
            arrInner = arr
        }
        
        self.tblViewInner.delegate = self
        self.tblViewInner.dataSource = self
        tblViewInner.estimatedRowHeight = 50
        tblViewInner.rowHeight = UITableView.automaticDimension
        tblViewInner.reloadData()
    }
}

extension CellTomar_Question: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrInner.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60    //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict: [String:Any] = arrInner[indexPath.row]
        let cell:CellTomar_Answer = tableView.dequeueReusableCell(withIdentifier: "CellTomar_Answer", for: indexPath) as! CellTomar_Answer
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.imgView.image = UIImage(named: "unsel")
        
        if let str:String = dict["aTitle"] as? String
        {
            if str.count > 90
            {
                cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 13.5)
            }
            cell.lblTitle.text = str
        }
        
        if let check:Bool = dict["selection"] as? Bool
        {
            if check == true
            {
                cell.imgView.image = UIImage(named: "radioUn")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        for index in 0..<arrInner.count
        {
            var dictInR: [String:Any] = arrInner[index]
            
            if indexPath.row == index
            {
                if let check:Bool = dictInR["selection"] as? Bool
                {
                    dictInR["selection"] = !check
                }
            }
            else
            {
                dictInR["selection"] = false
            }
            
            arrInner[index] = dictInR
        }
        
        var dictUpdate: [String:Any] = k_helper.arrTomar_QA[indexToUpdateInMainArray]
        dictUpdate["aArray"] = arrInner
        k_helper.arrTomar_QA[indexToUpdateInMainArray] = dictUpdate
        
        tblViewInner.reloadData()
    }
}
