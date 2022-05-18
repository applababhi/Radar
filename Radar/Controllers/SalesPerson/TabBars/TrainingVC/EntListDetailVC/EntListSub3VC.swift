//
//  EntListSub3VC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListSub3VC: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.dataSource = self
        self.tblView.delegate = self
        self.tblView.reloadData()
    }
    
}

extension EntListSub3VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict: [String:Any] = arrData[indexPath.row]
        let cell:Cell_EntListSub3 = tableView.dequeueReusableCell(withIdentifier: "Cell_EntListSub3", for: indexPath) as! Cell_EntListSub3
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSize.text = ""
        cell.lblExtension.text = ""
                
        if let str:String = dict["file_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["size_str"] as? String
        {
            cell.lblSize.text = str
        }
        if let str:String = dict["extension"] as? String
        {
            cell.lblExtension.text = str
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict: [String:Any] = arrData[indexPath.row]
        if let strPath:String = dict["full_url"] as? String
        {
            let urlString = strPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            let vc: NewsDetailVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
            vc.modalTransitionStyle = .crossDissolve
            if let titke:String = dict["title"] as? String
            {
                vc.strTitle = titke
            }
            vc.check_backToEntertainmentDetailScreen = true
            vc.pdfFilePath = urlString!
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.present(vc, animated: true, completion: nil)
        }
    }
}
