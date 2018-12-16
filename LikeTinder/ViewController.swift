import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        blueView.backgroundColor = .blue
        setupLayout()
    }
    
    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

}

