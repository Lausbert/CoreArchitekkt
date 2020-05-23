//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public protocol NibLoadable {

    static func createFromNib() -> Self

}

extension NibLoadable where Self: NSView {

    public static func createFromNib() -> Self {
        let name = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        var topLevelArray: NSArray?
        bundle.loadNibNamed(NSNib.Name(name), owner: self, topLevelObjects: &topLevelArray)
        let views = [Any](topLevelArray!).filter { $0 is Self }
        return views.last as! Self
    }

}

extension NibLoadable where Self: NSCollectionViewItem {

    public static func createFromNib() -> Self {
        let name = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        var topLevelArray: NSArray?
        bundle.loadNibNamed(NSNib.Name(name), owner: self, topLevelObjects: &topLevelArray)
        let views = [Any](topLevelArray!).filter { $0 is Self }
        return views.last as! Self
    }

}
