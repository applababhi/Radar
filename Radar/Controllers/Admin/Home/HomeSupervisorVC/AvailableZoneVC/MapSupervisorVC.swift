//
//  MapSupervisorVC.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapSupervisorVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapContainer:UIView!
    @IBOutlet weak var mapView:GMSMapView!
    @IBOutlet weak var summaryContainer:UIView!
    @IBOutlet weak var vBack:UIView!
    @IBOutlet weak var vFull:UIView!
    @IBOutlet weak var imgViewMaxMin:UIImageView!
    
    var locationManager = CLLocationManager()

    
    // Summary View Outlets
    @IBOutlet weak var lblTitle_Summary:UILabel!
    @IBOutlet weak var lblSubTitle_Summary:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    var arrTableData:[[String:Any]] = []
    
    @IBOutlet weak var c_Map_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_Summary_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_Summary_Bt:NSLayoutConstraint!
    
    var dictMain:[String:Any] = [:]
    let halfScreenHeight = (UIScreen.main.bounds.size.height)/2.0
    var isMapFullScreen:Bool = false
    
    var arrPolygon:[[String:Any]] = []
    var arrOtherPoints_1:[[String:Any]] = []
    var arrOtherPoints_2:[[String:Any]] = []
    
    var mapCenterCamera:GMSCameraPosition!
    
    var latCenter:Double!
    var longCenter:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle_Summary.text = ""
        lblSubTitle_Summary.text = ""
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()

        setupData()
        makeMapHalfSize()
        roundSummaryViewCorners()
        loadPolygonMap()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

      //  let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 14.5)

      //  self.mapView?.animate(to: camera)

        //Finally stop updating location otherwise it will come again and again in this delegate
      //

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func setupData()
    {
        if let str:String = dictMain["zone_name"] as? String{
            lblTitle_Summary.text = str
        }
        if let str:String = dictMain["zone_id"] as? String{
            lblSubTitle_Summary.text = str
        }
        
        if let arr:[String] = dictMain["municipalities"] as? [String]{
            arrTableData.append(["title":"Municipios de Referencia","data":arr])
        }
        if let arr:[String] = dictMain["neighborhoods"] as? [String]{
            arrTableData.append(["title":"Colonias de Referencia","data":arr])
        }
        
        if let arr:[[String:Any]] = dictMain["cardinal_points"] as? [[String:Any]]{
            arrOtherPoints_1 = arr
        }
        if let arr:[[String:Any]] = dictMain["pos_points"] as? [[String:Any]]{
            arrOtherPoints_2 = arr
        }
        if let arr:[[String:Any]] = dictMain["polygon_points"] as? [[String:Any]]{
            arrPolygon = arr
        }
        
        if let d:[String:Any] = dictMain["view_center"] as? [String:Any]{
            if let la:Double = d["latitude"] as? Double{
                latCenter = la
            }
            if let la:Double = d["longitude"] as? Double{
                longCenter = la
            }
        }
        
        if arrTableData.count > 0
        {
            tblView.dataSource = self
            tblView.delegate = self
            tblView.reloadData()
        }
    }
    
    func makeMapHalfSize()
    {
        c_Map_Ht.constant = halfScreenHeight
        c_Summary_Bt.constant = 0
        c_Summary_Ht.constant = halfScreenHeight + 25
        
        if mapCenterCamera != nil
        {
            mapView.camera = mapCenterCamera
        }
    }
    
    func makeMapFullSize()
    {
        c_Map_Ht.constant = halfScreenHeight * 2
        c_Summary_Bt.constant = 0
        c_Summary_Ht.constant = 0
    }
    
    func loadPolygonMap()
    {
        //  mapView.setMinZoom(1, maxZoom: 6)
        mapView.delegate = self
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        var arrLats:[Double] = []
        var arrLongs:[Double] = []
        
        let rect = GMSMutablePath()
        
        for index in 0..<arrPolygon.count{
            
            let dict:[String:Any] = arrPolygon[index]
            
            if let strLat:Double = dict["latitude"] as? Double
            {
                if let strLong:Double = dict["longitude"] as? Double
                {
                    arrLats.append(strLat)
                    arrLongs.append(strLong)
                }
            }
        }
        
        // Draw Polygon Starts
        
        for ind in 0..<arrLats.count
        {
            let latt:Double = arrLats[ind]
            let longg:Double = arrLongs[ind]
            rect.add(CLLocationCoordinate2D(latitude: latt, longitude: longg))
        }
        
        mapCenterCamera = GMSCameraPosition.camera(withLatitude: latCenter, longitude: longCenter, zoom: 14.5)
        mapView.camera = mapCenterCamera
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor =  UIColor(red: 153.0/255.0, green: 173.0/255.0, blue: 255.0/255.0, alpha: 0.35)
        polygon.strokeColor = UIColor.colorWithHexString("549BEC")
        polygon.strokeWidth = 1
        polygon.geodesic = true
        polygon.map = mapView
        polygon.isTappable = true
        
        // Draw Polygon Ends
        
        //   now add markers for rest of the 2 arrays
        
        for index in 0..<arrOtherPoints_1.count{
            
            let dict:[String:Any] = arrOtherPoints_1[index]
            
            if let latK:Double = dict["latitude"] as? Double
            {
                if let longK:Double = dict["longitude"] as? Double
                {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latK, longitude: longK)
                    marker.map = mapView
                    marker.userData = dict
                    
                    if let pinNumber:Int = dict["pin_icon"] as? Int{
                        if pinNumber == 1
                        {
                            marker.icon = UIImage(named: "pinBlue")
                        }
                        else if pinNumber == 2
                        {
                            marker.icon = UIImage(named: "pinRed")
                        }
                        else
                        {
                            // 3
                            marker.icon = UIImage(named: "pinYellow")
                        }
                    }
                }
            }
        }
        
        for index in 0..<arrOtherPoints_2.count{
            
            let dict:[String:Any] = arrOtherPoints_2[index]
            
            if let latK:Double = dict["latitude"] as? Double
            {
                if let longK:Double = dict["longitude"] as? Double
                {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latK, longitude: longK)
                    marker.map = mapView
                    marker.userData = dict
                    
                    if let pinNumber:Int = dict["pin_icon"] as? Int{
                        if pinNumber == 1
                        {
                            marker.icon = UIImage(named: "pinBlue")
                        }
                        else if pinNumber == 2
                        {
                            marker.icon = UIImage(named: "pinRed")
                        }
                        else
                        {
                            // 3
                            marker.icon = UIImage(named: "pinYellow")
                        }
                    }
                }
            }
        }
    }
    
    func roundSummaryViewCorners()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            summaryContainer.layer.cornerRadius = 20.0
        }
        else if strModel == "iPhone Max"
        {
            summaryContainer.layer.cornerRadius = 20.0
        }
        else if strModel == "iPhone 6+"
        {
            summaryContainer.layer.cornerRadius = 15.0
        }
        else if strModel == "iPhone 6"
        {
            summaryContainer.layer.cornerRadius = 15.0
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else if strModel == "iPhone XR"
        {
            
        }
        summaryContainer.layer.masksToBounds = true
    }
    
    @IBAction func btnBackClick(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMaxMinMapClick(btn:UIButton)
    {
        isMapFullScreen = !isMapFullScreen
        
        if isMapFullScreen == true
        {
            makeMapFullSize()
            imgViewMaxMin.image = UIImage(named: "min")
        }
        else
        {
            makeMapHalfSize()
            imgViewMaxMin.image = UIImage(named: "max")
        }
    }
    
    @IBAction func btnPerformanceClick(btn:UIButton)
    {
        callPeriods()
    }
    
    @IBAction func btnSalesForceClick(btn:UIButton)
    {
        let vc: SalesforceVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "SalesforceVC_ID") as! SalesforceVC
        if let str:String = self.dictMain["zone_id"] as? String{
            vc.zoneID = str
        }
        if let str:String = self.dictMain["zone_name"] as? String{
            vc.zoneName = str
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPDVClick(btn:UIButton)
    {
        let vc: POSsupervisorVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "POSsupervisorVC_ID") as! POSsupervisorVC
        if let str:String = self.dictMain["zone_id"] as? String{
            vc.zoneID = str
        }
        if let str:String = self.dictMain["zone_name"] as? String{
            vc.zoneName = str
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MapSupervisorVC: GMSMapViewDelegate {
    
    // to get event on tap of polygon area overlay
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("User Tapped Layer: \(overlay)")
    }
    
    // create custom Callout view, when u tap marker
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        let customCalloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 215, height: 167))
        
        if let dict:[String:Any] = marker.userData as? [String:Any]{
            print("Dictionary - - - ", dict)
            
            if let str:String = dict["title"] as? String
            {
                customCalloutView.lblTitle.text = str
            }
            if let str:String = dict["sub_title"] as? String
            {
                customCalloutView.lblSubTitle.text = str
            }
            if let str:String = dict["description"] as? String
            {
                customCalloutView.txtViewDesc.text = str
            }
        }
        return customCalloutView
    }
    
    // calls when u tap on custom layout view, note u can't access any button action inside callout view
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let dict:[String:Any] = marker.userData as? [String:Any]{
            print("TAPPED show share screen >>>>>>>> Marker Dictionary - - - ", dict)
            
            var strTitle = "Radar"
            if let titl:String = dict[""] as? String
            {
                strTitle = titl
            }

            // show share Alert here and also on summary view share button
            if let lat:Double = dict["latitude"] as? Double
            {
                if let long:Double = dict["longitude"] as? Double
                {
                    openExternalMaps(latitude: lat, longitude: long, title: strTitle)
                }
            }
        }
    }
    
    //MARK: Open Coordinates in External Map App
    // this will check for below mentioned 4 map apps in device, if available only then show option
    func openExternalMaps(latitude: Double, longitude: Double, title: String?) {
        let application = UIApplication.shared
        let coordinate = "\(latitude),\(longitude)"
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let handlers = [
            ("Apple Maps", "http://maps.apple.com/?q=\(encodedTitle)&ll=\(coordinate)"),
            ("Google Maps", "comgooglemaps://?q=\(coordinate)"),
            ("Waze", "waze://?ll=\(coordinate)"),
            ("Citymapper", "citymapper://directions?endcoord=\(coordinate)&endname=\(encodedTitle)")
        ]
            .compactMap { (name, address) in URL(string: address).map { (name, $0) } }
            .filter { (_, url) in application.canOpenURL(url) }

        guard handlers.count > 1 else {
            if let (_, url) = handlers.first {
                application.open(url, options: [:])
            }
            return
        }
        let alert = UIAlertController(title: "Seleccionar aplicación de mapas", message: nil, preferredStyle: .actionSheet)
        handlers.forEach { (name, url) in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                application.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapSupervisorVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTableData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell: CellZone_Header = tableView.dequeueReusableCell(withIdentifier: "CellZone_Header") as! CellZone_Header
        headerCell.selectionStyle = .none
        headerCell.lblTitle.text = ""
        
        let dict:[String:Any] = arrTableData[section]
        if let str:String = dict["title"] as? String
        {
            headerCell.lblTitle.text = str
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict:[String:Any] = arrTableData[section]
        if let arr:[String] = dict["data"] as? [String]
        {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var arrRow:[String]!
        let dict:[String:Any] = arrTableData[indexPath.section]
        if let arr:[String] = dict["data"] as? [String]
        {
            arrRow = arr
        }
        
        let str:String = arrRow[indexPath.row]
        
        let cell:CellZone_Row = tblView.dequeueReusableCell(withIdentifier: "CellZone_Row", for: indexPath) as! CellZone_Row
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblTitle.text = "\(indexPath.row + 1). " + str
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension MapSupervisorVC
{
    func callPeriods(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:] //  ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_ZonePeriods, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            
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
                        if let arrperiod:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            
                            DispatchQueue.main.async {
                                let vc: PerformanceDetailVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "PerformanceDetailVC_ID") as! PerformanceDetailVC
                                if let str:String = self.dictMain["zone_id"] as? String{
                                    vc.zoneID = str
                                }
                                vc.arrPicker = arrperiod
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
