//
//  TomarTestResultVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 9/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class TomarTestResultVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!

    var delegate:updateRootVCWithRewardsPopUpDelegate!
    
    var arrData:[[String:Any]] = []
    
    var d_Rewards:[String:Any] = [:]
    var strHeadertext = ""


    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopBar()
        lblTitle.text = "Resultados"
        tblView.delegate = self
        tblView.dataSource = self
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 25
        tblView.reloadData()
    }

    @IBAction func backClicked(btn:UIButton)
    {
        var strTitle = ""
        var strDesc = ""
        var strRewards = ""
        
        if let str:String = d_Rewards["title"] as? String
        {
            strTitle = str
        }
        if let str:String = d_Rewards["description"] as? String
        {
            strDesc = str
        }
        if let str:String = d_Rewards["reward_str"] as? String
        {
            strRewards = str
        }
        
        self.delegate.showPopUp(title: strTitle, desc: strDesc, points: strRewards)

        self.navigationController?.popToRootViewController(animated: true)
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

extension TomarTestResultVC
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

extension TomarTestResultVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count + 1 // 1 for header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return UITableView.automaticDimension
        }
        
        var height1 = CGFloat(0.0)
        var height2 = CGFloat(0.0)
        var height3 = CGFloat(0.0)
        let width = (tableView.frame.size.width - 20)

        let dict:[String:Any] = arrData[indexPath.row - 1]
        
        if let title:String = dict["question_text"] as? String
        {
            height1 = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 21.0)!)
        }
        if let title:String = dict["correct_answer_text"] as? String
        {
            height2 = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 21.0)!)
        }
        if let title:String = dict["incorrect_answer_text"] as? String
        {
            height3 = title.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 21.0)!)
        }
        return height1 + height2 + height3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            // header
            let headerCell: CellTomar_Header = tableView.dequeueReusableCell(withIdentifier: "CellTomar_Header") as! CellTomar_Header
            headerCell.selectionStyle = .none
            
            headerCell.lblTitle.text = strHeadertext
            
            return headerCell
        }
        
        let dict: [String:Any] = arrData[indexPath.row - 1]
        let cell:CellTomarTestResult = tableView.dequeueReusableCell(withIdentifier: "CellTomarTestResult", for: indexPath) as! CellTomarTestResult
        cell.selectionStyle = .none
        cell.lblQuestion.text = ""
        cell.lblAns_Correct.text = ""
        cell.lblAns_Incorrect.text = ""
        
        let width = (tableView.frame.size.width - 20)
        
        if let str:String = dict["question_text"] as? String
        {
            cell.lblQuestion.text = str
            let height = str.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 20.0)!)
            cell.c_lblQ_Ht.constant = height
        }
        if let str:String = dict["correct_answer_text"] as? String
        {
            cell.lblAns_Correct.text = str
            let height = str.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
            cell.c_lblCor_Ht.constant = height
        }
        if let str:String = dict["incorrect_answer_text"] as? String
        {
            cell.lblAns_Incorrect.text = str
            let height = str.height(withConstrainedWidth: width, font: UIFont(name: CustomFont.regular, size: 17.0)!)
            cell.c_lblInc_Ht.constant = height
        }
        
        return cell
    }
}
