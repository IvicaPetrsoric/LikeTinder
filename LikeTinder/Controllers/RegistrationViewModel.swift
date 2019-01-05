import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsregistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormVaild = Bindable<Bool>()
    
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
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableIsregistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            
            print("Successfully registreted user: ", res?.user.uid ?? "")
            
            let fileName = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            
            ref.putData(imageData, metadata: nil, completion: { (_, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                print("Finished upload image to storage")
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        completion(err)
                        return
                    }
                    
                    print("Download url of our image is: \(url?.absoluteString ?? "")")
                    self.bindableIsregistering.value = false
                })
            })
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormVaild.value = isFormValid
    }
    
}
