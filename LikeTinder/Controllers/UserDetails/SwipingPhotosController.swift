import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    let controllers = [
        PhotoController(image: #imageLiteral(resourceName: "super_like_circle")),
        PhotoController(image: #imageLiteral(resourceName: "top_left_profile")),
        PhotoController(image: #imageLiteral(resourceName: "app_icon"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .white
        
        setViewControllers([controllers.first!], direction: .forward, animated: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        return index == controllers.count - 1 ? nil : controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        return index == 0 ? nil : controllers[index - 1]
    }
    
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView()
    
    init(image: UIImage) {
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
