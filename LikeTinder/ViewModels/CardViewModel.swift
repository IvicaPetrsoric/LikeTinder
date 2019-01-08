import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// define the properties that view will display
class CardViewModel {
    
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    // Reactive programing
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}

