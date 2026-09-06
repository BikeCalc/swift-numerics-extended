// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Comparable Tests")
internal struct IntComparableTests {
    private static let comparisonArguments: Array<(Int, Int, Bool, Bool, Bool, Bool)> = [
        (1, 1, false, true, false, true),
        (-1, -1, false, true, false, true),
        (2, 3, true, true, false, false),
        (3, 2, false, false, true, true),
        (-2, 3, true, true, false, false),
        (-3, -2, true, true, false, false)
    ]

    private static let rangeArguments: Array<(Int, Int, Int)> = [
        (1, 2, 4),
        (2, 2, 4),
        (3, 2, 4),
        (4, 2, 4),
        (5, 2, 4),
        (-5, -4, -2),
        (-4, -4, -2),
        (-3, -4, -2),
        (-2, -4, -2),
        (-1, -4, -2)
    ]

    @Test(
        "Is less than",
        arguments: Self.comparisonArguments
    )
    internal func isLessThan(
        lhs: Int,
        rhs: Int,
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
        lhs: Int,
        rhs: Int,
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
        lhs: Int,
        rhs: Int,
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
        lhs: Int,
        rhs: Int,
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
        value: Int,
        lowerBound: Int,
        upperBound: Int
    ) {
        let range: ClosedRange<Int> = lowerBound ... upperBound

        #expect(value.isWithin(range) == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Int,
        lowerBound: Int,
        upperBound: Int
    ) {
        let valueIsWithinBounds: Bool = value.isWithin(lowerBound, upperBound) == true

        #expect(valueIsWithinBounds == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Int,
        lowerBound: Int,
        upperBound: Int
    ) {
        let valueIsBetweenBounds: Bool = value.isBetween(lowerBound, upperBound) == true

        #expect(valueIsBetweenBounds == (value > lowerBound && value < upperBound))
    }
}
