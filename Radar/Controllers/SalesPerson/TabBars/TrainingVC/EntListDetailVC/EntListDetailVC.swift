//
//  EntListDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListDetailVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collViewMain:UICollectionView!
    @IBOutlet weak var baseView:UIView!
        
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    

    var arrData: [String] = ["CONTENIDO", "ARCHIVOS", "VIDEOS", "EXAMEN"]

    var selectedCellIndex:Int = 0
    var strTitle = ""
    var strCourseID = ""
    var dictMain:[String:Any] = [:]

    var reffTrainVC:TrainingVC!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        lblTitle.text = strTitle
        collViewMain.dataSource = self
        collViewMain.delegate = self
        
        loadSubViewControllerAt(index: 0)
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

    func loadSubViewControllerAt(index:Int)
    {
        for views in baseView.subviews
        {
            views.removeFromSuperview()
        }
        
        if index == 3
        {
            if let diQ:[String:Any] = dictMain["quizz_information"] as? [String:Any]
            {
                if let check:Bool = diQ["has_quizz"] as? Bool
                {
                    if check ==  false
                    {
                        collectionView(collViewMain, didSelectItemAt: IndexPath(row: 0, section: 0))
                        
                        self.showAlertWithTitle(title: "Alerta", message: "Este curso no cuenta con un examen", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                        return
                    }
                }
            }
        }
        
        if index == 0
        {
           // Tab 1
            let controller: EntListSub1VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub1VC_ID") as! EntListSub1VC
            
            if let arr:[[String:Any]] = dictMain["contents"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            
            if let d1:[String:Any] = dictMain["course_information"] as? [String:Any]
            {
                if let str:String = d1["cover_url"] as? String
                {
                    controller.imgHeaderUrl = str
                }
                if let str:String = d1["title"] as? String
                {
                    controller.strHeaderTitle = str
                }
                if let str:String = d1["course_id"] as? String
                {
                    controller.courseID = str
                }
            }
            
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 1
        {
            // Tab 2
            let controller: EntListSub3VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub3VC_ID") as! EntListSub3VC

            if let arr:[[String:Any]] = dictMain["files"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 2
        {
            // Tab 3
            let controller: EntListSub2VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub2VC_ID") as! EntListSub2VC

            if let arr:[[String:Any]] = dictMain["videos"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else{
            // Tab 4
            
            callGetQuiz()
        }
    }
}

extension EntListDetailVC
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

extension EntListDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let str:String = arrData[indexPath.item]
        
        let cell:CellColl_ObjBase = collViewMain.dequeueReusableCell(withReuseIdentifier: "CellColl_ObjBase", for: indexPath) as! CellColl_ObjBase
        cell.lblTitle.text = str.uppercased()
        cell.lblTitle.textColor = .lightGray

        cell.viewLine.backgroundColor = UIColor.lightGray
        if selectedCellIndex == indexPath.item
        {
            cell.viewLine.backgroundColor = k_baseColor
            cell.lblTitle.textColor = k_baseColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // let str:String = arrData[indexPath.item]
        selectedCellIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // to make cell in ceter on Tap
        collectionView.reloadData()
        loadSubViewControllerAt(index: indexPath.item)
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let str:String = arrData[indexPath.item]
        
        let width  = str.width(withConstrainedHeight: 30, font: UIFont(name: CustomFont.regular, size: 15.0)!, minimumTextWrapWidth: 100)
        return CGSize(width: width, height: 50)
    }
}

extension EntListDetailVC
{
    func callGetQuiz()
    {
        k_helper.arrTomar_QA.removeAll()
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "course_id":strCourseID]
        WebService.requestService(url: ServiceName.GET_EnterQuiz, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
   //         print(jsonString)
            
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
                            // Instead of below Alert show empty VC
                           // self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            DispatchQueue.main.async {
                                
                                let controller: EntListSub4_EmptyVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub4_EmptyVC_ID") as! EntListSub4_EmptyVC
                                controller.view.frame = self.baseView.bounds;
                                controller.willMove(toParent: self)
                                self.baseView.addSubview(controller.view)
                                self.addChild(controller)
                                controller.didMove(toParent: self)
                            }
                            return
                        }
                    }
                    else
                    {
                        // Pass

                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = d["questions"] as? [[String:Any]]
                            {
                                for index in 0..<arr.count
                                {
                                    var d2p:[String:Any] = [:]
                                    let dip:[String:Any] = arr[index] as! [String:Any]
                                    var arrAnswers:[[String:Any]] = []
                                    
                                    if let dQ:[String:Any] = dip["question"] as? [String:Any]
                                    {
                                        if let Qname:String = dQ["content"] as? String
                                        {
                                            d2p["qTitle"] = Qname
                                        }
                                        if let Qid:String = dQ["question_id"] as? String
                                        {
                                            d2p["qId"] = Qid
                                        }
                                    }
                                    if let aA:[[String:Any]] = dip["options"] as? [[String:Any]]
                                    {
                                        for k in 0..<aA.count
                                        {
                                            var d2pA:[String:Any] = [:]
                                            let da:[String:Any] = aA[k] as! [String:Any]
                                           
                                            if let ans:String = da["content"] as? String
                                            {
                                                d2pA["aTitle"] = ans
                                            }
                                            if let ansId:String = da["option_id"] as? String
                                            {
                                                d2pA["aId"] = ansId
                                            }
                                            d2pA["selection"] = false
                                            arrAnswers.append(d2pA)
                                        }
                                        d2p["aArray"] = arrAnswers
                                    }
                                    k_helper.arrTomar_QA.append(d2p)
                                }
                                    
                                DispatchQueue.main.async {
                                    
                                    let controller: EntListSub4VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub4VC_ID") as! EntListSub4VC

                                    controller.reffTrainVC = self.reffTrainVC
                                    controller.dictQuiz = d
                                    controller.view.frame = self.baseView.bounds;
                                    controller.willMove(toParent: self)
                                    self.baseView.addSubview(controller.view)
                                    self.addChild(controller)
                                    controller.didMove(toParent: self)                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
