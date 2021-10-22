// Copyright © 2020 Stephan Lerner. All rights reserved.

import XCTest
@testable import CoreArchitekkt

class VirtualShapeNodeTest: VirtualTest {

    func testNoTransformation() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: []
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testUnfoldingOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 1.0)
        XCTAssertEqual(two.children.count, 0)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 1.0)
        XCTAssertEqual(three.children.count, 0)
    }

    func testUnfoldingOneAndTwo() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 6.000000000000001)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.82842712474619038)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 1.0)
        XCTAssertEqual(three.children.count, 0)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)
    }

    func testUnfoldingOneAndTwoAndThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 8.0)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testUnfoldingAll() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id),
                .unfoldNode(id: four.id),
                .unfoldNode(id: five.id),
                .unfoldNode(id: six.id),
                .unfoldNode(id: seven.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 8.0)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testUnfoldingTwo() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [.unfoldNode(id: two.id)]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testHidingOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 0)
    }

    func testHidingThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 5.656854249492381)
        XCTAssertEqual(one.children.count, 1)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)
    }

    func testHidingSeven() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 6.92820323027551)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.0)
        XCTAssertEqual(three.children.count, 1)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)
    }

    func testHidingTwoAndNoUnfolding() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNode(id: two.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testFlattenOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 2)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = virtualShapeNodes[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testFlattenOneAndThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 3)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualShapeNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = virtualShapeNodes[2]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testFlattenOneThreeAndSeven() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .flattenNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 2)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualShapeNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)
    }

    func testFlattenTwoAndNoUnfolding() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNode(id: two.id)
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }
    
    func testRegexNoTransformation() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNodes(regex: "nomatch"),
                .hideNodes(regex: "nomatch"),
                .unfoldNodes(regex: "nomatch"),
                .flattenScopes(regex: "nomatch"),
                .hideScopes(regex: "nomatch"),
                .unfoldScopes(regex: "nomatch")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testRegexUnfoldingOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "one")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 1.0)
        XCTAssertEqual(two.children.count, 0)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 1.0)
        XCTAssertEqual(three.children.count, 0)
    }

    func testRegexUnfoldingOneAndTwo() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "one|two")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 6.000000000000001)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.82842712474619038)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 1.0)
        XCTAssertEqual(three.children.count, 0)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)
    }

    func testRegexUnfoldingOneAndTwoAndThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldScopes(regex: "one|two")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 8.0)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testRegexUnfoldingAll() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNodes(regex: ".")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 8.0)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testRegexUnfoldingTwo() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "two")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testRegexHidingOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNodes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 0)
    }

    func testRegexHidingThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNodes(regex: "three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 5.656854249492381)
        XCTAssertEqual(one.children.count, 1)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)
    }

    func testRegexHidingSeven() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNodes(regex: "seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 6.92820323027551)
        XCTAssertEqual(one.children.count, 2)

        let two = one.children[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = one.children[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.0)
        XCTAssertEqual(three.children.count, 1)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)
    }

    func testRegexHidingTwoAndNoUnfolding() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .hideNodes(regex: "two")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }

    func testRegexFlattenOne() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenScopes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 2)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let three = virtualShapeNodes[1]
        XCTAssertEqual(three.scope, "two")
        XCTAssertEqual(three.name, "three")
        XCTAssertEqual(three.radius, 2.8284271247461903)
        XCTAssertEqual(three.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = three.children[0]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = three.children[1]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testRegexFlattenOneAndThree() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNodes(regex: "one|three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 3)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualShapeNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)

        let seven = virtualShapeNodes[2]
        XCTAssertEqual(seven.scope, "three")
        XCTAssertEqual(seven.name, "seven")
        XCTAssertEqual(seven.radius, 1.0)
        XCTAssertEqual(seven.children.count, 0)
    }

    func testRegexFlattenOneThreeAndSeven() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNodes(regex: "one|three|seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 2)

        let two = virtualShapeNodes[0]
        XCTAssertEqual(two.scope, "two")
        XCTAssertEqual(two.name, "two")
        XCTAssertEqual(two.radius, 2.8284271247461903)
        XCTAssertEqual(two.children.count, 2)

        let four = two.children[0]
        XCTAssertEqual(four.scope, "three")
        XCTAssertEqual(four.name, "four")
        XCTAssertEqual(four.radius, 1.0)
        XCTAssertEqual(four.children.count, 0)

        let five = two.children[1]
        XCTAssertEqual(five.scope, "three")
        XCTAssertEqual(five.name, "five")
        XCTAssertEqual(five.radius, 1.0)
        XCTAssertEqual(five.children.count, 0)

        let six = virtualShapeNodes[1]
        XCTAssertEqual(six.scope, "three")
        XCTAssertEqual(six.name, "six")
        XCTAssertEqual(six.radius, 1.0)
        XCTAssertEqual(six.children.count, 0)
    }

    func testRegexFlattenTwoAndNoUnfolding() {
        let virtualShapeNodes = VirtualShapeNode.createVirtualShapeNodes(
            from: one,
            with: [
                .flattenNodes(regex: "two")
            ]
        )

        XCTAssertEqual(virtualShapeNodes.count, 1)

        let one = virtualShapeNodes[0]
        XCTAssertEqual(one.scope, "one")
        XCTAssertEqual(one.name, "one")
        XCTAssertEqual(one.radius, 1.0)
        XCTAssertEqual(one.children.count, 0)
    }


}
