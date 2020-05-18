import UIKit

public protocol SliderViewDelegate {
    func valueChanged(_ sender: SliderView, to value: Int)
}

public class SliderView: UIView {
    
    private static var minimumValue: Int = 0
    private static var maximumValue: Int = 9
    private static var valueIndicatorCount: Int = SliderView.maximumValue - SliderView.minimumValue
    private static var activateColor: UIColor = highLightColor
    private static var deactivateColor: UIColor = secondaryBackgroundColor
    
    private var isInteracting: Bool = false
    
    private var fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var maximumIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+"
        return label
    }()
    private var minimumIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-"
        return label
    }()
    private var valueIndicatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var valueIndicatorViews: [UIView] = {
        var views: [UIView] = []
        for index in 0 ..< SliderView.valueIndicatorCount {
            let view = UIView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            view.backgroundColor = SliderView.deactivateColor
            views.append(view)
        }
        return views
    }()
    private var valueIndicatorViewStatuses: [Bool] = Array(repeating: false, count: SliderView.valueIndicatorCount)
    
    public var isEnabled: Bool = true
    
    public var delegate: SliderViewDelegate?
    public var currentValue: Int = SliderView.minimumValue
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        for valueIndicatorView in valueIndicatorViews {
            valueIndicatorStackView.addArrangedSubview(valueIndicatorView)
        }
        
        fullStackView.addArrangedSubview(minimumIndicatorLabel)
        fullStackView.addArrangedSubview(valueIndicatorStackView)
        fullStackView.addArrangedSubview(maximumIndicatorLabel)
        addSubview(fullStackView)
        
        NSLayoutConstraint.activate([
            fullStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            fullStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            fullStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            fullStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touchLocation = touches.first!.location(in: self)
        if isEnabled && touchLocation.x >= valueIndicatorStackView.frame.minX && touchLocation.x <= valueIndicatorStackView.frame.maxX {
            isInteracting = true
            setValue(touch: touches.first!)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard isInteracting else {return}
        setValue(touch: touches.first!)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isInteracting = false
    }
    
    public func setValue(_ value: Int, animated: Bool) {
        guard value >= SliderView.minimumValue && value <= SliderView.maximumValue else {return}
        for index in 0 ..< SliderView.valueIndicatorCount {
            let expectedStatus = index < value - SliderView.minimumValue
            if valueIndicatorViewStatuses[index] != expectedStatus {
                valueIndicatorViewStatuses[index] = expectedStatus
                UIView.transition(with: valueIndicatorViews[index], duration: 0.16, options: .transitionCrossDissolve, animations: { [weak self] in
                    self?.valueIndicatorViews[index].backgroundColor = expectedStatus == true ? SliderView.activateColor : SliderView.deactivateColor
                }, completion: nil)
            }
        }
        currentValue = value
        delegate?.valueChanged(self, to: value)
    }
    
    private func setValue(touch: UITouch) {
        let touchLocation = touch.location(in: valueIndicatorStackView)
        var estimatedValue = 0
        for view in valueIndicatorViews {
            if touchLocation.x > view.frame.midX {
                estimatedValue += 1
            } else {
                break
            }
        }
        setValue(estimatedValue, animated: true)
    }

}
