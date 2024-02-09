import UIKit
 
final class ViewController: UIViewController {
    private let animatedView = AnimatedView()
    private let slider = UISlider()
    private let animator = UIViewPropertyAnimator(
        duration: 1.0,
        timingParameters: UICubicTimingParameters()
    )
 
    private var leadingConstraint: NSLayoutConstraint?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimator()
    }
 
}
 
extension ViewController {
    private enum LayoutConstants {
        static let animatedViewSize: CGSize = .init(
            width: 50,
            height: 50
        )
        static let animatedViewSizeTopPadding: CGFloat = 20
        static let sliderTopPadding: CGFloat = 15
    }
 
    private func setupUI() {
        view.backgroundColor = .white
        setupAnimatedView()
        setupSlider()
    }
 
    private func setupAnimatedView() {
        animatedView.backgroundColor = .blue
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatedView)
 
        let leadingConstraint = animatedView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        self.leadingConstraint = leadingConstraint
 
        NSLayoutConstraint.activate([
            leadingConstraint,
            animatedView.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor,
                constant: LayoutConstants.animatedViewSizeTopPadding
            ),
            animatedView.widthAnchor.constraint(equalToConstant: LayoutConstants.animatedViewSize.width),
            animatedView.heightAnchor.constraint(equalToConstant: LayoutConstants.animatedViewSize.width)
        ])
    }
 
    private func setupSlider() {
        slider.addAction(
            UIAction {
                [weak self] _ in self?.didSliderTouchEnd()
            },
            for: .touchUpInside
        )
        slider.addAction(
            UIAction { [weak self] action in
                self?.didSliderValueChanged(
                    sender: action.sender as? UISlider
                )
            },
            for: .valueChanged
        )
 
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
 
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            slider.topAnchor.constraint(
                equalTo: animatedView.bottomAnchor,
                constant: LayoutConstants.sliderTopPadding
            )
        ])
    }
}
 
extension ViewController {
    private func setupAnimator() {
        animator.pausesOnCompletion = true
        animator.addAnimations { [weak self] in
            guard let self else {
                return
            }
            
            let xPath = self.calculateAreaPathValue()
            let scaleFactor: CGFloat = 1.5
            self.animatedView.frame.origin.x = xPath
            self.animatedView.transform = CGAffineTransform(rotationAngle: .pi / 2)
                .scaledBy(
                    x: scaleFactor,
                    y: scaleFactor
                )
            
            self.view.layoutIfNeeded()
        }
    }
 
    private func calculateAreaPathValue() -> CGFloat {
        let layoutMarginsHorizontalWidth = view.layoutMargins.right + view.layoutMargins.left
        let animatedViewCurrentWidth = animatedView.bounds.size.width
        
        return UIScreen.main.bounds.width - layoutMarginsHorizontalWidth - animatedViewCurrentWidth
    }
}
 
extension ViewController {
    private func didSliderTouchEnd() {
        slider.setValue(1, animated: true)
        animator.startAnimation()
    }
 
    private func didSliderValueChanged(sender: UISlider?) {
        guard let value = sender?.value else {
            return
        }
        animator.fractionComplete = CGFloat(value)
    }
}
