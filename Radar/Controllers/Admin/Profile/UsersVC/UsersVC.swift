//
//  UsersVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {
    
    @IBOutlet weak var lblTitle_1:UILabel!
    @IBOutlet weak var lblSubTitle_1:UILabel!
    @IBOutlet weak var btn_1_Left:UIButton!
    @IBOutlet weak var btn_1_Right:UIButton!
    @IBOutlet weak var imgV1:UIImageView!
    
    @IBOutlet weak var lblTitle_2:UILabel!
    @IBOutlet weak var lblSubTitle_2:UILabel!
    @IBOutlet weak var btn_2:UIButton!
    @IBOutlet weak var imgV2:UIImageView!
    
    var userCount:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
     //   imgV1.setImageColor(color: k_baseColor)
     //   imgV2.setImageColor(color: k_baseColor)

        btn_1_Left.layer.cornerRadius = 5.0
        btn_1_Left.layer.masksToBounds = true
        btn_1_Right.layer.cornerRadius = 5.0
        btn_1_Right.layer.masksToBounds = true
        btn_2.layer.cornerRadius = 5.0
        btn_2.layer.masksToBounds = true
        
        lblTitle_1.text = "\(userCount) Usuarios Registrados"
        lblSubTitle_1.text = "Invita a tus colaboradores a registrarse utilizando un código de acceso. Estos códigos tienen una vigencia de 7 días."
        btn_1_Left.setTitle("Invitar Promotor", for: .normal)
        btn_1_Right.setTitle("Invitar Supervisor", for: .normal)
        
        lblTitle_2.text = "Ranking de Usuarios"
        lblSubTitle_2.text = "Conoce la posición que ocupa cada uno de tus colaboradores en el Ranking de acuerdo a sus diamantes obtenidos."
        btn_2.setTitle("Ver Ranking", for: .normal)        
    }
    
    @IBAction func btn_1_LeftCkick(btn:UIButton)
    {
        let vc: InvitationCodeVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "InvitationCodeVC_ID") as! InvitationCodeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_1_RightCkick(btn:UIButton)
    {
        let vc: InvitationCodeVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "InvitationCodeVC_ID") as! InvitationCodeVC
        vc.isInviteSupervisor = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn2Ckick(btn:UIButton)
    {
        let vc:RankingVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "RankingVC_ID") as! RankingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
