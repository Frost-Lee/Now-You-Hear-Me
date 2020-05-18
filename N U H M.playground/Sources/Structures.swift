import UIKit

public var customizedForward: (Int, Int) -> Int = {$0 + $1}

public var timeInterval: Double = 0.1
public let backgroundColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
public let secondaryBackgroundColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.15)
public let highLightColor: UIColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
public let interactiveColor: UIColor = #colorLiteral(red: 0.07058823529, green: 0.4156862745, blue: 1, alpha: 1)
public let disabledInteractiveColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.15)

public enum RecursiveFormula: Int, CaseIterable {
    case constant
    case linear
    case fibonacci
    case regression
    case random
    case customized
    
    func forwardFunction() -> ((Int, Int) -> Int) {
        switch self {
        case .constant:
            return {$1}
        case .linear:
            return {$1 + ($1 - $0)}
        case .fibonacci:
            return {$0 + $1}
        case .regression:
            return {$1 - $0 + 2}
        case .random:
            return {_, _ in Int.random(in: 0 ... 128)}
        case .customized:
            return customizedForward
        }
    }
    
    func name() -> String {
        switch self {
        case .constant:
            return "constant"
        case .linear:
            return "linear"
        case .fibonacci:
            return "fibonacci"
        case .regression:
            return "regression"
        case .random:
            return "random"
        case .customized:
            return "customized"
        }
    }
}
