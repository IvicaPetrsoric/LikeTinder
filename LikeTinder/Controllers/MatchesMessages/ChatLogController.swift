//
//  ChatLogController.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 12/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

struct Message {
    let text: String
    let isFromCurrentLoggedUser: Bool
}

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

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    private lazy var customNavBar = MessagesNavBar(match: self.match)
    
    private let navBarHeight: CGFloat = 120
    
    private let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        
        items = [
            Message(text: "jer sma mislila da damir zove i da me sprda. imaju isti glas. i javila sam se koda je on. dobro da nisam rekla nesto gore hahaha", isFromCurrentLoggedUser: false),
            Message(text: "toster", isFromCurrentLoggedUser: true),
            Message(text: "toster", isFromCurrentLoggedUser: true),
            Message(text: "jer sma mislila da damir zove i da me sprda. imaju isti glas. i javila sam se koda je on. dobro da nisam rekla nesto gore hahaha", isFromCurrentLoggedUser: true),
            Message(text: "jer sma mislila da damir zove i da me sprda. imaju isti glas. i javila sam se koda je on. dobro da nisam rekla nesto gore hahaha", isFromCurrentLoggedUser: false),
            
        ]
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                            bottom: nil, trailing: view.trailingAnchor,
                            size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        collectionView.scrollIndicatorInsets.top = navBarHeight
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
