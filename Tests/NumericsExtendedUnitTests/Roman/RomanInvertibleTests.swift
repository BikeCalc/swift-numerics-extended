// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Invertible Tests")
internal struct RomanInvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (1, 1),
            (2, nil)
        ] as Array<(Roman, Roman.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: Roman,
        expected: Roman.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Roman, Bool)>
    )
    internal func isInvertible(
        dividend: Roman,
        expected: Bool
    ) {
        let result: Bool = dividend.isInvertible
        #expect(result == expected)
    }
}

// MARK: - Positive One

extension RomanInvertibleTests {
    @Test(
        "Positive one invertibility follows unsigned integer rules",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Roman, Bool)>
    )
    internal func positiveOneInvertibilityFollowsUnsignedIntegerRules(
        dividend: Roman,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }
}

// MARK: - Positive Zero

extension RomanInvertibleTests {
    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Roman.zero.isInvertible == false)
    }
}
