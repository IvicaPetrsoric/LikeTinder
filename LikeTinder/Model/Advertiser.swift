import UIKit

struct Advertiser: ProducesCardViewModel {
    
    let title: String
    let brandName: String
    let posterPjotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return CardViewModel(imageName: posterPjotoName, attributedString: attributedText, textAligment: .center)
    }
    
}
