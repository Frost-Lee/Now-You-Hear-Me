import UIKit

public protocol PickerViewDelegate {
    func valueChanged(_ sender: PickerView, to value: RecursiveFormula)
}

public class PickerView: UIView {
    
    private static var formulaCases: [RecursiveFormula] = RecursiveFormula.allCases
    
    private var fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var candidateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = highLightColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var leftMoveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = secondaryBackgroundColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(leftMoveButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var rightMoveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = secondaryBackgroundColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(rightMoveButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var isEnabled: Bool = true {
        didSet {
            leftMoveButton.isEnabled = isEnabled
            rightMoveButton.isEnabled = isEnabled
        }
    }
    
    public var delegate: PickerViewDelegate?
    public var currentValue: RecursiveFormula {
        get {
            return PickerView.formulaCases[currentValueIndex]
        }
    }
    private var currentValueIndex: Int = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        fullStackView.addArrangedSubview(leftMoveButton)
        fullStackView.addArrangedSubview(candidateLabel)
        fullStackView.addArrangedSubview(rightMoveButton)
        addSubview(fullStackView)
        
        NSLayoutConstraint.activate([
            fullStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            fullStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            fullStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            fullStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            leftMoveButton.widthAnchor.constraint(equalToConstant: 32),
            rightMoveButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        setValue(PickerView.formulaCases[currentValueIndex], animated: false)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setValue(_ value: RecursiveFormula, animated: Bool) {
        if animated {
            UIView.transition(with: candidateLabel, duration: 0.16, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.candidateLabel.text = value.name()
            }, completion: nil)
        } else {
            candidateLabel.text = value.name()
        }
        currentValueIndex = PickerView.formulaCases.firstIndex(of: value)!
        delegate?.valueChanged(self, to: value)
    }
    
    @objc private func leftMoveButtonTapped(_ sender: UIButton) {
        currentValueIndex -= 1
        if currentValueIndex < 0 {
            currentValueIndex = PickerView.formulaCases.count - 1
        }
        setValue(PickerView.formulaCases[currentValueIndex], animated: true)
    }
    
    @objc private func rightMoveButtonTapped(_ sender: UIButton) {
        currentValueIndex += 1
        if currentValueIndex >= PickerView.formulaCases.count {
            currentValueIndex = 0
        }
        setValue(PickerView.formulaCases[currentValueIndex], animated: true)
    }
    
}
