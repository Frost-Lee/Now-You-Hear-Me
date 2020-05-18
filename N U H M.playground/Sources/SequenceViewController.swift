import UIKit
import AVFoundation

public class SequenceViewController: UIViewController {
    
    private static var visibleValues: Int = 10
    private static var highestPitch: Int = 34
    
    private var backgroundView: UIView = UIView()
    private var visualizationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var valueViews: [ValueView] = {
        var valueViews: [ValueView] = []
        for _ in 0 ..< SequenceViewController.visibleValues {
            let valueView = ValueView()
            valueView.translatesAutoresizingMaskIntoConstraints = false
            valueViews.append(valueView)
        }
        return valueViews
    }()
    private var numberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var numberLabels: [UILabel] = {
        var labels: [UILabel] = []
        for _ in 0 ..< SequenceViewController.visibleValues {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            labels.append(label)
        }
        return labels
    }()
    private var controlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.backgroundColor = .white
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var initialValue0SliderView: SliderView = {
        let sliderView = SliderView(frame: CGRect.zero)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        return sliderView
    }()
    private var initialValue1SliderView: SliderView = {
        let sliderView = SliderView(frame: CGRect.zero)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        return sliderView
    }()
    private var recursiveFormulaPickerView: PickerView = {
        let pickerView = PickerView(frame: CGRect.zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    private var keyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = interactiveColor
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(keyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var horizontalModeRequiredConstraints: [NSLayoutConstraint] = []
    private var verticalModeRequiredConstraints: [NSLayoutConstraint] = []
    
    private var sequenceValues: [Int] = [] {
        didSet {
            for index in 0 ..< sequenceValues.count {
                if sequenceValues[index] > 99 {
                    numberLabels[index].text = "+"
                } else if sequenceValues[index] < -99 {
                    numberLabels[index].text = "-"
                } else {
                    numberLabels[index].text = String(sequenceValues[index])
                }
            }
        }
    }
    private var precalculatedValues: [Int] = Array(repeating: 0, count: SequenceViewController.visibleValues)
    
    private var isPlaying: Bool = false {
        didSet {
            keyButton.isEnabled = !isPlaying
            keyButton.backgroundColor = keyButton.isEnabled ? interactiveColor : disabledInteractiveColor
            initialValue0SliderView.isEnabled = !isPlaying
            initialValue1SliderView.isEnabled = !isPlaying
            recursiveFormulaPickerView.isEnabled = !isPlaying
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    public override func loadView() {
        super.loadView()
        
        self.view = backgroundView
        backgroundView.backgroundColor = backgroundColor
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initialValue0SliderView.delegate = self
        initialValue1SliderView.delegate = self
        recursiveFormulaPickerView.delegate = self
        
        for index in 0 ..< SequenceViewController.visibleValues {
            valueStackView.addArrangedSubview(valueViews[index])
            numberStackView.addArrangedSubview(numberLabels[index])
        }
        
        visualizationStackView.addArrangedSubview(numberStackView)
        visualizationStackView.addArrangedSubview(valueStackView)
        
        controlStackView.addArrangedSubview(initialValue0SliderView)
        controlStackView.addArrangedSubview(initialValue1SliderView)
        controlStackView.addArrangedSubview(recursiveFormulaPickerView)
        controlStackView.addArrangedSubview(keyButton)
        
        view.addSubview(visualizationStackView)
        view.addSubview(controlStackView)
        
        horizontalModeRequiredConstraints = [
            visualizationStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            visualizationStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
            visualizationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            visualizationStackView.trailingAnchor.constraint(equalTo: controlStackView.leadingAnchor, constant: -32),
            controlStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 64),
            controlStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -64),
            controlStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            controlStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            {let c = controlStackView.heightAnchor.constraint(equalToConstant: 256);c.priority = .defaultHigh;return c}(),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64)
        ]
        verticalModeRequiredConstraints = [
            visualizationStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            visualizationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            visualizationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            visualizationStackView.bottomAnchor.constraint(equalTo: controlStackView.topAnchor, constant: -32),
            controlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            controlStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            controlStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64)
        ]
        
        sequenceValues = Array(repeatElement(0, count: 10))
        
        initialValue0SliderView.setValue(4, animated: false)
        initialValue1SliderView.setValue(6, animated: false)
        recursiveFormulaPickerView.setValue(.regression, animated: false)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.frame.width > view.frame.height {
            NSLayoutConstraint.deactivate(verticalModeRequiredConstraints)
            NSLayoutConstraint.activate(horizontalModeRequiredConstraints)
        } else {
            NSLayoutConstraint.deactivate(horizontalModeRequiredConstraints)
            NSLayoutConstraint.activate(verticalModeRequiredConstraints)
        }
    }
    
    @objc private func keyButtonTapped() {
        if keyButton.titleLabel?.text == "Start" {
            isPlaying = true
            let span = precalculate()
            playNote(at: 0, min: span.0, max: span.1) {
                self.isPlaying = false
                self.keyButton.setTitle("Reset", for: .normal)
            }
        } else if keyButton.titleLabel?.text == "Reset" {
            reset()
        }
    }
    
    private func playNote(at index: Int, min: Int, max: Int, completion: (() -> ())?) {
        sequenceValues[index] = precalculatedValues[index]
        audioPlayer?.pause()
        if max - min == 0 {
            valueViews[index].setValue(0.5)
        } else {
            valueViews[index].setValue(Double(sequenceValues[index] - min) / Double(max - min))
        }
        var pitch: Int = 0
        pitch = abs(sequenceValues[index]) % SequenceViewController.highestPitch
        if pitch >= 0 && pitch <= SequenceViewController.highestPitch {
            audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: String(pitch), withExtension: "mp3")!)
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "-1", withExtension: "mp3")!)
        }
        audioPlayer?.play()
        if index < sequenceValues.count - 1 {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
                self.playNote(at: index + 1, min: min, max: max, completion: completion)
            }
        } else {
            completion?()
        }
    }
    
    private func reset() {
        guard !isPlaying else {return}
        for index in 0 ..< 10 {
            valueViews[index].reset()
            sequenceValues[index] = 0
        }
        self.keyButton.setTitle("Start", for: .normal)
    }
    
    @discardableResult
    private func precalculate() -> (Int, Int) {
        var preCalculateArray: [Int] = [initialValue0SliderView.currentValue, initialValue1SliderView.currentValue]
        for index in 2 ..< 10 {
            preCalculateArray.append(recursiveFormulaPickerView.currentValue.forwardFunction()(preCalculateArray[index - 2], preCalculateArray[index - 1]))
        }
        precalculatedValues = preCalculateArray
        return (preCalculateArray.min()!, preCalculateArray.max()!)
    }
    
}

extension SequenceViewController: SliderViewDelegate {
    public func valueChanged(_ sender: SliderView, to value: Int) {
        if keyButton.titleLabel?.text == "Reset" {
            reset()
        }
    }
}

extension SequenceViewController: PickerViewDelegate {
    public func valueChanged(_ sender: PickerView, to value: RecursiveFormula) {
        if keyButton.titleLabel?.text == "Reset" {
            reset()
        }
    }
}
