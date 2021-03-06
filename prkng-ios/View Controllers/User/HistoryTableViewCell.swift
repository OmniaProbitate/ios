//
//  HistoryTableViewCell.swift
//  prkng-ios
//
//  Created by Cagdas Altinkaya on 16/06/15.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    let dayLabel = UILabel()
    let dateLabel = UILabel()
    let addressLabel = UILabel()
    let seperator = UIView()
    
    var didSetupSubviews : Bool = false
    var didSetupConstraints : Bool = true
    
    override func layoutSubviews() {
        if (!didSetupSubviews) {
            setupSubviews()
            setNeedsUpdateConstraints()
        }
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        if (!didSetupConstraints) {
            setupConstraints()
        }
        super.updateConstraints()
    }
    
    func setupSubviews() {
                
        self.backgroundColor = Styles.Colors.stone
        
        dayLabel.backgroundColor = Styles.Colors.cream1
        dayLabel.font = Styles.Fonts.h1
        dayLabel.textColor = Styles.Colors.red2
        dayLabel.textAlignment = .Center
        contentView.addSubview(dayLabel)
    
        dateLabel.font = Styles.FontFaces.regular(12)
        dateLabel.textColor = Styles.Colors.red2
        contentView.addSubview(dateLabel)
        
        addressLabel.font = Styles.Fonts.h3
        addressLabel.textColor = Styles.Colors.midnight2
        contentView.addSubview(addressLabel)
        
        seperator.backgroundColor = UIColor(white: 0, alpha: 0.05)
        seperator.layer.shadowColor = UIColor(white: 1.0, alpha: 1).CGColor
        seperator.layer.shadowOpacity = 0.05
        seperator.layer.shadowRadius = 1
        seperator.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.addSubview(seperator)
        
        didSetupSubviews = true
        didSetupConstraints = false
    }
    
    func setupConstraints () {
        
        dayLabel.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(75)
        }
        
        dateLabel.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.dayLabel.snp_right).offset(15)
            make.right.equalTo(self.contentView).offset(-25)
            make.top.equalTo(self.contentView).offset(5)
            make.height.equalTo(17)            
        }
        
        addressLabel.snp_makeConstraints { (make) -> () in
            make.top.equalTo(self.dateLabel.snp_bottom).offset(1.5)
            make.left.equalTo(self.dateLabel)
            make.right.equalTo(self.dateLabel)
        }
        
        seperator.snp_makeConstraints { (make) -> () in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-1)
            make.height.equalTo(1)
        }
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
