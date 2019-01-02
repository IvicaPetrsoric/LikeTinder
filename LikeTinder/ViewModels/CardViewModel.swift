import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// define the properties that view will display
struct CardViewModel {
    
    let imageName: String
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
}

