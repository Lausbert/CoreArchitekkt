//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Cocoa

open class Coordinator<Dependencies>: NSViewController {

    // MARK: - Internal -

    public var dependencies: Dependencies? {
        didSet {
            dependencyUpdaterDictionary.values.forEach { $0() }
        }
    }

    public func open<U: NSWindowController, T: Coordinator<Dependency>, Dependency>(windowController: U.Type, with coordinator: T.Type) -> (U, T) {
        let windowController = U.createFromStoryBoard()
        let coordinator = T.createFromStoryBoard()
        updateDependenciesFor(child: coordinator)
        windowController.contentViewController = coordinator
        windowController.didLoadContentViewController()
        windowController.nextResponder = self
        return (windowController, coordinator)
    }

    public func close(coordinator: Coordinator) {
        dependencyUpdaterDictionary.removeValue(forKey: coordinator)
    }

    public func transition<T: Coordinator<Dependency>, Dependency>(toCoordinator to: T, in containerView: NSView, options: NSViewController.TransitionOptions = [.crossfade], completionHandler: (() -> Void)? = nil ) {
        updateDependenciesFor(child: to)
        transition(toViewController: to, in: containerView, options: options, completionHandler: completionHandler)
    }

    public func transition(toViewController to: NSViewController, in containerView: NSView, options: NSViewController.TransitionOptions = [.crossfade], completionHandler: (() -> Void)? = nil ) {
        guard let from = childrenDictionary[containerView] else {
            embed(viewController: to, in: containerView)
            return
        }
        addChild(to)
        to.nextResponder = self
        transition(from: from, to: to, options: options, completionHandler: completionHandler)
        from.removeFromParent()
        dependencyUpdaterDictionary.removeValue(forKey: from)
        childrenDictionary[containerView] = to
    }

    // MARK: - Private -

    private var childrenDictionary: [NSView: NSViewController] = [:]
    private var dependencyUpdaterDictionary: [NSViewController: () -> Void] = [:]

    private func updateDependenciesFor<T: Coordinator<Dependency>, Dependency>(child: T) {
        let dependencyUpdater = { [unowned self, weak child] in
            guard let child = child else { return }
            if let dependencies = self.dependencies as? Dependency? {
                child.dependencies = dependencies
            } else {
                assertionFailure("Parent coordinator \(self) does not hold child \(child) dependencies.")
            }
        }
        dependencyUpdater()
        dependencyUpdaterDictionary[child] = dependencyUpdater
    }

    private func embed(viewController: NSViewController, in containerView: NSView) {
        addChild(viewController)
        viewController.nextResponder = self
        containerView.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.width, .height]
        viewController.view.frame = containerView.bounds
        childrenDictionary[containerView] = viewController
    }

}

public extension NSWindowController {

    @objc func didLoadContentViewController() {

    }

}
