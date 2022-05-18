//
//  CellPintSale_Addresses.swift
//  Radar
//
//  Created by Shalini Sharma on 30/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellPintSale_Addresses: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    
    
    var arrData:[[String:Any]] = []{
        didSet{
            self.collView.dataSource = self
            self.collView.delegate = self
            self.collView.reloadData()
        }
    }
    
    var closure:([[String:Any]], String) -> () = {(fullArray:[[String:Any]], selectedPlaceID:String) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

extension CellPintSale_Addresses : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrData[indexPath.item]
        
        let cell:CollCellPoint_Radio = collView.dequeueReusableCell(withReuseIdentifier: "CollCellPoint_Radio", for: indexPath) as! CollCellPoint_Radio
        cell.lblTitle.text = ""
        cell.imgView.image = UIImage(named: "unsel")
        
        if let str:String = dict["formatted_address"] as? String
        {
          //  check size of label and font
            cell.lblTitle.text = str
        }
        
        if let check:Bool = dict["selected"] as? Bool
        {
            if check == true
            {
                cell.imgView.image = UIImage(named: "radioUn")
            }
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var placeId = ""
        for ind in 0..<arrData.count
        {
            var dicy:[String:Any] = arrData[ind]
            dicy["selected"] = false
            
            if ind == indexPath.row
            {
                dicy["selected"] = true
                
                if let strId:String = dicy["place_id"] as? String
                {
                    placeId = strId
                }
            }
            arrData[ind] = dicy
        }
        collView.reloadData()
        closure(arrData, placeId)
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
        return CGSize(width: UIScreen.main.bounds.size.width - 20, height: 65)
    }
}

