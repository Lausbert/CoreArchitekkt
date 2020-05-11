// Copyright © 2020 Stephan Lerner. All rights reserved.

import Cocoa

open class TabViewCoordinator<Dependencies>: NSTabViewController, Coordinating, DependenciesUpdating {

    // MARK: - Public -

    public var dependencies: Dependencies? {
        didSet {
            updateChildrenDependencies()
        }
    }

    open func add<T: NSViewController & Coordinating>(coordinator: T) {
        updateDependenciesFor(child: coordinator)
        let tabViewItem = NSTabViewItem(viewController: coordinator)
        addTabViewItem(tabViewItem)
    }

    open override func removeTabViewItem(_ tabViewItem: NSTabViewItem) {
        super.removeTabViewItem(tabViewItem)
        if let viewController = tabViewItem.viewController {
            dependencyUpdaterDictionary.removeValue(forKey: viewController)
        }
    }

    // MARK: - Internal -

    var dependencyUpdaterDictionary: [NSResponder : () -> Void] = [:]

}
