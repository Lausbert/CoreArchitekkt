// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

import XCTest
@testable import CoreArchitekkt

class VirtualArcNodeTest: VirtualTest {

    func testNoTransformation() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: []
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testUnfoldingOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 1)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, two.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 3)
    }

    func testUnfoldingOneAndTwo() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 3)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, five.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 2)
    }

    func testUnfoldingOneAndTwoAndThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 4)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)

    }

    func testUnfoldingAll() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
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
        ))

        XCTAssertEqual(virtualArcNodes.count, 4)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testUnfoldingTwo() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testHidingOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testHidingThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)
    }

    func testHidingSeven() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testHidingTwoAndNoUnfolding() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testFlattenOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenOneAndThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcNodes[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenOneThreeAndSeven() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .flattenNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcNodes[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenTwoAndNoUnfolding() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }
    
    func testRegexNoTransformation() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNodes(regex: "nomatch"),
                .hideNodes(regex: "nomatch"),
                .unfoldNodes(regex: "nomatch"),
                .flattenScopes(regex: "nomatch"),
                .hideScopes(regex: "nomatch"),
                .unfoldScopes(regex: "nomatch")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testRegexUnfoldingOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "one")
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 1)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, two.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 3)
    }

    func testRegexUnfoldingOneAndTwo() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "one|two")
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 3)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, five.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 2)
    }

    func testRegexUnfoldingOneAndTwoAndThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldScopes(regex: "one|two")
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 4)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)

    }

    func testRegexUnfoldingAll() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNodes(regex: ".")
            ]
        ))

        XCTAssertEqual(virtualArcNodes.count, 4)

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexUnfoldingTwo() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .unfoldNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testRegexHidingOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNodes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testRegexHidingThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNodes(regex: "three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)
    }

    func testRegexHidingSeven() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNodes(regex: "seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexHidingTwoAndNoUnfolding() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .hideNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    func testRegexFlattenOne() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenScopes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcNodes[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcNodes[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenOneAndThree() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNodes(regex: "one|three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcNodes[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenOneThreeAndSeven() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNodes(regex: "one|three|seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcNodes[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcNodes[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcNodes[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenTwoAndNoUnfolding() {
        let virtualArcNodes = sort(VirtualArcNode.createVirtualArcNodes(
            from: one,
            with: [
                .flattenNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcNodes, [])
    }

    private func sort(_ virtualArcNodes: [VirtualArcNode]) -> [VirtualArcNode] {
        return virtualArcNodes.sorted { (lhs, rhs) -> Bool in
            let lhsSourceIndex = allNodes.firstIndex(of: allNodes.first(where: { $0.id == lhs.sourceIdentifier })!)!
            let lhsDestinationIndex = allNodes.firstIndex(of: allNodes.first(where: { $0.id == lhs.destinationIdentifier })!)!
            let rhsSourceIndex = allNodes.firstIndex(of: allNodes.first(where: { $0.id == rhs.sourceIdentifier })!)!
            let rhsDestinationIndex = allNodes.firstIndex(of: allNodes.first(where: { $0.id == rhs.destinationIdentifier })!)!
            if lhsSourceIndex != rhsSourceIndex {
                return lhsSourceIndex < rhsSourceIndex
            } else {
                return lhsDestinationIndex < rhsDestinationIndex
            }
        }
    }

}
