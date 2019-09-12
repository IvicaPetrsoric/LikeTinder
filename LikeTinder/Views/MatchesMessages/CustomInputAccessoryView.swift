//
//  CustomInputAccessoryView.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 12/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

class CustomInputAccessoryView: UIView {
    
    let textView = UITextView()
    let sendButton = UIButton(title: "SEND", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    
    let placeholderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        sendButton.constrainHeight(60)
        sendButton.constrainWidth(60)
        
        hstack(textView,
               sendButton.withSize(.init(width: 60, height: 60)),
               alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        //        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        //        stackView.alignment = .center
        //
        //        redView.addSubview(stackView)
        //        stackView.fillSuperview()
        //        stackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor,
                                padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func handleTextChange() {
        placeholderLabel.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
