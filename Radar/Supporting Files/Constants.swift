//
//  Constants.swift
//  Unefon
//
//  Created by Abhishek on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import UIKit

// let baseUrl:String = "https://radarapp-development.azurewebsites.net/"   //  DEV
 let baseUrl:String = "https://radarapp.azurewebsites.net/"   //  PROD

let k_baseColor:UIColor = UIColor(named: "AppBlue")!
let k_window:UIWindow = UIApplication.shared.delegate!.window! as! UIWindow
let k_appDel:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
let localTimeZoneName: String = TimeZone.current.localizedName(for: .generic, locale: .current) ?? ""
let k_helper:Helper = Helper.shared
let k_userDef = UserDefaults.standard
let timestamp = Date().timeIntervalSince1970
var deviceToken_FCM = ""
var deviceToken = ""
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
// let platformAccessToken = "7a1479e287dcf39820c027c245d63ab9" // Dev
 let platformAccessToken = "7a1479e287dcf39820c027c245d63ab9" // PROD
var isPad: Bool{
    return (UIDevice.current.userInterfaceIdiom == .phone) ? false : true
}
typealias CompletionHandler = ([String:Any], String, Error?) -> ()

struct ServiceName {
    static let POST_Login = "users/new_validate_credentials"
    static let GET_SelectPlan = "plans/active"
    static let GET_VerifyCode = "users/invitation_codes/validate"
    static let GET_WorkplacesList = "workplaces/get"
    static let GET_StatesList = "catalogues/get"
    static let POST_UploadProfileImageTemp = "temporal-media/upload_file"
    static let POST_UploadImagePOS = "media/upload_file"
    static let PUT_AnalyseProfilePic = "users/auto_analyze_profile_picture"
    static let GET_EachMonthTransactionList = "transactions/tokens/period_transactions"
    static let POST_RegisterUser = "users/register"
    static let POST_LoginUser = "users/validate_credentials"
    static let POST_GlobalSummary = "users/global_summary"
    static let GET_ReloadZoneList = "zones/users/summaries"
    static let GET_AnnouncementList = "announcements/get_active"
    static let GET_PromotionList = "promotions/get_active"
    static let GET_EnterListDetail = "courses/get"
    static let GET_EnterQuiz = "courses/quizz/get_for_user"
    static let POST_SubmitQuiz = "courses/quizz/answers/submit"
    static let POST_UpdatePhoto = "users/profile_picture/update"
    static let POST_UpdateName = "users/company_id/update"
    static let POST_UpdateEmail = "users/quick/update_user_mail_address"
    static let POST_UpdatePhone = "users/quick/update_user_phone_number"
    static let POST_UpdatePassword = "users/update_user_password"
    static let GET_ZoneSummary = "zones/full_user_zone_summary"
    static let POST_ValidateVisit = "actions/visits/validate"
    static let POST_RegisterVisit = "actions/visits/register"
    static let POST_POS_Validate = "actions/pos/validate"
    static let POST_POS_SearchAddress = "zones/addresses/search"
    static let POST_POS_Yes_Address = "zones/points/search"
    static let POST_POS_Register = "actions/pos/register"
    static let POST_NewSale_Validate = "actions/sales/validate"
    static let GET_ValidateSIM = "actions/sales/iccid/validate"
    static let POST_NewSim_Register = "actions/sales/register"
    static let GET_LeaderboardPeriods = "leaderboards/periods"
    static let GET_LeaderboardUsers = "leaderboards/users"
    static let GET_GetWalletList = "gifts/wallet/get"
    static let GET_GetWalletCode = "gifts/wallet/code/get"
    static let PUT_AcceptTermsWalletGift = "gifts/codes/accept_tc"
    static let GET_NotificationList = "notifications/summaries"
    static let GET_SecurityCodeForgotpssword = "users/supervisors/security_codes/request"
    static let POST_Forgotpssword = "users/supervisors/password/recover"
    static let GET_AvailableZoneList = "zones/plan/counter"
    static let GET_AvailableStates = "zones/plan/states"
    static let POST_SearchZones = "zones/plan/performance/search"
    static let POST_ZoneDetail = "zones/full_plan_zone_summary"
    static let POST_ZonePerformance = "zones/plan/performance"
    static let GET_ZonePeriods = "zones/periods"
    static let POST_PromotorPerformance = "zones/promoters/performance"
    static let GET_DisableUser = "zones/users/disassign"
    static let GET_POSsupervisor = "zones/pos/performance"
    static let GET_UserManageSearch = "users/plan/search"
    static let POST_UserManagePerformance = "users/promoters/performance"
    static let GET_ZoneCatalog = "catalogues/get"
    static let GET_ZoneHistory = "zones/users/history"
    static let PUT_EnableUser = "users/enable"
    static let PUT_DisableUser = "users/disable"
    static let GET_ProfileBase = "plans/distributors/profile_base"
    static let POST_SalesProfile = "plans/sim_sales/summary"
    static let POST_SearchPosZones = "zones/pos/micro_summaries/search"
    static let PUT_InvitationCode = "users/invitation_codes/promoters/create"
    static let PUT_InvitationCode_Supervisor = "users/invitation_codes/supervisors/create"
    static let GET_ZoneSummaryAssign = "zones/plan/list_summaries"
    static let POST_AssignZoneUser = "/zones/users/assign"
    static let GET_Reports = "reports/dynamic_reports/available"
    static let GET_ReportDownload = "reports/dynamic_reports/download"
    static let GET_GenerateSecurityCode = "users/promoters/security_codes/generate"
}

enum userDefaultKeys :String
{
    case uuid = "Radar_uuid"
    case user_type = "Radar_userType"
    case plan = "Radar_plan"
    case user_Loginid = "Inspirum_LoginId"
}

struct CustomFont
{
    static let regular = "OpenSans-Regular"
    static let semiBold = "OpenSans-SemiBold"
    static let bold = "OpenSans-Bold"
    static let light = "OpenSans-Light"
}

enum AppStoryBoards : String
{
    case Main, BaseTabBar, Training, Announcement, Home, Zone, UserPoints, Entertainment, Profile, UserManage, HomeSupervisor
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

protocol updateRootVCWithRewardsPopUpDelegate {
    func showPopUp(title:String, desc:String, points:String)
}
