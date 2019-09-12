//
//  ChatLogController.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 12/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools
import Firebase

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
        
        collectionView.keyboardDismissMode = .interactive
        
        fetchMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc private func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    private func fetchMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Failed to fetch messages:", err)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            })
            
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
        
//        query.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Failed to feetch messages:", err)
//                return
//            }
//
//            querySnapshot?.documents.forEach({ (documentSnapshot) in
//                print(documentSnapshot.data())
//                self.items.append(Message.init(dictionary: documentSnapshot.data()))
//            })
//
//            self.collectionView.reloadData()
//        }
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
    
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    @objc private func handleSend() {
        print(customInputView.textView.text ?? "")
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let collection = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid)
        
        let data = [
            "text": customInputView.textView.text ?? "",
            "fromId": currentUserId, "toId": match.uid,
            "timestamp": Timestamp(date: Date())
        ] as [String: Any]
        
        collection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message:", err)
                return
            }
            
            print("Successfully saved msg into firebase")
            self.customInputView.textView.text = nil
            self.customInputView.placeholderLabel.isHidden = false
        }
        
        let toCollection = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserId)
        toCollection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message:", err)
                return
            }
            
            print("Successfully saved msg into firebase")
            self.customInputView.textView.text = nil
            self.customInputView.placeholderLabel.isHidden = false
        }

    }
    
    // input AccessoryView
    override var inputAccessoryView: UIView? {
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
