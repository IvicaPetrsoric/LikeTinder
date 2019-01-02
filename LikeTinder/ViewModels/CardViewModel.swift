import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// define the properties that view will display
struct CardViewModel {
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
}

