// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

// This extension only takes effect, if the corresponding storyboard is named like the specific responder and contains an element with an id that is named like the specific responder. Otherwise createFromStoryboard() will crash.
extension NSResponder: StoryBoardLoadable {

}
