// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Multipliable Tests")
internal struct IntMultipliableTests {
    internal init() {}

    private static let multiplicationArguments: [(Int, Int.Multiplier, Int)] = [
        (2, 3, 6),
        (3, 4, 12),
        (-2, 3, -6),
        (-3, -4, 12)
    ]

    private static let doublingArguments: [(Int, Int)] = [
        (2, 4),
        (3, 6),
        (-2, -4),
        (-3, -6)
    ]

    @Test(
        "Is multiple of",
        arguments: [
            (6, 3, true),
            (7, 3, false),
            (-6, 3, true),
            (-7, 3, false)
        ] as Array<(Int, Int, Bool)>
    )
    internal func isMultipleOf(
        multiplicand: Int,
        multiplier: Int,
        expected: Bool
    ) {
        let result: Bool = multiplicand.isMultiple(of: multiplier)
        #expect(result == expected)
    }

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Int,
        multiplier: Int.Multiplier,
        product: Int
    ) {
        let result: Int = multiplicand * multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Int,
        multiplier: Int.Multiplier,
        product: Int
    ) {
        var result: Int = multiplicand
        result *= multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Int,
        multiplier: Int.Multiplier,
        product: Int
    ) throws {
        let result: Int = try multiplicand.multiplying(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Int,
        multiplier: Int.Multiplier,
        product: Int
    ) throws {
        var result: Int = multiplicand
        try result.multiply(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Int,
        product: Int
    ) {
        let result: Int = multiplicand.doubled()
        #expect(result == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Int,
        product: Int
    ) {
        var result: Int = multiplicand
        result.double()
        #expect(result == product)
    }
}

extension IntMultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Int,
        multiplier: Int.Multiplier,
        product _: Int
    ) {
        let result: Int = multiplicand * multiplier
        #expect(result == multiplier * multiplicand)
    }
}

// MARK: - Negative One

extension IntMultipliableTests {
    @Test(
        "Multiplying by negative one returns opposite value",
        arguments: [
            (2, -2),
            (3, -3),
            (-2, 2),
            (-3, 3)
        ] as Array<(Int, Int)>
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Int,
        product: Int
    ) {
        let result: Int = multiplicand * -1
        #expect(result == product)
    }

    @Test(
        "Is multiple of negative one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func isMultipleOfNegativeOneReturnsTrue(multiplicand: Int) {
        let result: Bool = multiplicand.isMultiple(of: -1)
        #expect(result == true)
    }
}

// MARK: - Negative Zero

extension IntMultipliableTests {
    @Test("Negative zero is multiple of negative zero")
    internal func negativeZeroIsMultipleOfNegativeZero() {
        let result: Bool = Int.negativeZero.isMultiple(of: Int.negativeZero)
        #expect(result == true)
    }

    @Test(
        "Is multiple of negative zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Int) {
        let result: Bool = multiplicand.isMultiple(of: Int.negativeZero)
        #expect(result == false)
    }

    @Test(
        "Multiplying by negative zero returns negative zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func multiplyingByNegativeZeroReturnsNegativeZero(multiplicand: Int) {
        let result: Int = multiplicand * Int.negativeZero
        #expect(result == Int.negativeZero)
    }
}

// MARK: - Positive One

extension IntMultipliableTests {
    @Test(
        "Multiplying by positive one preserves multiplicand",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Int) {
        let result: Int = multiplicand * 1
        #expect(result == multiplicand)
    }

    @Test(
        "Is multiple of positive one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func isMultipleOfPositiveOneReturnsTrue(multiplicand: Int) {
        let result: Bool = multiplicand.isMultiple(of: 1)
        #expect(result == true)
    }
}

// MARK: - Positive Zero

extension IntMultipliableTests {
    @Test("Positive zero is multiple of positive zero")
    internal func positiveZeroIsMultipleOfPositiveZero() {
        let result: Bool = Int.zero.isMultiple(of: Int.zero)
        #expect(result == true)
    }

    @Test(
        "Is multiple of positive zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Int) {
        let result: Bool = multiplicand.isMultiple(of: Int.zero)
        #expect(result == false)
    }

    @Test(
        "Multiplying by positive zero returns positive zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func multiplyingByPositiveZeroReturnsPositiveZero(multiplicand: Int) {
        let result: Int = multiplicand * Int.zero
        #expect(result == Int.zero)
    }
}
