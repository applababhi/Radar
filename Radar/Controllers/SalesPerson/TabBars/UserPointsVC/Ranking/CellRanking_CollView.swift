//
//  CellRanking_CollView.swift
//  Radar
//
//  Created by Shalini Sharma on 6/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellRanking_CollView: UITableViewCell {

    @IBOutlet weak var collView:UICollectionView!
    var arrCollView:[[String:Any]] = []{
        didSet{
            if self.collView.delegate == nil{
                self.collView.delegate = self
                self.collView.dataSource = self
            }
            else{
                self.collView.reloadData()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension CellRanking_CollView: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCellRanking = collView.dequeueReusableCell(withReuseIdentifier: "CollCellRanking", for: indexPath as IndexPath) as! CollCellRanking

        cell.lblNumber.text = ""
        cell.lblTitle.text = ""
        cell.lblPoints.text = ""
        
        cell.lblTitle.textColor = UIColor(named: "AppGray")
        cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 14)

        if let str:Int = dict["position"] as? Int
        {
            cell.lblNumber.text = "\(str)"
        }
        if let str:String = dict["full_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["accumulated_points_str"] as? String
        {
            cell.lblPoints.text = str
        }
        
        if let check:Bool = dict["is_highlighted"] as? Bool
        {
            if check == true
            {
                cell.lblTitle.textColor = .white
                cell.lblTitle.font = UIFont(name: CustomFont.bold, size: 14)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension CellRanking_CollView : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

