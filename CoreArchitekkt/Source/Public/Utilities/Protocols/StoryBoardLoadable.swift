//  Copyright © 2019 Stephan Lerner. All rights reserved.

import AppKit

public protocol StoryBoardLoadable {
    
    static func createFromStoryBoard() -> Self
    
}

public extension StoryBoardLoadable where Self: NSViewController{
    
    static func createFromStoryBoard() -> Self {
        let name = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        let storyBoard = NSStoryboard.init(name: name, bundle: bundle)
        let viewController = storyBoard.instantiateController(withIdentifier: name) as? Self ?? Self()
        return viewController
    }
    
}
