import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    @objc fileprivate func handleDislike() {
        
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupLayout()
        setupVisualBluerEffectView()
        setupBottomControls()
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -16
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupVisualBluerEffectView() {
        let bluerEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: bluerEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)

        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor,
                         padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,
                             padding: .init(top: -25, left: 0, bottom: 0, right: 16), size: .init(width: 50, height: 50))
    }
    
    fileprivate let extraSwipingHeight: CGFloat = 80
    
    override func viewDidLayoutSubviews() {
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let swipingView = swipingPhotosController.view!
        let changeY = -scrollView.contentOffset.y
        var width =  view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        swipingView.frame = CGRect(x: min(0,-changeY), y: min(0,-changeY), width: width, height: width + extraSwipingHeight)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
}
