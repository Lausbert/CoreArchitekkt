// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation
import Combine

public extension ObservableObject {
    
    var objectDidChange: Publishers.ReceiveOn<Self.ObjectWillChangePublisher, DispatchQueue> {
        objectWillChange.receive(on: DispatchQueue.main)
    }
    
}
