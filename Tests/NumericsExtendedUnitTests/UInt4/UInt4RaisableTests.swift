// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Raisable Tests")
internal struct UInt4RaisableTests {
    internal init() {}

    private static let exponentiationArguments: [(UInt4, UInt4.Exponent, UInt4)] = [
        (2, 2, 4),
        (2, 3, 8),
        (0, UInt4.max, 0),
        (1, UInt4.max, 1)
    ]

    private static let squaringArguments: [(UInt4, UInt4)] = [
        (2, 4),
        (3, 9)
    ]

    private static let cubingArguments: [(UInt4, UInt4)] = [
        (2, 8)
    ]

    @Test(
        "Is power of",
        arguments: [
            (4, 2, true),
            (6, 2, false),
            (8, 2, true),
            (9, 2, false)
        ] as Array<(UInt4, UInt4, Bool)>
    )
    internal func isPowerOf(
        value: UInt4,
        other: UInt4,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: other)
        #expect(result == expected)
    }

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: UInt4,
        exponent: UInt4.Exponent,
        power: UInt4
    ) {
        let result: UInt4 = base ** exponent
        #expect(result == power)
    }

    @Test(
        "Exponentiation equal succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualSucceeds(
        base: UInt4,
        exponent: UInt4.Exponent,
        power: UInt4
    ) {
        var result: UInt4 = base
        result **= exponent
        #expect(result == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: UInt4,
        exponent: UInt4.Exponent,
        power: UInt4
    ) throws {
        let result: UInt4 = try base.raising(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: UInt4,
        exponent: UInt4.Exponent,
        power: UInt4
    ) throws {
        var result: UInt4 = base
        try result.raise(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: UInt4,
        power: UInt4
    ) {
        let result: UInt4 = base.squared()
        #expect(result == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: UInt4,
        power: UInt4
    ) {
        var result: UInt4 = base
        result.square()
        #expect(result == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: UInt4,
        power: UInt4
    ) {
        let result: UInt4 = base.cubed()
        #expect(result == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: UInt4,
        power: UInt4
    ) {
        var result: UInt4 = base
        result.cube()
        #expect(result == power)
    }
}

extension UInt4RaisableTests {
    @Test(
        "Exponentiation is not commutative",
        arguments: [
            (2, 3),
            (3, 2)
        ] as Array<(UInt4, UInt4.Exponent)>
    )
    internal func exponentiationIsNotCommutative(
        base: UInt4,
        exponent: UInt4.Exponent
    ) {
        let result: UInt4 = base ** exponent
        let reversedResult: UInt4 = exponent ** base
        #expect(result != reversedResult)
    }
}

// MARK: - Positive One

extension UInt4RaisableTests {
    @Test(
        "Raising to positive one preserves base",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<UInt4>
    )
    internal func raisingToPositiveOnePreservesBase(base: UInt4) {
        let result: UInt4 = base ** 1
        #expect(result == base)
    }

    @Test(
        "Positive one base exponentiation returns positive one",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<UInt4.Exponent>
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: UInt4.Exponent) {
        let result: UInt4 = UInt4(1) ** exponent
        #expect(result == 1)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: UInt4,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: 1)
        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension UInt4RaisableTests {
    @Test(
        "Raising to positive zero returns one",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<UInt4>
    )
    internal func raisingToPositiveZeroReturnsOne(base: UInt4) {
        let result: UInt4 = base ** UInt4.Exponent.zero
        #expect(result == 1)
    }

    @Test(
        "Positive zero base power predicate follows unsigned integer rules",
        arguments: [
            (0, true),
            (1, true),
            (2, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func positiveZeroBasePowerPredicateFollowsUnsignedIntegerRules(
        value: UInt4,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: UInt4.zero)
        #expect(result == expected)
    }

    @Test(
        "Positive zero base exponentiation follows unsigned integer rules",
        arguments: [
            (0, 0, 1),
            (0, 1, 0),
            (0, 2, 0)
        ] as Array<(UInt4, UInt4.Exponent, UInt4)>
    )
    internal func positiveZeroBaseExponentiationFollowsUnsignedIntegerRules(
        base: UInt4,
        exponent: UInt4.Exponent,
        power: UInt4
    ) {
        let result: UInt4 = base ** exponent
        #expect(result == power)
    }
}
