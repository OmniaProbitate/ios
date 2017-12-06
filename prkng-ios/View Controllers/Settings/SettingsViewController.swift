//
//  SettingsViewController.swift
//  prkng-ios
//
//  Created by Cagdas Altinkaya on 19/04/15.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: AbstractViewController, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var topContainer : UIView
    
    var profileButton : UIButton
    var profileContainer : UIView
    var profileImageView : UIImageView
    var profileTitleLabel : UILabel
    var profileNameLabel : UILabel
    
    var cityContainer : UIView
    var prevCityButton : UIButton
    var nextCityButton : UIButton
    var cityLabel : UILabel
    
    let tableView = PRKCachedTableView()

    var sendLogButton : UIButton
    
    var delegate: SettingsViewControllerDelegate?
    
    fileprivate(set) var PROFILE_CONTAINER_HEIGHT = 120
    fileprivate(set) var CITY_CONTAINER_HEIGHT = 48
    fileprivate(set) var SMALL_CELL_HEIGHT: CGFloat = 48
    fileprivate(set) var BIG_CELL_HEIGHT: CGFloat = 61
    
    init() {
        
        topContainer = UIView()
        
        profileButton = UIButton()
        profileContainer = UIView()
        profileImageView = UIImageView()
        profileTitleLabel = ViewFactory.formLabel()
        profileNameLabel = UILabel()
        
        cityContainer = TouchForwardingView()
        prevCityButton = UIButton()
        nextCityButton = UIButton()
        cityLabel = UILabel()
        
        sendLogButton = ViewFactory.exclamationButton()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func loadView() {
        self.view = UIView()
        setupViews()
        setupConstraints()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Settings View"
        
        if (AuthUtility.loginType() == .Facebook){
            profileTitleLabel.text = "login_edit_message_facebook".localizedString.uppercased()
        } else if (AuthUtility.loginType() == .Google){
            profileTitleLabel.text = "login_edit_message_google".localizedString.uppercased()
        } else {
            profileTitleLabel.text = "edit_profile".localizedString.uppercased()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cityLabel.text = Settings.selectedCity().displayName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let debugFeaturesOn = UserDefaults.standard.bool(forKey: "enable_debug_features")
        sendLogButton.isHidden = !debugFeaturesOn
        
        if let user = AuthUtility.getUser() {
            self.profileNameLabel.text = user.fullName
            if let imageUrl = user.imageUrl {
                self.profileImageView.sd_setImage(with: URL(string: imageUrl))
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    func setupViews () {
        
        view.backgroundColor = Styles.Colors.stone
        
        view.addSubview(tableView)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(self.CITY_CONTAINER_HEIGHT + self.PROFILE_CONTAINER_HEIGHT + 20)))
        tableView.tableFooterView = self.tableFooterView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.clipsToBounds = true

        topContainer.backgroundColor = Styles.Colors.midnight1
        view.addSubview(topContainer)
        
        topContainer.addSubview(profileContainer)
        
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        profileContainer.addSubview(profileImageView)
        
        profileTitleLabel.font = Styles.FontFaces.regular(10)
        profileTitleLabel.textColor = Styles.Colors.anthracite1
        profileTitleLabel.textAlignment = .left
        profileContainer.addSubview(profileTitleLabel)
        
        profileNameLabel.font = Styles.Fonts.h3
        profileNameLabel.textColor = Styles.Colors.cream1
        profileNameLabel.textAlignment = .left
        profileContainer.addSubview(profileNameLabel)
        
        profileButton.addTarget(self, action: #selector(SettingsViewController.profileButtonTapped(_:)), for: .touchUpInside)
        topContainer.addSubview(profileButton)
        
        cityContainer.backgroundColor = Styles.Colors.red2
        topContainer.addSubview(cityContainer)
        
        cityLabel.font = Styles.Fonts.h3
        cityLabel.textColor = Styles.Colors.cream1
        cityContainer.addSubview(cityLabel)
        
        prevCityButton.setImage(UIImage(named: "btn_left"), for: UIControlState())
        prevCityButton.addTarget(self, action: #selector(SettingsViewController.prevCityButtonTapped), for: UIControlEvents.touchUpInside)
        cityContainer.addSubview(prevCityButton)
        
        nextCityButton.setImage(UIImage(named: "btn_right"), for: UIControlState())
        nextCityButton.addTarget(self, action: #selector(SettingsViewController.nextCityButtonTapped), for: UIControlEvents.touchUpInside)
        cityContainer.addSubview(nextCityButton)
        
        sendLogButton.addTarget(self, action: #selector(SettingsViewController.sendLogButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(sendLogButton)
        
    }
    
    func setupConstraints () {
        
        cityContainer.snp_makeConstraints { (make) -> () in
            make.height.equalTo(self.CITY_CONTAINER_HEIGHT)
            make.left.equalTo(self.topContainer)
            make.right.equalTo(self.topContainer)
            make.top.equalTo(self.profileContainer.snp_bottom)
        }
        
        topContainer.snp_makeConstraints { (make) -> () in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(self.PROFILE_CONTAINER_HEIGHT+self.CITY_CONTAINER_HEIGHT+20)
        }
        
        profileContainer.snp_makeConstraints { (make) -> () in
            make.top.equalTo(self.topContainer).offset(20)
            make.height.equalTo(self.PROFILE_CONTAINER_HEIGHT)
            make.left.equalTo(self.topContainer)
            make.right.equalTo(self.topContainer)
        }
        
        profileImageView.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.view).offset(34)
            make.centerY.equalTo(self.profileContainer)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        profileTitleLabel.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.profileImageView.snp_right).offset(20)
            make.bottom.equalTo(self.profileImageView).offset(1)
            make.right.equalTo(self.profileContainer)
        }
        
        profileNameLabel.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.profileImageView.snp_right).offset(20)
            make.top.equalTo(self.profileImageView).offset(-2)
            make.right.equalTo(self.profileContainer)
        }
        
        profileButton.snp_makeConstraints { (make) -> () in
            make.edges.equalTo(profileContainer)
        }
        
        cityLabel.snp_makeConstraints { (make) -> () in
            make.center.equalTo(self.cityContainer)
        }
        
        prevCityButton.snp_makeConstraints { (make) -> () in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.left.equalTo(self.cityContainer).offset(5)
            make.centerY.equalTo(self.cityContainer)
        }
        
        nextCityButton.snp_makeConstraints { (make) -> () in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.right.equalTo(self.cityContainer).offset(-5)
            make.centerY.equalTo(self.cityContainer)
        }
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        sendLogButton.snp_makeConstraints { (make) -> () in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(self.view).offset(14+20)
            make.right.equalTo(self.view).offset(-20)
        }

    }
    
    func sendLogButtonTapped(_ sender: UIButton) {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        let udid = UUID().uuidString
        mailVC.setSubject("Support Ticket - " + udid)
        mailVC.setToRecipients(["ant@prk.ng"])
        if let filePath = Settings.logFilePath() {
            if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                mailVC.addAttachmentData(fileData, mimeType: "text", fileName: udid + ".log")
                self.present(mailVC, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITableView cells and button selectors
    
    func showSupport() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject("Support")
            mailVC.setToRecipients(["support@prk.ng"])
            self.present(mailVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.title = "no_mail_accounts_title".localizedString
            alert.message = "no_mail_accounts_body".localizedString
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    
    func showAbout() {
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    func showGettingStarted() {
        let tutorialVC = TutorialViewController()
        self.present(tutorialVC, animated: true, completion: nil)
    }
    
    func sendToAppStore() {
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id999834216")!)
    }
    
    func showFaq() {
        let webViewController = PRKWebViewController(englishUrl: "https://prk.ng/faq", frenchUrl: "https://prk.ng/fr/faq")
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showTerms() {
        let webViewController = PRKWebViewController(englishUrl: "https://prk.ng/terms", frenchUrl: "https://prk.ng/fr/conditions")
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showPrivacy() {
        let webViewController = PRKWebViewController(englishUrl: "https://prk.ng/privacypolicy", frenchUrl: "https://prk.ng/fr/politique")
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showShareSheet() {
        
        let text = "prkng_share_copy".localizedString
        let url = URL(string:"https://prk.ng/")!
        
        let activityViewController = UIActivityViewController( activityItems: [text, url], applicationActivities: nil)
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    func signOut() {
        SVProgressHUD.show()
        Settings.logout()
    }
    
    func prevCityButtonTapped() {
        
        
        var index : Int = 0
        for city in CityOperations.sharedInstance.availableCities {
            
            if (Settings.selectedCity().name == city.name) {
                break; //found
            }
            index += 1
        }
        
        index -= 1 // previous
        
        if index < 0 {
            index = CityOperations.sharedInstance.availableCities.count - 1
        }
        
        let previousCity = Settings.selectedCity()
        
        Settings.setSelectedCity(CityOperations.sharedInstance.availableCities[index])
        
        cityLabel.text = Settings.selectedCity().displayName
        
        delegate!.cityDidChange(fromCity: previousCity, toCity: CityOperations.sharedInstance.availableCities[index])
        
        self.tableView.layer.addFadeAnimation()
        self.tableView.reloadData()

    }
    
    func nextCityButtonTapped () {
        
        var index : Int = 0
        for city in CityOperations.sharedInstance.availableCities {
            
            if (Settings.selectedCity().name == city.name) {
                break; //found
            }
            index += 1
        }
        
        index += 1 // get next
        
        if (index > CityOperations.sharedInstance.availableCities.count - 1) {
            index = 0
        }
        
        let previousCity = Settings.selectedCity()

        Settings.setSelectedCity(CityOperations.sharedInstance.availableCities[index])
        
        cityLabel.text = Settings.selectedCity().displayName
        
        delegate!.cityDidChange(fromCity: previousCity, toCity: CityOperations.sharedInstance.availableCities[index])
        
        self.tableView.layer.addFadeAnimation()
        self.tableView.reloadData()

    }
    
    func notificationSelectionValueChanged() {
        if Settings.notificationTime() == 0 {
            Settings.setNotificationTime(30)
        } else {
            Settings.setNotificationTime(0)
        }
    }

    func commercialPermitFilterValueChanged() {
        let currentValue = Settings.shouldFilterForCommercialPermit()
        Settings.setShouldFilterForCommercialPermit(!currentValue)
    }

    func residentialPermitFilterValueChanged() {
        let currentValue = Settings.shouldFilterForResidentialPermit()
        Settings.setShouldFilterForResidentialPermit(!currentValue)
        
        if Settings.residentialPermits().isEmpty {
            showResidentialPermitPicker()
        }
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Settings View", action: "Residential Permit Slider Value Changed", label: currentValue == false ? "On" : "Off", value: nil).build() as! [AnyHashable: Any])
    }
    
    func residentialPermitFilterValueNeedsAddition() {
        if Settings.residentialPermits().isEmpty {
            showResidentialPermitPicker()
        } else {
            Settings.setResidentialPermit(nil)
            Settings.setShouldFilterForResidentialPermit(false)
            self.tableView.reloadData()
        }
    }
    
    fileprivate func showResidentialPermitPicker() {
        //bring up the rolly thingy
        CityOperations.getSupportedResidentialPermits(Settings.selectedCity()) { (completed, permits) -> Void in
            if completed {
                let pickerVC = UIListPickerViewController(pickerValues: permits, completion: { (selectedValue) -> Void in
                    Settings.setResidentialPermit(selectedValue)
                    Settings.setShouldFilterForResidentialPermit(selectedValue != nil)
                    self.tableView.reloadData()
                })
                self.presentAsModalWithTransparency(pickerVC, completion: nil)
            }
        }
    }

    func snowRemovalFilterValueChanged() {
        let currentValue = Settings.shouldFilterForSnowRemoval()
        Settings.setShouldFilterForSnowRemoval(!currentValue)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Settings View", action: "Snow Removal Slider Value Changed", label: currentValue == false ? "On" : "Off", value: nil).build() as! [AnyHashable: Any])
    }

    func hideCar2GoValueChanged() {
        let currentValue = Settings.hideCar2Go()
        Settings.setHideCar2Go(!currentValue)
    }

    func hideAutomobileValueChanged() {
        let currentValue = Settings.hideAutomobile()
        Settings.setHideAutomobile(!currentValue)
    }

    func hideCommunautoValueChanged() {
        let currentValue = Settings.hideCommunauto()
        Settings.setHideCommunauto(!currentValue)
    }
    
    func hideZipcarValueChanged() {
        let currentValue = Settings.hideZipcar()
        Settings.setHideZipcar(!currentValue)
    }
    
    func profileButtonTapped(_ sender: UIButton) {
        if AuthUtility.loginType()! == LoginType.Email {
            self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
    }
    
    func handleCommunautoSignInButtonTap() {
        
        CarSharingOperations.CommunautoAutomobile.getAndSaveCommunautoCustomerID { (id) -> Void in
            if id == nil {
                //we need to ask the user to log in
                CarSharingOperations.login(.Communauto)
            } else {
                //we have a value, so perform a log out
                //calling getAndSaveCommunautoCustomerID already logged us out, so just update the cell
                CarSharingOperations.CommunautoAutomobile.deleteCommunautoCustomerID()
                self.tableView.reloadData()
            }
            
        }
        
    }

    func handleCar2GoSignInButtonTap() {
        CarSharingOperations.Car2Go.isLoggedInAsynchronous(shouldValidateToken: true, completion: { (loggedIn) -> Void in
            if loggedIn {
                CarSharingOperations.Car2Go.logout()
                self.tableView.reloadData()
            } else {
                CarSharingOperations.login(.Car2Go)
            }
        })
    }

    //MARK: Table Footer View

    func tableFooterView() -> UIView {
        
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(BIG_CELL_HEIGHT))
        let tableFooterView = UIView(frame: frame)
        tableFooterView.backgroundColor = Styles.Colors.stone

        let labelFrame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width-40, height: CGFloat(BIG_CELL_HEIGHT)-10)
        let tableFooterViewLabel = UILabel(frame: labelFrame)
        
        let line1Attributes = [NSFontAttributeName: Styles.FontFaces.bold(12), NSForegroundColorAttributeName: Styles.Colors.petrol2]
        let textLine1 = NSMutableAttributedString(string: "Version " + versionString, attributes: line1Attributes)
        
        let line2Attributes = [NSFontAttributeName: Styles.FontFaces.bold(12), NSForegroundColorAttributeName: Styles.Colors.red2]
        let textLine2 = NSAttributedString(string: "Using test server", attributes: line2Attributes)
        
        if APIUtility.isUsingTestServer {
            textLine1.append(NSAttributedString(string: "\n"))
            textLine1.append(textLine2)
        }
        
        tableFooterViewLabel.numberOfLines = 0
        tableFooterViewLabel.attributedText = textLine1
        tableFooterView.addSubview(tableFooterViewLabel)

        tableFooterViewLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(tableFooterView).offset(20)
            make.right.equalTo(tableFooterView).offset(-20)
            make.bottom.equalTo(tableFooterView).offset(-10)
        }
        
        return tableFooterView
    }
    

    //MARK: UITableViewDataSource
        
    var tableSource: [(String, [SettingsCell])] {
        
        var firstSection = [SettingsCell]()
        var carSharingSection = [SettingsCell]()
        
        let alertCell = SettingsCell(switchValue: Settings.notificationTime() != 0, titleText: "settings_alert".localizedString, subtitleText: "settings_alert_text".localizedString, selectorsTarget: self, switchSelector: "notificationSelectionValueChanged")
        let commercialPermitCell = SettingsCell(switchValue: Settings.shouldFilterForCommercialPermit(), titleText: "settings_commercial_permit".localizedString, subtitleText: "settings_commercial_permit_text".localizedString, selectorsTarget: self, switchSelector: "commercialPermitFilterValueChanged")
        let snowRemovalCell = SettingsCell(switchValue: Settings.shouldFilterForSnowRemoval(), titleText: "settings_snow_removal".localizedString, subtitleText: "settings_snow_removal_text".localizedString, selectorsTarget: self, switchSelector: "snowRemovalFilterValueChanged")
        let residentialPermitCell = SettingsCell(switchValue: Settings.shouldFilterForResidentialPermit(), titleText: "settings_residential_permit".localizedString, subtitleText: "settings_residential_permit_text".localizedString, selectorsTarget: self, switchSelector: "residentialPermitFilterValueChanged", buttonSelector: "residentialPermitFilterValueNeedsAddition", rightSideText: Settings.residentialPermit())
        
        let parkingPandaCell = PPSettingsCell()
        
//        let secondRow = ("garages".localizedString, [SettingsCell(titleText: "Parking lots price", segments: ["hourly".localizedString.uppercaseString , "daily".localizedString.uppercaseString], defaultSegment: (Settings.lotMainRateIsHourly() ? 0 : 1), selectorsTarget: self, selector: "lotRateDisplayValueChanged"),
//            SettingsCell(cellType: .Service, titleText: "ParkingPanda")])

        let car2goCell = SettingsCell(cellType: .ServiceSwitch, titleText: "Car2Go", signedIn: CarSharingOperations.Car2Go.isLoggedInSynchronous(shouldValidateToken: false), switchValue: !Settings.hideCar2Go(), selectorsTarget: self, switchSelector: "hideCar2GoValueChanged", buttonSelector: "handleCar2GoSignInButtonTap")
        let automobileCell = SettingsCell(cellType: .ServiceSwitch, titleText: "Automobile", signedIn: Settings.communautoCustomerID() != nil, switchValue: !Settings.hideAutomobile(), selectorsTarget: self, switchSelector: "hideAutomobileValueChanged", buttonSelector: "handleCommunautoSignInButtonTap")
        let communautoCell = SettingsCell(cellType: .ServiceSwitch, titleText: "Communauto", signedIn: Settings.communautoCustomerID() != nil, switchValue: !Settings.hideCommunauto(), selectorsTarget: self, switchSelector: "hideCommunautoValueChanged", buttonSelector: "handleCommunautoSignInButtonTap")
        let zipcarCell = SettingsCell(cellType: .ServiceSwitch, titleText: "Zipcar", signedIn: nil, switchValue: !Settings.hideZipcar(), selectorsTarget: self, switchSelector: "hideZipcarValueChanged")
        
        firstSection = [alertCell]
        
        if Settings.selectedCity().name == "montreal" {
            firstSection = [alertCell, residentialPermitCell, snowRemovalCell]
            carSharingSection = [car2goCell, automobileCell, communautoCell]
        } else if Settings.selectedCity().name == "quebec" {
            firstSection = [alertCell, residentialPermitCell]
            carSharingSection = [automobileCell, communautoCell]
        } else if Settings.selectedCity().name == "seattle" {
            carSharingSection = [car2goCell, zipcarCell]
        } else if Settings.selectedCity().name == "newyork" {
            firstSection += [commercialPermitCell]
            carSharingSection = [car2goCell, zipcarCell]
        }
        
        if (Settings.selectedCity().name != "montreal" && Settings.selectedCity().name != "quebec") || Settings.getParkingPandaCredentials().0 != nil {
            firstSection += [parkingPandaCell]
        }
        
        let generalSection = [
            SettingsCell(cellType: .Basic, titleText: "rate_us_message".localizedString, selectorsTarget: self, cellSelector: "sendToAppStore", canSelect: true, redText: true, bold: true),
            SettingsCell(cellType: .Basic, titleText: "share".localizedString, selectorsTarget: self, cellSelector: "showShareSheet", canSelect: true, bold: true),
            SettingsCell(cellType: .Basic, titleText: "getting_started_tour".localizedString, selectorsTarget: self, cellSelector: "showGettingStarted", canSelect: true, bold: true),
            SettingsCell(cellType: .Basic, titleText: "support".localizedString, selectorsTarget: self, cellSelector: "showSupport", canSelect: true, bold: true),
            SettingsCell(cellType: .Basic, titleText: "faq".localizedString, selectorsTarget: self, cellSelector: "showFaq", canSelect: true, bold: false),
            SettingsCell(cellType: .Basic, titleText: "terms_conditions".localizedString, selectorsTarget: self, cellSelector: "showTerms", canSelect: true, bold: false),
            SettingsCell(cellType: .Basic, titleText: "privacy_policy".localizedString, selectorsTarget: self, cellSelector: "showPrivacy", canSelect: true, bold: false),
            SettingsCell(cellType: .Basic, titleText: "sign_out".localizedString, selectorsTarget: self, cellSelector: "signOut", canSelect: true, bold: false)]
        
        return [("", firstSection),
            ("car_sharing".localizedString, carSharingSection),
            ("general".localizedString, generalSection)
        ]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableSource[indexPath.section].1[indexPath.row]
        let cell = settingsCell.tableViewCell(tableView)
        self.tableView.cachedCells.append(cell)
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let settingsCell = tableSource[indexPath.section].1[indexPath.row]
        return settingsCell.canSelect
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsCell = tableSource[indexPath.section].1[indexPath.row]
        if settingsCell.selectorsTarget != nil && settingsCell.cellSelector != nil {
            settingsCell.selectorsTarget!.perform(Selector(settingsCell.cellSelector!))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return BIG_CELL_HEIGHT
        default: return SMALL_CELL_HEIGHT
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default: return BIG_CELL_HEIGHT
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = tableSource[section].0
        return GeneralTableHelperViews.sectionHeaderView(headerText)
    }
    
    //MARK: scroll view delegate for the tableview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        NSLog("scroll view content offset is (%f,%f)", scrollView.contentOffset.x, scrollView.contentOffset.y)
        let yOffset = scrollView.contentOffset.y
        topContainer.snp_remakeConstraints { (make) -> () in
            make.top.equalTo(self.view).offset(-yOffset)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(self.PROFILE_CONTAINER_HEIGHT+self.CITY_CONTAINER_HEIGHT+20)
        }
        if yOffset >= 0 {
            if view.backgroundColor != Styles.Colors.stone {
                view.backgroundColor = Styles.Colors.stone
            }
        } else {
            if view.backgroundColor != Styles.Colors.midnight1 {
                view.backgroundColor = Styles.Colors.midnight1
            }
        }

    }
    
}

protocol SettingsViewControllerDelegate {
    func goToCoordinate(_ coordinate: CLLocationCoordinate2D, named name: String, showing: Bool)
    func cityDidChange(fromCity: City, toCity: City)
}
