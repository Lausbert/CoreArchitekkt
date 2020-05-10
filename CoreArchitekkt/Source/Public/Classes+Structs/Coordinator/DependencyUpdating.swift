// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

protocol DependenciesUpdating: class {

    var dependencyUpdaterDictionary: [NSResponder: () -> Void] { get set }

    func updateDependenciesFor<T: NSResponder & Coordinating>(child: T)

    func updateChildrenDependencies()

}

internal extension DependenciesUpdating where Self: Coordinating {

    func updateDependenciesFor<T: NSResponder & Coordinating>(child: T) {
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

    func updateChildrenDependencies() {
        dependencyUpdaterDictionary.values.forEach { $0() }
    }

}
