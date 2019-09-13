//
//  MatchCell.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 13/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<Match> {
    
    let profileImageeView = UIImageView(image: #imageLiteral(resourceName: "jane2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold),
                                textColor: #colorLiteral(red: 0.2550676465, green: 0.2552897036, blue: 0.2551020384, alpha: 1), textAlignment: .center, numberOfLines: 2)
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            profileImageeView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageeView.clipsToBounds = true
        profileImageeView.constrainWidth(80)
        profileImageeView.constrainHeight(80)
        profileImageeView.layer.cornerRadius = 80 / 2
        
        stack(stack(profileImageeView, alignment: .center),
              usernameLabel)
    }
    
}
