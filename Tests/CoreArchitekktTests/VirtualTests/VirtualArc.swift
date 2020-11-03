// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

import XCTest
@testable import CoreArchitekkt

class VirtualArcTest: VirtualTest {

    func testNoTransformation() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: []
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testUnfoldingOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNode(id: one.id)
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 1)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, two.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 3)
    }

    func testUnfoldingOneAndTwo() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 3)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, five.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 2)
    }

    func testUnfoldingOneAndTwoAndThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNode(id: one.id),
                .unfoldNode(id: two.id),
                .unfoldNode(id: three.id)
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 4)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)

    }

    func testUnfoldingAll() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
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

        XCTAssertEqual(virtualArcs.count, 4)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testUnfoldingTwo() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testHidingOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testHidingThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)
    }

    func testHidingSeven() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNode(id: seven.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testHidingTwoAndNoUnfolding() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testFlattenOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenOneAndThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNode(id: one.id),
                .flattenNode(id: three.id),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcs[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenOneThreeAndSeven() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
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

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcs[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testFlattenTwoAndNoUnfolding() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNode(id: two.id)
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }
    
    func testRegexNoTransformation() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
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

        XCTAssertEqual(virtualArcs, [])
    }

    func testRegexUnfoldingOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNodes(regex: "one")
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 1)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, two.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 3)
    }

    func testRegexUnfoldingOneAndTwo() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNodes(regex: "one|two")
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 3)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, three.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, five.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 2)
    }

    func testRegexUnfoldingOneAndTwoAndThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldScopes(regex: "one|two")
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 4)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)

    }

    func testRegexUnfoldingAll() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNodes(regex: ".")
            ]
        ))

        XCTAssertEqual(virtualArcs.count, 4)

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexUnfoldingTwo() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .unfoldNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testRegexHidingOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNodes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testRegexHidingThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNodes(regex: "three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)
    }

    func testRegexHidingSeven() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNodes(regex: "seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexHidingTwoAndNoUnfolding() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .hideNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    func testRegexFlattenOne() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenScopes(regex: "one"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcThree = virtualArcs[2]
        XCTAssertEqual(arcThree.sourceIdentifier, five.id)
        XCTAssertEqual(arcThree.destinationIdentifier, three.id)
        XCTAssertEqual(arcThree.weight, 1)

        let arcFour = virtualArcs[3]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenOneAndThree() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNodes(regex: "one|three"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcs[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenOneThreeAndSeven() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNodes(regex: "one|three|seven"),
                .unfoldScope(scope: "one"),
                .unfoldScope(scope: "two"),
                .unfoldScope(scope: "three")
            ]
        ))

        let arcOne = virtualArcs[0]
        XCTAssertEqual(arcOne.sourceIdentifier, four.id)
        XCTAssertEqual(arcOne.destinationIdentifier, five.id)
        XCTAssertEqual(arcOne.weight, 1)

        let arcTwo = virtualArcs[1]
        XCTAssertEqual(arcTwo.sourceIdentifier, four.id)
        XCTAssertEqual(arcTwo.destinationIdentifier, six.id)
        XCTAssertEqual(arcTwo.weight, 1)

        let arcFour = virtualArcs[2]
        XCTAssertEqual(arcFour.sourceIdentifier, five.id)
        XCTAssertEqual(arcFour.destinationIdentifier, six.id)
        XCTAssertEqual(arcFour.weight, 1)
    }

    func testRegexFlattenTwoAndNoUnfolding() {
        let virtualArcs = sort(VirtualArc.createVirtualArcs(
            from: one,
            with: [
                .flattenNodes(regex: "two")
            ]
        ))

        XCTAssertEqual(virtualArcs, [])
    }

    private func sort(_ virtualArcs: [VirtualArc]) -> [VirtualArc] {
        return virtualArcs.sorted { (lhs, rhs) -> Bool in
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
