// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Comparable Tests")
internal struct UInt4ComparableTests {
    private static let comparisonArguments: Array<(UInt4, UInt4, Bool, Bool, Bool, Bool)> = [
        (1, 1, false, true, false, true),
        (2, 3, true, true, false, false),
        (3, 2, false, false, true, true)
    ]

    private static let rangeArguments: Array<(UInt4, UInt4, UInt4)> = [
        (1, 2, 4),
        (2, 2, 4),
        (3, 2, 4),
        (4, 2, 4),
        (5, 2, 4)
    ]

    @Test(
        "Is less than",
        arguments: Self.comparisonArguments
    )
    internal func isLessThan(
        lhs: UInt4,
        rhs: UInt4,
        isLess: Bool,
        isLessThanOrEqual _: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect(lhs.isLess(than: rhs) == isLess)
    }

    @Test(
        "Is less than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isLessThanOrEqualTo(
        lhs: UInt4,
        rhs: UInt4,
        isLess _: Bool,
        isLessThanOrEqual: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
    }

    @Test(
        "Is greater than",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThan(
        lhs: UInt4,
        rhs: UInt4,
        isLess _: Bool,
        isLessThanOrEqual _: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs > rhs) == isGreater)
        #expect(lhs.isGreater(than: rhs) == isGreater)
    }

    @Test(
        "Is greater than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThanOrEqualTo(
        lhs: UInt4,
        rhs: UInt4,
        isLess _: Bool,
        isLessThanOrEqual _: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }

    @Test(
        "Is within closed range",
        arguments: Self.rangeArguments
    )
    internal func isWithinClosedRange(
        value: UInt4,
        lowerBound: UInt4,
        upperBound: UInt4
    ) {
        let range: ClosedRange<UInt4> = lowerBound ... upperBound
        #expect(value.isWithin(range) == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: UInt4,
        lowerBound: UInt4,
        upperBound: UInt4
    ) {
        let isWithin: Bool = value.isWithin(
            lowerBound,
            through: upperBound
        ) == true
        #expect(isWithin == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: UInt4,
        lowerBound: UInt4,
        upperBound: UInt4
    ) {
        let isBetween: Bool = value.isBetween(
            lowerBound,
            and: upperBound
        ) == true
        #expect(isBetween == (value > lowerBound && value < upperBound))
    }
}
