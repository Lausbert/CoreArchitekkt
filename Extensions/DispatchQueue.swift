//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

extension DispatchQueue {

    func asyncClosure<T>(_ closure: ((T) -> Void)?) -> (T) -> Void {
        return {t in self.async {closure?(t)}}
    }

}
