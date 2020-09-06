// Copyright © 2020 Stephan Lerner. All rights reserved.

import XCTest
import CoreArchitekkt
@testable import SKArchitekkt

class VirtualNodeTest: VirtualTest {

    let defaultSettings = VirtualNode.Settings(
        colorDictionary: [:],
        defaultColor: .black,
        baseRadius: 128,
        areaMultiplier: 1.5
    )

    func testNoTransformation() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 128)
        XCTAssertEqual(one.children.count, 0)
    }

    func testUnfoldingOne() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 221.70250336881628)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 128)
        XCTAssertEqual(two.children.count, 0)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 128)
        XCTAssertEqual(three.children.count, 0)
    }

    func testUnfoldingOneAndTwo() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 313.53468707624677)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 128)
        XCTAssertEqual(three.children.count, 0)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)
    }

    func testUnfoldingOneAndTwoAndThree() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 383.99999999999994)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 221.70250336881628)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.color, .black)
        XCTAssertEqual(seven.radius, 128)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testUnfoldingAll() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id),
                .unfoldNode(id: four.id),
                .unfoldNode(id: five.id),
                .unfoldNode(id: six.id),
                .unfoldNode(id: seven.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 383.99999999999994)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 221.70250336881628)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.color, .black)
        XCTAssertEqual(seven.radius, 128)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testUnfoldingTwo() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [.unfoldNode(id: two.id)],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 128)
        XCTAssertEqual(one.children.count, 0)
    }

    func testHidingOne() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .hideNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 0)
    }

    func testHidingThree() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .hideNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 271.5290039756342)
        XCTAssertEqual(one.children.count, 1)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)
    }

    func testHidingSeven() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .hideNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 332.5537550532244)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 156.76734353812338)
        XCTAssertEqual(three.children.count, 1)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)
    }

    func testHidingTwoAndNoUnfolding() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .hideNode(id: two.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 128)
        XCTAssertEqual(one.children.count, 0)
    }

    func testFlattenOne() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 2)

        let two = virtualNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let three = virtualNodes[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.color, .black)
        XCTAssertEqual(three.radius, 221.70250336881628)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.color, .black)
        XCTAssertEqual(seven.radius, 128)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testFlattenOneAndThree() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 3)

        let two = virtualNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)

        let seven = virtualNodes[2]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.color, .black)
        XCTAssertEqual(seven.radius, 128)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testFlattenOneThreeAndSeven() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .flattenNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 2)

        let two = virtualNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.color, .black)
        XCTAssertEqual(two.radius, 221.70250336881628)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.color, .black)
        XCTAssertEqual(four.radius, 128)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.color, .black)
        XCTAssertEqual(five.radius, 128)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.color, .black)
        XCTAssertEqual(six.radius, 128)
        XCTAssertEqual(six.children.count, 0)
    }

    func testFlattenTwoAndNoUnfolding() {
        let virtualNodes = VirtualNode.createVirtualNodes(
            from: one,
            with: [
                .flattenNode(id: two.id)
            ],
            and: defaultSettings
        )

        XCTAssertEqual(virtualNodes.count, 1)

        let one = virtualNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.color, .black)
        XCTAssertEqual(one.radius, 128)
        XCTAssertEqual(one.children.count, 0)
    }

}
