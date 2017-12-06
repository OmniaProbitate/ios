//
//  IntroViewController.swift
//  prkng-ios
//
//  Created by Cagdas Altinkaya on 7/5/15.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit

class FirstUseViewController: AbstractViewController, TutorialViewControllerDelegate {

    var backgroundImageView : UIImageView
    var logoView : UIImageView
    var parkNowButton : UIButton
    var tourButton : UIButton
    
    
    init() {
        backgroundImageView = UIImageView()
        logoView = UIImageView()
        parkNowButton = ViewFactory.redRoundedButton()
        tourButton = ViewFactory.bigRedRoundedButton()
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
        self.screenName = "Intro - First Use View"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
//        GiFHUD.dismiss()
    }
    
    
    func setupViews () {
        
        view.backgroundColor = Styles.Colors.petrol1
        
        backgroundImageView.image = UIImage(named: "bg_opening")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        view.addSubview(backgroundImageView)
        
        logoView.image = UIImage(named: "logo_opening")
        view.addSubview(logoView)
        
        parkNowButton.setTitle(NSLocalizedString("park_now", comment : ""), for: UIControlState())
        parkNowButton.addTarget(self, action: "didFinishTutorial", for: UIControlEvents.touchUpInside)
        view.addSubview(parkNowButton)
        parkNowButton.isHidden = true
        
        tourButton.setTitle("take_the_tour".localizedString.uppercased(), for: UIControlState())
        tourButton.addTarget(self, action: #selector(FirstUseViewController.tourButtonTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(tourButton)
    }
    
    func setupConstraints () {
        
        
        backgroundImageView.snp_makeConstraints { (make) -> () in
            make.edges.equalTo(self.view)
        }
        
        logoView.snp_makeConstraints { (make) -> () in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).multipliedBy(0.5)
        }
        
        parkNowButton.snp_makeConstraints { (make) -> () in
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 100, height: 26))
            make.bottom.equalTo(self.tourButton.snp_top).offset(-20)
        }
        
        tourButton.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.view).offset(Styles.Sizes.bigRoundedButtonSideMargin)
            make.right.equalTo(self.view).offset(-Styles.Sizes.bigRoundedButtonSideMargin)
            make.bottom.equalTo(self.view).offset(-60)
            make.height.equalTo(Styles.Sizes.bigRoundedButtonHeight)
        }
        
    }
    
    
    func didFinishAndDismissTutorial() {
        self.presentViewControllerWithFade(viewController: LoginViewController()) { () -> Void in
            Settings.setTutorialPassed(true)
        }
    }
    
    func tourButtonTapped() {
        
        if Settings.tutorialPassed() {
            
            self.didFinishAndDismissTutorial()
            
        } else {
            let tutorial = TutorialViewController()
            tutorial.delegate = self
            
            self.present(tutorial, animated: true) { () -> Void in
            }
        }
        
    }

}
