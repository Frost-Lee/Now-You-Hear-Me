import UIKit

public class ValueView: UIView {
    
    public var lowView: UIView = UIView()
    public var highView: UIView = UIView()
    public var valueConstraint: NSLayoutConstraint!
    public var zeroOffset: CGFloat = 16
    
    public init() {
        super.init(frame: CGRect.zero)
        
        self.addSubview(lowView)
        self.addSubview(highView)
        self.backgroundColor = backgroundColor
        
        lowView.translatesAutoresizingMaskIntoConstraints = false
        lowView.backgroundColor = barColor
        lowView.layer.cornerRadius = 5
        highView.translatesAutoresizingMaskIntoConstraints = false
        highView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.15)
        highView.layer.cornerRadius = 5
        
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
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeValue(to value: Double) {
        valueConstraint.constant = self.frame.height * CGFloat(value) + zeroOffset
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseInOut,
                       animations: {self.layoutIfNeeded()}, completion: nil)
    }
    
    public func reset() {
        valueConstraint.constant = zeroOffset
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: timeInterval, delay: 0, options: .curveEaseInOut,
                       animations: {self.layoutIfNeeded()}, completion: nil)
    }
    
}
