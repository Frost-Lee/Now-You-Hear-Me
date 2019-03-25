import UIKit
import AVFoundation

public var forward: (Int, Int) -> Int = {$0 + $1}
public var barColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
public var backgroundColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
public var timeInterval: Double = 0.2
public var useModulus: Bool = true
public var initialValue_0: Int = 0
public var initialValue_1: Int = 1

public func delay(for seconds: Double, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
}

public class SequenceViewController: UIViewController {
    
    public var backgroundView: UIView = UIView()
    public var valueViews: [ValueView] = []
    public var valueStackView: UIStackView = UIStackView()
    public var numberLabels: [UILabel] = []
    public var numberStackView: UIStackView = UIStackView()
    public var startButton: UIButton = UIButton()
    
    public var audioPlayer: AVAudioPlayer?
    
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
    public var playIndex: Int = 0
    public var highestPitch: Int = 34
    
    public override func loadView() {
        super.loadView()
        
        self.view = backgroundView
        backgroundView.backgroundColor = backgroundColor
        
        valueStackView.spacing = 20
        valueStackView.distribution = .fillEqually
        valueStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(valueStackView)
        
        numberStackView.spacing = 0
        numberStackView.distribution = .fillEqually
        numberStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(numberStackView)
        
        for _ in 0 ..< 10 {
            let valueView = ValueView()
            valueViews.append(valueView)
            valueView.translatesAutoresizingMaskIntoConstraints = false
            valueStackView.addArrangedSubview(valueView)
            let numberLabel = UILabel()
            numberLabel.textColor = .white
            numberLabel.textAlignment = .center
            numberLabel.font = UIFont.boldSystemFont(ofSize: 15)
            numberLabels.append(numberLabel)
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            numberStackView.addArrangedSubview(numberLabel)
        }
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.4156862745, blue: 1, alpha: 1)
        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        NSLayoutConstraint.activate([
            valueStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 64),
            valueStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64),
            valueStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 160),
            valueStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -128)
        ])
        
        NSLayoutConstraint.activate([
            numberStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 64),
            numberStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64),
            numberStackView.bottomAnchor.constraint(equalTo: valueStackView.topAnchor, constant: -16),
            numberStackView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            startButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
        ])
        
        sequenceValues = Array(repeatElement(0, count: 10))
        
    }
    
    @objc public func startButtonTapped() {
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
    
    public func playNote(at index: Int, min: Int, max: Int) {
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
        delay(for: timeInterval) {
            self.playNote(at: index + 1, min: min, max: max)
        }
    }
    
    public func calculateValue(at index: Int) {
        if index == 0 {
            sequenceValues[0] = initialValue_0
        } else if index == 1 {
            sequenceValues[1] = initialValue_1
        } else {
            sequenceValues[index] = forward(sequenceValues[index - 2], sequenceValues[index - 1])
        }
    }
    
    public func getSpan() -> (Int, Int) {
        var preCalculateArray: [Int] = [initialValue_0, initialValue_1]
        for index in 2 ..< 10 {
            preCalculateArray.append(forward(preCalculateArray[index - 2], preCalculateArray[index - 1]))
        }
        return (preCalculateArray.min()!, preCalculateArray.max()!)
    }
    
}
