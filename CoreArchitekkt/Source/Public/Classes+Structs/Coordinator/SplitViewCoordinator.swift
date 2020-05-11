// Copyright © 2020 Stephan Lerner. All rights reserved.

import Cocoa

open class SplitViewCoordinator<Dependencies>: NSSplitViewController, Coordinating, DependenciesUpdating {

    // MARK: - Public -

    public var dependencies: Dependencies? {
        didSet {
            updateChildrenDependencies()
        }
    }

    open func add<T: NSViewController & Coordinating>(coordinator: T, canCollapse: Bool = false) {
        updateDependenciesFor(child: coordinator)
        let splitViewItem = NSSplitViewItem(viewController: coordinator)
        splitViewItem.canCollapse = canCollapse
        addSplitViewItem(splitViewItem)
    }

    open override func removeSplitViewItem(_ splitViewItem: NSSplitViewItem) {
        super.removeSplitViewItem(splitViewItem)
        dependencyUpdaterDictionary.removeValue(forKey: splitViewItem.viewController)
    }

    // MARK: - Internal -

    var dependencyUpdaterDictionary: [NSResponder : () -> Void] = [:]

}
