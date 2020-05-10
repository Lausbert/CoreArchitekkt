// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public protocol Coordinating: class {
    
    associatedtype Dependencies
    
    var dependencies: Dependencies? { get set }

    func open<U: NSWindowController, T: NSViewController & Coordinating>(windowController: U.Type, with coordinator: T.Type) -> (U, T)
    func close<U: NSViewController & Coordinating>(coordinator: U)
    
}

extension Coordinating where Self: NSResponder {
    
    public func open<U: NSWindowController, T: NSViewController & Coordinating>(windowController: U.Type, with coordinator: T.Type) -> (U, T) {
        let windowController = U.createFromStoryBoard()
        let coordinator = T.createFromStoryBoard()
        if let dependencyUpdater = self as? DependenciesUpdating {
            dependencyUpdater.updateDependenciesFor(child: coordinator)
        }
        windowController.contentViewController = coordinator
        windowController.didLoadContentViewController()
        windowController.nextResponder = self
        return (windowController, coordinator)
    }

    public func close<U: NSViewController & Coordinating>(coordinator: U) {
        if let dependencyUpdater = self as? DependenciesUpdating {
            dependencyUpdater.dependencyUpdaterDictionary.removeValue(forKey: coordinator)
        }
    }
    
}

extension NSWindowController {

    @objc open func didLoadContentViewController() {

    }

}
