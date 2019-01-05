import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }
    
    var imageObserver: ((UIImage?) -> ())?
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
//    var isFormValidObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormVaild.value = isFormValid
    }
    
    var bindableIsFormVaild = Bindable<Bool>()
    
}
