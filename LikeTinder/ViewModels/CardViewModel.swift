import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// define the properties that view will display
class CardViewModel {
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    init(imageNames: [String], attributedString: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    // Reactive programing
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}

