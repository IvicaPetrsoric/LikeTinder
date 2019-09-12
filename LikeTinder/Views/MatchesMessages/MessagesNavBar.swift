//
//  MessagesNavBar.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 12/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "kelly2"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9995064139, green: 0.3604712486, blue: 0.3536939919, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9995064139, green: 0.3604712486, blue: 0.3536939919, alpha: 1))
    
    private let match: Match
    
    init(match: Match) {
        self.match = match
        self.nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center),
            alignment: .center
        )
        
        hstack(backButton,
               middleStack,
               flagButton).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
