// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

protocol DependenciesUpdating: class {

    var dependencyUpdaterDictionary: [NSViewController: () -> Void] { get set }

    func updateDependenciesFor<T: NSViewController & Coordinating>(child: T)

}

extension DependenciesUpdating where Self: Coordinating {

    func updateDependenciesFor<T: NSViewController & Coordinating>(child: T) {
        let dependencyUpdater = { [weak self] in
            guard let self = self else { return }
            if let dependencies = self.dependencies as? T.Dependencies? {
                child.dependencies = dependencies
            } else {
                assertionFailure("Parent coordinator \(self) does not hold child \(child) dependencies.")
            }
        }
        dependencyUpdater()
        dependencyUpdaterDictionary[child] = dependencyUpdater
    }

}
