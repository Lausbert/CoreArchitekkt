// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit

open class WindowCoordinator<Dependencies>: NSResponder, Coordinating, DependenciesUpdating {

    // MARK: - Public -

    public var dependencies: Dependencies? {
        didSet {
            updateChildrenDependencies()
        }
    }

    open func open<U: NSWindowController & StoryBoardLoadable, T: NSViewController & Coordinating & StoryBoardLoadable>(
        windowController: U.Type,
        with coordinator: T.Type,
        inheritDependencies: Bool = true
    ) -> (U, T) {
        let windowController = U.createFromStoryBoard()
        let coordinator = T.createFromStoryBoard()
        if inheritDependencies {
            updateDependenciesFor(child: coordinator)
        }
        windowController.contentViewController = coordinator
        windowController.didLoadContentViewController()
        windowController.nextResponder = self
        windowController.showWindow(self)
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
