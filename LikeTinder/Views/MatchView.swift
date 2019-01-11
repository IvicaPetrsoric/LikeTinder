import UIKit

class MatchView: UIView {
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and Y have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    fileprivate lazy var sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setuoBlurView()
        setuoLayout()
    }
    
    fileprivate func setuoLayout() {
        addSubview(itsAMatchImageView)
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil,
                                  padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 140, height: 140))
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil,
                                 padding: .init(top: 0, left: 16, bottom: 0, right: 0)  ,size: .init(width: 140, height: 140))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                                 padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil,
                                 trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 0, height: 60))
    }
    
    fileprivate func setuoBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blur)
        visualEffectView.alpha = 0
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
