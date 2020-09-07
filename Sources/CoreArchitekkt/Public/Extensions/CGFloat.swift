//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
public func ^^ (radix: CGFloat, power: CGFloat) -> CGFloat {
    return CGFloat(pow(Double(radix), Double(power)))
}
