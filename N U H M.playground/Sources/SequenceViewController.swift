import UIKit
import AVFoundation

public var forward: (Int, Int) -> Int = {$0 + $1}
public var barColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
public var backgroundColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
public var timeInterval: Double = 0.2
public var useModulus: Bool = true
public var initialValue_0: Int = 0
public var initialValue_1: Int = 1

public class SequenceViewController: UIViewController {
    
    private var backgroundView: UIView = UIView()
    private var valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var numberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.4156862745, blue: 1, alpha: 1)
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
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
    private var valueViews: [ValueView] = {
        var valueViews: [ValueView] = []
        for _ in 0 ..< SequenceViewController.visibleValues {
            let valueView = ValueView()
            valueView.translatesAutoresizingMaskIntoConstraints = false
            valueViews.append(valueView)
        }
        return valueViews
    }()
    
    public var sequenceValues: [Int] = [] {
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
    static var visibleValues: Int = 10
    private var playIndex: Int = 0
    private var highestPitch: Int = 34
    
    private var audioPlayer: AVAudioPlayer?
    
    public override func loadView() {
        super.loadView()
        
        self.view = backgroundView
        backgroundView.backgroundColor = backgroundColor
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(valueStackView)
        self.view.addSubview(numberStackView)
        self.view.addSubview(startButton)
        for index in 0 ..< SequenceViewController.visibleValues {
            valueStackView.addArrangedSubview(valueViews[index])
            numberStackView.addArrangedSubview(numberLabels[index])
        }
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 48),
            startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            startButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            numberStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 64),
            numberStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64),
            numberStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64),
            numberStackView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            valueStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 64),
            valueStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64),
            valueStackView.topAnchor.constraint(equalTo: numberStackView.bottomAnchor, constant: 8),
            valueStackView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -32)
        ])
        
        sequenceValues = Array(repeatElement(0, count: 10))
    }
    
    @objc private func startButtonTapped() {
        if startButton.titleLabel?.text == "Start" {
            startButton.isEnabled = false
            let span = getSpan()
            playNote(at: 0, min: span.0, max: span.1)
        } else {
            startButton.setTitle("Start", for: .normal)
            for index in 0 ..< 10 {
                valueViews[index].reset()
                sequenceValues[index] = 0
            }
        }
    }
    
    private func playNote(at index: Int, min: Int, max: Int) {
        calculateValue(at: index)
        audioPlayer?.pause()
        if max - min == 0 {
            valueViews[index].changeValue(to: 0.5)
        } else {
            valueViews[index].changeValue(to: Double(sequenceValues[index] - min) / Double(max - min))
        }
        var pitch: Int = 0
        if useModulus {
            pitch = abs(sequenceValues[index]) % highestPitch
        } else {
            pitch = abs(sequenceValues[index])
        }
        if pitch >= 0 && pitch <= highestPitch {
            audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: String(pitch), withExtension: "mp3")!)
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "-1", withExtension: "mp3")!)
        }
        audioPlayer?.play()
        guard index < sequenceValues.count - 1 else {
            startButton.setTitle("Reset", for: .normal)
            self.startButton.isEnabled = true
            return
        }
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
            self.playNote(at: index + 1, min: min, max: max)
        }
    }
    
    private func calculateValue(at index: Int) {
        if index == 0 {
            sequenceValues[0] = initialValue_0
        } else if index == 1 {
            sequenceValues[1] = initialValue_1
        } else {
            sequenceValues[index] = forward(sequenceValues[index - 2], sequenceValues[index - 1])
        }
    }
    
    private func getSpan() -> (Int, Int) {
        var preCalculateArray: [Int] = [initialValue_0, initialValue_1]
        for index in 2 ..< 10 {
            preCalculateArray.append(forward(preCalculateArray[index - 2], preCalculateArray[index - 1]))
        }
        return (preCalculateArray.min()!, preCalculateArray.max()!)
    }
    
}
