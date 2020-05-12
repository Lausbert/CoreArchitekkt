// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

open class WindowCoordinator<Dependencies>: NSResponder, Coordinating, DependenciesUpdating {

    // MARK: - Public -

    public var dependencies: Dependencies? {
        didSet {
            updateChildrenDependencies()
        }
    }

    open func open<U: NSWindowController, T: NSViewController & Coordinating>(
        windowController: U.Type,
        with coordinator: T.Type,
        inheritDependencies: Bool = true,
        preferredContentSize: CGSize? = nil
    ) -> (U, T) {
        let windowController = U.createFromStoryBoard()
        let coordinator = T.createFromStoryBoard()
        if inheritDependencies {
            updateDependenciesFor(child: coordinator)
        }
        if let preferredContentSize = preferredContentSize {
            coordinator.preferredContentSize = preferredContentSize
        }
        windowController.contentViewController = coordinator
        windowController.didLoadContentViewController()
        windowController.nextResponder = self
        windowController.showWindow(self)
        windowController.window?.orderFrontRegardless()
        return (windowController, coordinator)
    }

    open func close<U: NSViewController & Coordinating>(coordinator: U) {
        dependencyUpdaterDictionary.removeValue(forKey: coordinator)
    }

    // MARK: - Internal -

    var dependencyUpdaterDictionary: [NSResponder : () -> Void] = [:]

}

extension NSWindowController {

    @objc open func didLoadContentViewController() {

    }

}
