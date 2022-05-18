//
//  Register3VC.swift
//  Radar
//
//  Created by Shalini Sharma on 29/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class Register3VC: UIViewController {

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var lblTerms:UILabel!
    
    var selectedImage:UIImage!
    var checkboxSelect = false
    var temporal_media_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewBackgroundImage(name: "")
        
        lblNumber.layer.cornerRadius = 35.0
        lblNumber.layer.borderColor = UIColor.white.cgColor
        lblNumber.layer.borderWidth = 2.0
        lblNumber.layer.masksToBounds = true
        
        btnSelectImage.layer.cornerRadius = 45.0
        btnSelectImage.layer.masksToBounds = true
        
        btnRadio.setImage(UIImage(named: "unsel"), for: .normal)
        btnNext.isUserInteractionEnabled = false
        btnNext.setTitleColor(UIColor(named: "AppGray")!, for: .normal)
        
      //  let stringValue = "He leido y acepto los Términos y Condiciones del Servicio así como el Aviso de Privacidad."
        let stringValue = "Acepto que he leido y estoy deacuerdo con el Aviso de Privacidad."

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
    //    attributedString.setColorForText(textForAttribute: "Términos y Condiciones del Servicio", withColor: UIColor(named: "AppOrange")!, font: UIFont(name: CustomFont.semiBold, size: 14)!)
        attributedString.setColorForText(textForAttribute: "Aviso de Privacidad.", withColor: UIColor(named: "AppOrange")!, font: UIFont(name: CustomFont.semiBold, size: 14)!)

        lblTerms.attributedText = attributedString
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = lblTerms.attributedText?.string else {
            return
        }

        if let range = text.range(of: "Términos y Condiciones del Servicio"),
            recognizer.didTapAttributedTextInLabel(label: lblTerms, inRange: NSRange(range, in: text)) {
            DispatchQueue.main.async {
                if let url = URL(string: "https://www.google.com") {
                    UIApplication.shared.open(url)
                }
            }
        } else if let range = text.range(of: "Aviso de Privacidad."),
            recognizer.didTapAttributedTextInLabel(label: lblTerms, inRange: NSRange(range, in: text)) {
            DispatchQueue.main.async {
                if let url = URL(string: "https://inspirum.blob.core.windows.net/legal/aviso_de_privacidad.pdf") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }

    @IBAction func btnBackClick(btn:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFinalClick(btn:UIButton){
        if selectedImage != nil && checkboxSelect == true
        {
            print("- - call api to register - - ", k_helper.tempRegisterDict)
            callPostToRegisterUser()
        }
        else{
            // Show Alert select image and checkbox
            print("Show Alert select image and checkbox")
        }
    }
    
    @IBAction func btnCheckboxClick(btn:UIButton){
        checkboxSelect = !checkboxSelect
     
        if checkboxSelect
        {
            btnRadio.setImage(UIImage(named: "sel"), for: .normal)
        }
        else{
            btnRadio.setImage(UIImage(named: "unsel"), for: .normal)
        }
        
        btnNext.isUserInteractionEnabled = false
        btnNext.setTitleColor(UIColor(named: "AppGray")!, for: .normal)
        
        if selectedImage != nil && checkboxSelect == true
        {
            btnNext.isUserInteractionEnabled = true
            btnNext.setTitleColor(k_baseColor, for: .normal)
        }
    }
    
    @IBAction func btnUserImageClick(btn:UIButton){
        pickAnImage()
    }
}


extension Register3VC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
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

extension Register3VC :UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func pickAnImage()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Radar", message: "Elija una opción", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Tomar la foto", style: .default) { action -> Void in
            if(  UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.allowsEditing = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            else
            {
                let actionController: UIAlertController = UIAlertController(title: "La cámara no está disponible.",message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void     in
                    //Just dismiss the action sheet
                }
                
                actionController.addAction(cancelAction)
                self.present(actionController, animated: true, completion: nil)
                
            }
        }
        
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Elegir de la galería", style: .default) { action -> Void in
            
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.allowsEditing = true
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
            DispatchQueue.main.async {
                self.btnSelectImage.setImage(editedImage, for: .normal)
                self.btnSelectImage.layer.borderColor = UIColor.white.cgColor
                self.btnSelectImage.layer.borderWidth = 0.7
                self.btnSelectImage.layer.masksToBounds = true
                
                if self.selectedImage != nil && self.checkboxSelect == true
                {
                    self.btnNext.isUserInteractionEnabled = true
                    self.btnNext.setTitleColor(k_baseColor, for: .normal)
                }
                // CALL API TO UPLOAD TEMP IMAGE
                self.callUploadProfileImgApi(img: editedImage)
            }
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
            DispatchQueue.main.async {
                self.btnSelectImage.setImage(originalImage, for: .normal)
                self.btnSelectImage.layer.borderColor = UIColor.white.cgColor
                self.btnSelectImage.layer.borderWidth = 0.7
                self.btnSelectImage.layer.masksToBounds = true
                
                if self.selectedImage != nil && self.checkboxSelect == true
                {
                    self.btnNext.isUserInteractionEnabled = true
                    self.btnNext.setTitleColor(k_baseColor, for: .normal)
                }
                // CALL API TO UPLOAD TEMP IMAGE
                self.callUploadProfileImgApi(img: originalImage)
            }
        }
        else{
            print("Something went wrong!! NO IMAGE PICKED - - ")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension Register3VC
{
    func callUploadProfileImgApi(img:UIImage)
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.uploadImage(url: ServiceName.POST_UploadProfileImageTemp, method: .post, parameter: [:], header: [:], image: img, viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //   print(jsonString)
            
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let str:String = dict["temporal_uploaded_media_id"] as? String
                            {
                                self.temporal_media_id = str
                                k_helper.tempRegisterDict["profile_picture_temporal_media_id"] = str
                            }
                        }
                        self.perform(#selector(self.callAnalyseImage), with: nil, afterDelay: 0.2)
                    }
                }
            }
        }
        
    }
    
    @objc func callAnalyseImage()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["temporal_media_id":self.temporal_media_id]
        
        k_helper.tempRegisterDict["profile_picture_temporal_media_id"] = self.temporal_media_id
        
        WebService.requestService(url: ServiceName.PUT_AnalyseProfilePic, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //     print(jsonString)
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let status:Int = dict["acceptance_status"] as? Int
                            {
                                if let score:Int = dict["acceptance_score"] as? Int
                                {
                                    print("Image Upload Analysed ->> ", status, score)
                                }
                            }
                        }
                        DispatchQueue.main.async {

                        }
                    }
                }
            }
        }
    }
    
    func callPostToRegisterUser()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = k_helper.tempRegisterDict
        let urlStr:String = ServiceName.POST_RegisterUser

        WebService.requestService(url: urlStr, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
           // print(jsonString)
            
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
                        if let dit:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            print("Registered Dict ->> ", dit)
                            DispatchQueue.main.async {
                                k_helper.tempRegisterDict = [:]
                             
                                let vc:LoginVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "LoginVC_ID") as! LoginVC
                                k_window.rootViewController = vc
                            }
                        }
                    }
                }
            }
        }
    }
}
