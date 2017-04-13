//
//  SetterTableViewCell.swift
//  DailyTip
//
//  Created by 张兴业 on 2017/4/10.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class SetterTableViewCell: UITableViewCell {

    lazy var name: UILabel = {
       
        let lable = UILabel()
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 14)
        
        return lable
        
    }()
    
    lazy var detail: UILabel = {
        
        let lable = UILabel()
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 11)
        
        return lable
        
    }()
    
    lazy var rightArrow: UIImageView = {
        
        let imageview = UIImageView(image: UIImage(named: "setter_right_arrow"))
        
        return imageview
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    func setupUI() {
        
        self.contentView.addSubview(name)
        self.contentView.addSubview(detail)
        self.contentView.addSubview(rightArrow)
        
        name.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView.snp.left).offset(8)
            make.width.greaterThanOrEqualTo(1)
            make.height.greaterThanOrEqualTo(1)
            
        }
        
        rightArrow.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.name.snp.centerY)
            make.right.equalTo(self.contentView.snp.right).offset(-8)
            make.size.equalTo(CGSize(width: 16, height: 16))
            
        }
        
        detail.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.rightArrow.snp.left).offset(-8)
            make.width.greaterThanOrEqualTo(1)
            make.height.greaterThanOrEqualTo(1)
        }
        
        
    }
    
    func displayData(name: String, detail: String) {
        
        self.name.text = name
        
        self.detail.text = detail
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
