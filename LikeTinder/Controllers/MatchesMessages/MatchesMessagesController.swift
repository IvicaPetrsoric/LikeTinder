//
//  MatchesMessagesController.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 11/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    
    let profileImageeView = UIImageView(image: #imageLiteral(resourceName: "jane2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold),
                                textColor: #colorLiteral(red: 0.2550676465, green: 0.2552897036, blue: 0.2551020384, alpha: 1), textAlignment: .center, numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
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

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            .red, .blue, .green
        ]
        
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                            bottom: nil, trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 140)
    }
    
}
