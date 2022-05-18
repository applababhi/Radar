//
//  EditProfileVC.swift
//  Radar
//
//  Created by Shalini Sharma on 21/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!    
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[String] = []
    
    var strImgUrl = ""
    var strName = ""
    var strOldPassword = ""
    var strNewPassword = ""
    var strConfirmPassword = ""
    
    var strEmail = ""
    var strPhone = ""
    
    var temporal_media_id = ""
    var selectedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userTypeString == "Promotor"
        {
            arrData = ["Image", "Username", "Password"]
        }
        else
        {
            arrData = ["Image", "Username", "Password", "Email", "Phone"]
        }
        
        lblTitle.text = "Editar Perfil"
        setupConstraints()
        
        if let userD:[String:Any] = k_helper.baseGlobalDict["user_information"] as? [String:Any]
        {
            if let title:String = userD["profile_picture_url"] as? String
            {
                strImgUrl = title
            }
            if let title:String = userD["company_id"] as? String
            {
                strName = title
            }
            if let title:String = userD["mail_address"] as? String
            {
                strEmail = title
            }
            if let title:String = userD["phone_number"] as? String
            {
                strPhone = title
            }
        }
        
        tblView.delegate = self
        tblView.dataSource = self
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
    
    @IBAction func btnBackClick(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogoutClick(btn:UIButton){
        
        let alertController = UIAlertController(title: "Radar", message: "Estas seguro que quieres cerrar sesión", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
            UIAlertAction in
            k_userDef.setValue("", forKey: userDefaultKeys.uuid.rawValue)
            k_userDef.setValue("", forKey: userDefaultKeys.user_type.rawValue)
            k_userDef.setValue("", forKey: userDefaultKeys.plan.rawValue)
            k_userDef.synchronize()
            
            let vc: FirstVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "FirstVC_ID") as! FirstVC
            k_window.rootViewController = vc
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel- ")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension EditProfileVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let strType:String = arrData[indexPath.row]
        
        if strType == "Image"
        {
            return 90
        }
        else if strType == "Username"
        {
            return 100
        }
        else if strType == "Password"
        {
            return 230
        }
        else{
            // Email & Phone
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let strType:String = arrData[indexPath.row]
        
        if strType == "Image"
        {
            let cell:CellEditProfile_Image = tblView.dequeueReusableCell(withIdentifier: "CellEditProfile_Image", for: indexPath) as! CellEditProfile_Image
            cell.selectionStyle = .none
            cell.imgView.layer.cornerRadius = 40.0
            cell.imgView.layer.borderColor = UIColor.clear.cgColor
            cell.imgView.layer.borderWidth = 0
            cell.imgView.layer.masksToBounds = true
            
            if selectedImage == nil
            {
                if strImgUrl == ""
                {
                    cell.imgView.image = UIImage(named: "user")
                }
                else
                {
                    cell.imgView.layer.borderColor = k_baseColor.cgColor
                    cell.imgView.layer.borderWidth = 1.2
                    cell.imgView.layer.masksToBounds = true
                    
                    cell.imgView.setImageUsingUrl(strImgUrl)
                    
                    selectedImage = cell.imgView.image
                }
            }
            else{
                cell.imgView.image = selectedImage
                
                cell.imgView.layer.borderColor = k_baseColor.cgColor
                cell.imgView.layer.borderWidth = 1.2
                cell.imgView.layer.masksToBounds = true
            }
            
            cell.btnUpdate.addTarget(self, action: #selector(self.btnChangePhoto), for: .touchUpInside)
            return cell
        }
        else if strType == "Username"
        {
            let cell:CellEditProfile_Name = tblView.dequeueReusableCell(withIdentifier: "CellEditProfile_Name", for: indexPath) as! CellEditProfile_Name
            cell.selectionStyle = .none
            cell.tfName.delegate = cell
            cell.tfName.text = ""
            cell.tfName.placeholder = "Nombre de Usuario"
            cell.tfName.placeholderColor = .lightGray
            cell.tfName.borderActiveColor = k_baseColor
            cell.tfName.borderInactiveColor = .lightGray
            cell.tfName.isSecureTextEntry = false
            
            cell.btnUpdate.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            cell.btnUpdate.isUserInteractionEnabled = false
            
            cell.completion = {(StrText:String) in
                self.strName = StrText
                self.tblView.reloadData()
            }
            
            if strName == ""
            {
                cell.tfName.text = ""
            }
            else
            {
                cell.tfName.text = strName
                
                cell.btnUpdate.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
                cell.btnUpdate.isUserInteractionEnabled = true
            }
            
            cell.btnUpdate.addTarget(self, action: #selector(self.btnChangeName), for: .touchUpInside)
            return cell
        }
        else if strType == "Password"
        {
            let cell:CellEditProfile_Password = tblView.dequeueReusableCell(withIdentifier: "CellEditProfile_Password", for: indexPath) as! CellEditProfile_Password
            cell.selectionStyle = .none
            
            cell.tfOld.tag = 101
            cell.tfNew.tag = 102
            cell.tfConfirm.tag = 103
            
            cell.btnUpdate.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            cell.btnUpdate.isUserInteractionEnabled = false
            
            cell.tfOld.textContentType = .oneTimeCode  // to remove Strong Pssword Option from Secure fields
            cell.tfNew.textContentType = .oneTimeCode  // to remove Strong Pssword Option from Secure fields
            cell.tfConfirm.textContentType = .oneTimeCode  // to remove Strong Pssword Option from Secure fields
            
            cell.tfOld.delegate = cell
            cell.tfOld.text = ""
            cell.tfOld.placeholder = "Contraseña Actual"
            cell.tfOld.placeholderColor = .lightGray
            cell.tfOld.borderActiveColor = k_baseColor
            cell.tfOld.borderInactiveColor = .lightGray
            cell.tfOld.isSecureTextEntry = true
            
            cell.tfNew.delegate = cell
            cell.tfNew.text = ""
            cell.tfNew.placeholder = "Nueva Contraseña"
            cell.tfNew.placeholderColor = .lightGray
            cell.tfNew.borderActiveColor = k_baseColor
            cell.tfNew.borderInactiveColor = .lightGray
            cell.tfNew.isSecureTextEntry = true
            
            cell.tfConfirm.delegate = cell
            cell.tfConfirm.text = ""
            cell.tfConfirm.placeholder = "Verificar Contraseña"
            cell.tfConfirm.placeholderColor = .lightGray
            cell.tfConfirm.borderActiveColor = k_baseColor
            cell.tfConfirm.borderInactiveColor = .lightGray
            cell.tfConfirm.isSecureTextEntry = true
            
            cell.completion = {(StrText:String, tfTag:Int) in
                if tfTag == 101
                {
                    self.strOldPassword = StrText
                }
                else if tfTag == 102
                {
                    self.strNewPassword = StrText
                }
                else if tfTag == 103
                {
                    self.strConfirmPassword = StrText
                }
                self.tblView.reloadData()
            }
            
            if strOldPassword == ""
            {
                cell.tfOld.text = ""
            }
            else
            {
                cell.tfOld.text = strOldPassword
            }
            
            if strNewPassword == ""
            {
                cell.tfNew.text = ""
            }
            else
            {
                cell.tfNew.text = strNewPassword
            }
            
            if strConfirmPassword == ""
            {
                cell.tfConfirm.text = ""
            }
            else
            {
                cell.tfConfirm.text = strConfirmPassword
            }
            
            if strOldPassword.isEmpty == false && strNewPassword.isEmpty == false && strConfirmPassword.isEmpty == false
            {
                cell.btnUpdate.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
                cell.btnUpdate.isUserInteractionEnabled = true
            }
            
            cell.btnUpdate.addTarget(self, action: #selector(self.btnChangePassword), for: .touchUpInside)
            return cell
        }
        else if strType == "Email"
        {
            let cell:CellEditProfile_Name = tblView.dequeueReusableCell(withIdentifier: "CellEditProfile_Name", for: indexPath) as! CellEditProfile_Name
            cell.selectionStyle = .none
            cell.tfName.delegate = cell
            cell.tfName.text = ""
            cell.tfName.placeholder = "Correo Electrónico"
            cell.tfName.placeholderColor = .lightGray
            cell.tfName.borderActiveColor = k_baseColor
            cell.tfName.borderInactiveColor = .lightGray
            cell.tfName.isSecureTextEntry = false
            
            cell.btnUpdate.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            cell.btnUpdate.isUserInteractionEnabled = false
            
            cell.completion = {(StrText:String) in
                self.strEmail = StrText
                self.tblView.reloadData()
            }
            
            if strEmail == ""
            {
                cell.tfName.text = ""
            }
            else
            {
                cell.tfName.text = strEmail
                
                cell.btnUpdate.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
                cell.btnUpdate.isUserInteractionEnabled = true
            }
            
            cell.btnUpdate.addTarget(self, action: #selector(self.btnChangeEmail), for: .touchUpInside)
            return cell
        }
        else if strType == "Phone"
        {
            let cell:CellEditProfile_Name = tblView.dequeueReusableCell(withIdentifier: "CellEditProfile_Name", for: indexPath) as! CellEditProfile_Name
            cell.selectionStyle = .none
            cell.tfName.delegate = cell
            cell.tfName.text = ""
            cell.tfName.placeholder = "Teéfono"
            cell.tfName.placeholderColor = .lightGray
            cell.tfName.borderActiveColor = k_baseColor
            cell.tfName.borderInactiveColor = .lightGray
            cell.tfName.isSecureTextEntry = false
            
            cell.btnUpdate.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            cell.btnUpdate.isUserInteractionEnabled = false
            
            cell.completion = {(StrText:String) in
                self.strPhone = StrText
                self.tblView.reloadData()
            }
            
            if strPhone == ""
            {
                cell.tfName.text = ""
            }
            else
            {
                cell.tfName.text = strPhone
                
                cell.btnUpdate.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
                cell.btnUpdate.isUserInteractionEnabled = true
            }
            
            cell.btnUpdate.addTarget(self, action: #selector(self.btnChangePhone), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnChangePhoto()
    {
        print("Click Change Photo")
        pickAnImage()
    }
    
    @objc func btnChangePhone()
    {
        print("Click Change Name")
        
        if strPhone.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese el número de teléfono", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else if strPhone.count < 10
        {
            self.showAlertWithTitle(title: "Alerta", message: "El número de teléfono debe tener 10 dígitos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else
        {
            // Call Api
            print("Call Api Update Phone -")
            callUpdatePhone()
        }
    }
    
    @objc func btnChangeName()
    {
        self.view.endEditing(true)
        print("Click Change Name")
        
        if strName.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el nombre de usuario", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else if strName.contains(" ")
        {
            self.showAlertWithTitle(title: "Alerta", message: "El nombre de usuario no debe contener espacios", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else if strName.count < 6
        {
            self.showAlertWithTitle(title: "Alerta", message: "El nombre de usuario debe tener un mínimo de 6 caracteres", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else
        {
            // Call Api
            callUpdateName()
        }
    }
    
    @objc func btnChangeEmail()
    {
        print("Click Change Name")
        
        if strEmail.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese la identificación de correo electrónico", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else if isValidEmail(testStr: strEmail) == false
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese una identificación de correo electrónico válida", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else
        {
            // Call Api Update Email ID
            print("Call Api Update Email ID")
            callUpdateEmail()
        }
    }
    
    @objc func btnChangePassword()
    {
        print("Click Change Password")
        
        // validate empty tfs
        if strOldPassword.isEmpty == true || strNewPassword.isEmpty == true || strConfirmPassword.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese los campos de contraseña vacíos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else if strNewPassword != strConfirmPassword
        {
            self.showAlertWithTitle(title: "Alerta", message: "La contraseña nueva y la contraseña de confirmación no coinciden", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        else
        {
            // Call Api
            callUpdatePassword()
        }
    }
}

extension EditProfileVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
                // CALL API TO UPLOAD TEMP IMAGE
                self.callUploadProfileImgApi(img: editedImage)
            }
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
            DispatchQueue.main.async {
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

extension EditProfileVC
{
    func callUploadProfileImgApi(img:UIImage)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.uploadImage(url: ServiceName.POST_UpdatePhoto + "?uuid=\(uuid)", method: .post, parameter: [:], header: [:], image: img, viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //    print(jsonString)
            
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
                            DispatchQueue.main.async {
                                self.selectedImage = nil
                                self.tblView.reloadData()
                            }
                            
                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                
                                self.tblView.reloadData()
                                
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callUpdateName()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "new_company_id":strName]
        WebService.requestService(url: ServiceName.POST_UpdateName, method: .put, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //  print(jsonString)
            
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callUpdatePassword()
    {
        self.view.endEditing(true)
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "current_password":strOldPassword.md5Value, "new_password":strConfirmPassword.md5Value]
        WebService.requestService(url: ServiceName.POST_UpdatePassword, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                
                                self.strOldPassword = ""
                                self.strNewPassword = ""
                                self.strConfirmPassword = ""                                
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.reloadtable))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func reloadtable()
    {
        self.tblView.reloadData()
    }
    
    func callUpdateEmail()
    {
        self.view.endEditing(true)
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "new_mail_address":strEmail]
        WebService.requestService(url: ServiceName.POST_UpdateEmail, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //     print(jsonString)
            
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
                        
                        if let msg:String = json["message"] as? String
                        {
                            DispatchQueue.main.async {
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callUpdatePhone()
    {
        self.view.endEditing(true)
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "new_phone_number":strPhone]
        // print(param)
        WebService.requestService(url: ServiceName.POST_UpdatePhone, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //     print(jsonString)
            
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
                        
                        if let msg:String = json["message"] as? String
                        {                            
                            DispatchQueue.main.async {
                                self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        //self.navigationController?.popViewController(animated: true)
        // self.tabBarController?.selectedIndex = 0
        let tabVC:TabBarController = self.tabBarController as! TabBarController
        tabVC.callGlobalSummary(vc: self.navigationController)
    }
}
