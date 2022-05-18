//
//  NewsListVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class NewsListVC: UIViewController {
        
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    
    var strTitle = ""

    var arrData: [[String:Any]] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopBar()

        lblTitle.text = strTitle
        
        tblView.estimatedRowHeight = 44
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
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

extension NewsListVC
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

extension NewsListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellNewsList = tableView.dequeueReusableCell(withIdentifier: "CellNewsList", for: indexPath) as! CellNewsList
        cell.selectionStyle = .none
        
        var dict:[String:Any] = arrData[indexPath.row]
        
        if isPad
        {
            cell.c_imgView_Ht_iPad.constant = 240
        }
        
        cell.imgView.image = nil
        cell.lblTitle.text = ""
        cell.lblDate.text = ""
        cell.lblDescription.text = ""
        
        cell.btnDownload.layer.cornerRadius = 5.0
        cell.btnDownload.layer.masksToBounds = true
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownloadClick(btn:)), for: .touchUpInside)
        cell.btnDownload.isHidden = true
        
        if let url:String = dict["attachment_url"] as? String
        {
            if url != ""
            {
                cell.btnDownload.isHidden = false
            }
        }
        
        if let title:String = dict["title"] as? String
        {
            cell.lblTitle.text = title
        }
        if let title:String = dict["cover_high_res_url"] as? String
        {
            cell.imgView.setImageUsingUrl(title)
        }
        if let title:String = dict["publish_date_str"] as? String
        {
            cell.lblDate.text = title
        }
        if let title:String = dict["content"] as? String
        {
            cell.lblDescription.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    @objc func btnDownloadClick(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        if let url:String = dict["attachment_url"] as? String
        {
            if url != ""
            {
                let vc: NewsDetailVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsDetailVC_ID") as! NewsDetailVC
                vc.modalTransitionStyle = .crossDissolve
                if let titke:String = dict["title"] as? String
                {
                    vc.strTitle = titke
                }
                vc.pdfFilePath = url
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
