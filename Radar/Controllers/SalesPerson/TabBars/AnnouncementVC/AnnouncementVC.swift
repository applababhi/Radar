//
//  AnnouncementVC.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class AnnouncementVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var carouselViewReff_Announcement: AACarousel!
    var carouselViewReff_Promotion: AACarousel!
    var caraouselIndexReff:Int = 0
    
    var arrData:[String] = []
    
    var arr_Announcements: [[String:Any]] = []
    var imgArray_Announcements: [String] = []
    
    var arr_Promotion: [[String:Any]] = []
    var imgArray_Promotion: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Comunicados y Promos"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
        setupConstraints()
                
        setupData()
    }
    
    func setupData()
    {
        arrData = []
        self.arr_Announcements = []
        self.arr_Promotion = []
        
        carouselViewReff_Announcement = nil
        carouselViewReff_Promotion = nil
        
        //        print(k_helper.baseGlobalDict)
        if let notfD:[String:Any] = k_helper.baseGlobalDict["notifications"] as? [String:Any]
        {
            if let check:Bool = notfD["has_unread_notifications"] as? Bool
            {
                if check == true
                {
                    btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
                }
                else
                {
                    btnNotification.setImage(UIImage(named: "notifyPlain"), for: .normal)
                }
            }
        }
        
        if let arrAnnounce:[[String:Any]] = k_helper.baseGlobalDict["announcements"] as? [[String:Any]]
        {
            self.arr_Announcements = arrAnnounce
            for d in arrAnnounce
            {
                if let imgStr:String = d["cover_url"] as? String
                {
                    self.imgArray_Announcements.append(imgStr)
                }
            }
            arrData.append("Comunicados")
        }
        
        if let arrAnnounce:[[String:Any]] = k_helper.baseGlobalDict["promotions"] as? [[String:Any]]
        {
            self.arr_Promotion = arrAnnounce
            for d in arrAnnounce
            {
                if let imgStr:String = d["cover_url"] as? String
                {
                    self.imgArray_Promotion.append(imgStr)
                }
            }
            arrData.append("Promociones")
        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
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
    
    @IBAction func btnNotificationClick(btn:UIButton){
        let vc:NotificationVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "NotificationVC_ID") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }    
}

extension AnnouncementVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellMain_Scroller = tblView.dequeueReusableCell(withIdentifier: "CellMain_Scroller", for: indexPath) as! CellMain_Scroller
        cell.selectionStyle = .none
        cell.lblTitle.text = "...."
        cell.lblSubTitle.text = "...."
                
        cell.lblHeader.text = ""
        cell.vBlack.isHidden = true
        
        cell.vBlack_Inner.alpha = 0.08
        cell.vBlack_Inner.backgroundColor = .clear
                
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: cell.vBlack_Inner.bounds.size.height)
      //  gradient.startPoint = CGPoint(x: 0, y: 0.0)
      //  gradient.endPoint = CGPoint(x: 0, y: 1.0)
        gradient.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.black.cgColor]
        cell.vBlack_Inner.layer.insertSublayer(gradient, at: 0)
        
        if indexPath.row == 0
        {
            cell.lblHeader.text = arrData.first!
            
            if self.arr_Announcements.count > 0
            {
                let dic:[String:Any] = self.arr_Announcements.first!
                if let type:Bool = dic["type"] as? Bool
                {
                    if type == true
                    {
                        cell.vBlack.isHidden = false
                        
                        if let title:String = dic["title"] as? String
                        {
                            if title.count > 20
                            {
                                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            }
                            else
                            {
                                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                            }
                            cell.lblTitle.text = title
                        }
                        if let subTitle:String = dic["content"] as? String
                        {
                            cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            cell.lblSubTitle.text = subTitle
                        }
                    }
                }
            }
            
            if cell.carouselView.delegate == nil
            {
                cell.carouselView.delegate = self
                cell.carouselView.setCarouselData(paths: imgArray_Announcements,  describedTitle: [], isAutoScroll: true, timer: 2.7, defaultImage: "ph")
                
                cell.carouselView.tag = 1001
            }
            
            //optional method
            cell.carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
            cell.carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
            
            cell.carouselView.indexChangeClosure = { (index) in
                //   print("Change the Labels here - - - Scroller - ", index)
                
                cell.lblTitle.text = ""
                cell.lblSubTitle.text = ""
                cell.vBlack.isHidden = true
                
                if self.arr_Announcements.count > 0
                {
                    let dic:[String:Any] = self.arr_Announcements[index]
                    
                    if let type:Bool = dic["type"] as? Bool
                    {
                        if type == true
                        {
                            cell.vBlack.isHidden = false
                            if let title:String = dic["title"] as? String
                            {
                                if title.count > 20
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                }
                                else
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                                }
                                cell.lblTitle.text = title
                            }
                            if let subTitle:String = dic["content"] as? String
                            {
                                cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                //  padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
                                cell.lblSubTitle.text = subTitle
                            }
                        }
                    }
                }
                
                self.caraouselIndexReff = index
            }
            
            carouselViewReff_Announcement = cell.carouselView
            cell.btn.addTarget(self, action: #selector(self.btnCaraousel_AnnouncementClick(btn:)), for: .touchUpInside)
            
            return cell
        }
        else
        {
            cell.lblHeader.text = arrData.last!
            
            if self.arr_Promotion.count > 0
            {
                let dic:[String:Any] = self.arr_Promotion.first!
                if let type:Bool = dic["type"] as? Bool
                {
                    if type == true
                    {
                        cell.vBlack.isHidden = false
                        if let title:String = dic["title"] as? String
                        {
                            if title.count > 20
                            {
                                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            }
                            else
                            {
                                cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                            }
                            cell.lblTitle.text = title
                        }
                        if let subTitle:String = dic["content"] as? String
                        {
                            cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                            cell.lblSubTitle.text = subTitle
                        }
                    }
                }
            }
            
            if cell.carouselView.delegate == nil
            {
                cell.carouselView.delegate = self
                cell.carouselView.setCarouselData(paths: imgArray_Promotion,  describedTitle: [], isAutoScroll: true, timer: 2.7, defaultImage: "ph")
                
                cell.carouselView.tag = 1002
            }
            
            //optional method
            cell.carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
            cell.carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
            
            cell.carouselView.indexChangeClosure = { (index) in
                //   print("Change the Labels here - - - Scroller - ", index)
                
                cell.lblTitle.text = ""
                cell.lblSubTitle.text = ""
                cell.vBlack.isHidden = true
                
                if self.arr_Promotion.count > 0
                {
                    let dic:[String:Any] = self.arr_Promotion[index]
                    
                    if let type:Bool = dic["type"] as? Bool
                    {
                        if type == true
                        {
                            cell.vBlack.isHidden = false
                            if let title:String = dic["title"] as? String
                            {
                                if title.count > 20
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                }
                                else
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                                }
                                cell.lblTitle.text = title
                            }
                            if let subTitle:String = dic["content"] as? String
                            {
                                cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                //  padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
                                cell.lblSubTitle.text = subTitle
                            }
                        }
                    }
                }
                
                self.caraouselIndexReff = index
            }
            
            carouselViewReff_Promotion = cell.carouselView
            cell.btn.addTarget(self, action: #selector(self.btnCaraousel_PromotionClick(btn:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCaraousel_AnnouncementClick(btn:UIButton)
    {
        print("Caraosel Announcement Tapped at - ",self.caraouselIndexReff)
        
        calltakeToAnnouncementDetail()
    }
    
    @objc func btnCaraousel_PromotionClick(btn:UIButton)
    {
        print("Caraosel Promotion Tapped at - ",self.caraouselIndexReff)
        
        calltakeToPromotionDetail()
    }
}

