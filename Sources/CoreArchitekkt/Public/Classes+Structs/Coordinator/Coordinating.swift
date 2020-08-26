// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public protocol Coordinating: class {

    associatedtype Dependencies

    var dependencies: Dependencies? { get set }

}
