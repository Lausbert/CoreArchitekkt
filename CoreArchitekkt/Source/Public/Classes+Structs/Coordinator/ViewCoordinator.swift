//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Cocoa

open class ViewCoordinator<Dependencies>: NSViewController, Coordinating, DependenciesUpdating {

    // MARK: - Public -

    public var dependencies: Dependencies? {
        didSet {
            updateChildrenDependencies()
        }
    }

    open func transition<T: NSViewController & Coordinating>(toCoordinator to: T, in containerView: NSView, options: NSViewController.TransitionOptions = [.crossfade], completionHandler: (() -> Void)? = nil ) {
        updateDependenciesFor(child: to)
        transition(toViewController: to, in: containerView, options: options, completionHandler: completionHandler)
    }

    open func transition(toViewController to: NSViewController, in containerView: NSView, options: NSViewController.TransitionOptions = [.crossfade], completionHandler: (() -> Void)? = nil ) {
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

    // MARK: - Internal -

    var dependencyUpdaterDictionary: [NSResponder: () -> Void] = [:]

    // MARK: - Private -

    private var childrenDictionary: [NSView: NSViewController] = [:]

    private func embed(viewController: NSViewController, in containerView: NSView) {
        addChild(viewController)
        viewController.nextResponder = self
        containerView.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.width, .height]
        viewController.view.frame = containerView.bounds
        childrenDictionary[containerView] = viewController
    }

}
