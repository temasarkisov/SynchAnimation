import UIKit

final class AnimatedView: UIView {
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
    }
}
