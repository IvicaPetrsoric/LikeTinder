import UIKit
import FirebaseFirestore
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControlls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
//        navigationController?.isNavigationBarHidden = true // disables back dragging!!
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomControlls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControlls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControlls.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
//        setupFirestoreUserCards()
//        fetchUsersFromFirestore()
    }
    
    @objc private func handleMessages() {
//        let vc = MatchesMessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        let vc = MatchesMessagesController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                self.hud.dismiss()
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.fetchSwipes()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipes for currently logged in user:", err)
                return
            }
            
            print("Swipes: ", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else {
                self.fetchUsersFromFirestore()
                return
            }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach{($0.removeFromSuperview())}
        fetchUsersFromFirestore()
    }
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var lastFecthedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 10)
        topCardView = nil
        
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                
                let user = User(dictionary: userDictionary)
                self.users[user.uid ?? ""] = user
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBoefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBoefore = true
                if isNotCurrentUser && hasNotSwipedBoefore  {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var users = [String: User]()
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUid = topCardView?.cardViewModel.uid else { return }
        let documentData = [
            cardUid: didLike,
        ]
        
        // 1st fetch, check if exsist and then update!
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document: ",err)
                return
            }
            
            if snapshot?.exists == true{
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to update swipe data:", err.localizedDescription)
                        return
                    }
                    
                    print("Successfully update swiped...")
                    
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUid: cardUid)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err.localizedDescription)
                        return
                    }
                    
                    print("Successfully saved swiped...")
                    
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUid: cardUid)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUid: String) {
        Firestore.firestore().collection("swipes").document(cardUid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch document for card user:",err)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                print("Has matched")
                self.presentMatchView(cardUid: cardUid)
                
                guard let cardUser = self.users[cardUid] else { return }
                
                let data = ["name": cardUser.name ?? "", "profileImageUrl": cardUser.imageUrl1 ?? "", "uid": cardUid, "timestamp": Timestamp(date: Date())] as [String: Any]
                
                Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUid).setData(data, completion: { (err) in
                    if let err = err {
                        print("Failed  to save data for matching: ", err.localizedDescription)
                        return
                    }
                })
                
                guard let currentUser = self.user else { return }
                
                let otherMatchData = ["name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "", "uid": currentUser.uid, "timestamp": Timestamp(date: Date())] as [String: Any]
                
                Firestore.firestore().collection("matches_messages").document(cardUid).collection("matches").document(uid).setData(otherMatchData, completion: { (err) in
                    if let err = err {
                        print("Failed  to save data for matching: ", err.localizedDescription)
                        return
                    }
                })
            }
        }
    }
    
    fileprivate func presentMatchView(cardUid: String) {
        let matchView = MatchView()
        matchView.cardUid = cardUid
        matchView.currentUser = user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    @objc func handleDisLike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimaton = CABasicAnimation(keyPath: "position.x")
        translationAnimaton.toValue = translation
        translationAnimaton.duration = duration
        translationAnimaton.fillMode = .forwards
        translationAnimaton.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimaton.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimaton, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white

        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControlls])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

extension HomeController: SettingsControllerDelegate {
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
}

extension HomeController: LoginControllerDelegate {
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
}

extension HomeController: CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func swipeCard(left: Bool) {
        if left {
            handleDisLike()
        } else {
            handleLike()
        }
    }
}
