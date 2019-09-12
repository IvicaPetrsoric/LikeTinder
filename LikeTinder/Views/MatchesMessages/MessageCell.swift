//
//  MessageCell.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 12/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.8971037269, green: 0.9012648463, blue: 0.8937560916, alpha: 1))
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFromCurrentLoggedUser {
                anchoredConstraints.leading?.isActive = false
                anchoredConstraints.trailing?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.06938972324, green: 0.7558894157, blue: 0.9999750257, alpha: 1)
                textView.textColor = .white
            } else {
                anchoredConstraints.leading?.isActive = true
                anchoredConstraints.trailing?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.8971037269, green: 0.9012648463, blue: 0.8937560916, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    private var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor,
                                                     bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 12
        anchoredConstraints.trailing?.constant = -12
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
    
}