// MARK: Scroller Delegate
extension AnnouncementVC: AACarouselDelegate
{
    //require method
    func downloadImages(_ url: String, _ index:Int)
    {
        let imageView1 = UIImageView()

        imageView1.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "ph"), options: [.transition(.fade(1))], progressBlock: nil) { (downloadImage, error, cacheType, urlLocal) in
            
            if downloadImage != nil && self.carouselViewReff_Announcement != nil && self.imgArray_Announcements.contains(url) == true
            {
                if index < self.carouselViewReff_Announcement.images.count
                {
                    self.carouselViewReff_Announcement.images[index] = downloadImage!
                }
            }
            
            if downloadImage != nil && self.carouselViewReff_Promotion != nil && self.imgArray_Promotion.contains(url) == true
            {
                if index < self.carouselViewReff_Promotion.images.count
                {
                    self.carouselViewReff_Promotion.images[index] = downloadImage!
                }
                print(self.carouselViewReff_Promotion.images.count)
                print(index)
            }
        }
    }
    
    //optional method (show first image faster during downloading of all images)
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "ph"))
    }
    
    //optional method (interaction for touch image)
    func didSelectCarouselView(_ view:AACarousel ,_ index:Int) {
        
        print("Tag tapped ", view.tag)
        print("Carousel Inde Tapped - ", index)

        if view.tag == 1001
        {
            // Announcements
            calltakeToAnnouncementDetail()
        }
        else
        {
            // 1002
            // Promotions
            calltakeToPromotionDetail()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if carouselViewReff_Announcement != nil{
            self.carouselViewReff_Announcement.stopScrollImageView()
        }
        if carouselViewReff_Promotion != nil{
            self.carouselViewReff_Promotion.stopScrollImageView()
        }
    }
}

extension AnnouncementVC
{
    func calltakeToAnnouncementDetail()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_AnnouncementList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            if error != nil
            {
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
                        
                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                let vc: NewsListVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsListVC_ID") as! NewsListVC
                                vc.arrData = arrresp
                                vc.strTitle = self.arrData.first!
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func calltakeToPromotionDetail()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_PromotionList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            if error != nil
            {
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
                        
                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                let vc: NewsListVC = AppStoryBoards.Announcement.instance.instantiateViewController(withIdentifier: "NewsListVC_ID") as! NewsListVC
                                vc.arrData = arrresp
                                vc.strTitle = self.arrData.last!
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
