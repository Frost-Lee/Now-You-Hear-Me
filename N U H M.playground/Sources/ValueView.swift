import UIKit

public class ValueView: UIView {
    
    public var lowView: UIView = UIView()
    public var highView: UIView = UIView()
    public var valueConstraint: NSLayoutConstraint!
    public var zeroOffset: CGFloat = 16
    private var value: Double = 0
    
    public init() {
        super.init(frame: CGRect.zero)
        
        self.addSubview(lowView)
        self.addSubview(highView)
        self.backgroundColor = backgroundColor
        
        lowView.translatesAutoresizingMaskIntoConstraints = false
        lowView.backgroundColor = barColor
        highView.translatesAutoresizingMaskIntoConstraints = false
        highView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.15)
        
        NSLayoutConstraint.activate([
            highView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            highView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            highView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            lowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            lowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            lowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            lowView.topAnchor.constraint(equalTo: highView.bottomAnchor, constant: 0)
        ])
        
        valueConstraint = lowView.heightAnchor.constraint(equalToConstant: zeroOffset)
        valueConstraint.isActive = true
        
        self.clipsToBounds = true
        self.highView.clipsToBounds = true
        self.lowView.clipsToBounds = true
        layoutSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 6
        let width = self.frame.width
        let height = self.frame.height
        highView.layer.cornerRadius = width / 8
        lowView.layer.cornerRadius = width / 8
        zeroOffset = width * (0.125 + 1.0 / 6.0) + height / 32.0
        changeValue(to: value, animated: false)
    }
    
    public func changeValue(to value: Double, animated: Bool = true) {
        self.value = value
        valueConstraint.constant = (self.frame.height - zeroOffset) * CGFloat(value) + zeroOffset
        self.setNeedsUpdateConstraints()
        if animated {
            UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseInOut,
                           animations: {self.layoutIfNeeded()}, completion: nil)
        } else {
            UIView.animate(withDuration: 0, delay: 0, options: .curveLinear,
                           animations: {self.layoutIfNeeded()}, completion: nil)
        }
    }
    
    public func reset() {
        self.value = 0
        valueConstraint.constant = zeroOffset
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseInOut,
                       animations: {self.layoutIfNeeded()}, completion: nil)
    }
    
}
