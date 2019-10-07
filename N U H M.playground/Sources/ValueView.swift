import UIKit

public class ValueView: UIView {
    
    private var lowView: UIView = {
        let view = UIView()
        view.backgroundColor = barColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    private var highView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    private var valueConstraint: NSLayoutConstraint!
    private var zeroOffset: CGFloat = 16
    private var value: Double = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lowView)
        self.addSubview(highView)
        
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
        
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
        
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
        UIView.animate(
            withDuration: timeInterval,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.valueConstraint.constant = (self.frame.height - self.zeroOffset) * CGFloat(value) + self.zeroOffset
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    public func reset() {
        self.value = 0
        UIView.animate(
            withDuration: timeInterval,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.valueConstraint.constant = self.zeroOffset
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
}
