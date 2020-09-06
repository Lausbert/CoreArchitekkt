// Copyright © 2020 Stephan Lerner. All rights reserved.

import XCTest
import CoreArchitekkt
@testable import SKArchitekkt

class VirtualTest: XCTestCase {

    var one: Node!
    var two: Node!
    var three: Node!
    var four: Node!
    var five: Node!
    var six: Node!
    var seven: Node!
    var allNodes: [Node]!

    override func setUpWithError() throws {
        one = Node(scope: "one", name: "one")
        two = Node(scope: "two", name: "two")
        three = Node(scope: "two", name: "three")
        four = Node(scope: "three", name: "four")
        five = Node(scope: "three", name: "five")
        six = Node(scope: "three", name: "six")
        seven = Node(scope: "three", name: "seven")

        one.add(child: two)
        one.add(child: three)
        two.add(child: four)
        two.add(child: five)
        three.add(child: six)
        three.add(child: seven)

        //          one
        //         /   \
        //      two     three
        //     /   |    |    \
        //  four five  six  seven

        four.add(arc: five.id)
        four.add(arc: six.id)
        five.add(arc: three.id)
        five.add(arc: six.id)

        allNodes = [one, two, three, four, five, six, seven]
    }

    override func tearDownWithError() throws {
        one = nil
        two = nil
        three = nil
        four = nil
        five = nil
        six = nil
        seven = nil
    }

}
