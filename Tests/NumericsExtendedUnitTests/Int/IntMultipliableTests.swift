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
    private static let multiplicationArguments: [(Int, Int, Int)] = [
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
        ]
    )
    internal func isMultipleOf(
        multiplicand: Int,
        multiplier: Int,
        result: Bool
    ) {
        #expect(multiplicand.isMultiple(of: multiplier) == result)
    }

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Int,
        multiplier: Int,
        product: Int
    ) {
        #expect(multiplicand * multiplier == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Int,
        multiplier: Int,
        product: Int
    ) {
        var runningProduct: Int = multiplicand
        runningProduct *= multiplier
        #expect(runningProduct == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Int,
        multiplier: Int,
        product: Int
    ) {
        #expect(multiplicand.multiplying(by: multiplier) == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Int,
        multiplier: Int,
        product: Int
    ) {
        var runningProduct: Int = multiplicand
        runningProduct.multiply(by: multiplier)
        #expect(runningProduct == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Int,
        product: Int
    ) {
        #expect(multiplicand.doubled() == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Int,
        product: Int
    ) {
        var runningProduct: Int = multiplicand
        runningProduct.double()
        #expect(runningProduct == product)
    }
}

extension IntMultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Int,
        multiplier: Int,
        product _: Int
    ) {
        #expect(multiplicand * multiplier == multiplier * multiplicand)
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
        ]
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Int,
        product: Int
    ) {
        #expect(multiplicand * -1 == product)
    }

    @Test(
        "Is multiple of negative one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func isMultipleOfNegativeOneReturnsTrue(multiplicand: Int) {
        #expect(multiplicand.isMultiple(of: -1) == true)
    }
}

// MARK: - Negative Zero

extension IntMultipliableTests {
    @Test("Negative zero is multiple of negative zero")
    internal func negativeZeroIsMultipleOfNegativeZero() {
        #expect(Int.negativeZero.isMultiple(of: Int.negativeZero) == true)
    }

    @Test(
        "Is multiple of negative zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Int) {
        #expect(multiplicand.isMultiple(of: Int.negativeZero) == false)
    }

    @Test(
        "Multiplying by negative zero returns negative zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func multiplyingByNegativeZeroReturnsNegativeZero(multiplicand: Int) {
        #expect(multiplicand * Int.negativeZero == Int.negativeZero)
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
        ]
    )
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Int) {
        #expect(multiplicand * 1 == multiplicand)
    }

    @Test(
        "Is multiple of positive one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func isMultipleOfPositiveOneReturnsTrue(multiplicand: Int) {
        #expect(multiplicand.isMultiple(of: 1) == true)
    }
}

// MARK: - Positive Zero

extension IntMultipliableTests {
    @Test("Positive zero is multiple of positive zero")
    internal func positiveZeroIsMultipleOfPositiveZero() {
        #expect(Int.zero.isMultiple(of: Int.zero) == true)
    }

    @Test(
        "Is multiple of positive zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Int) {
        #expect(multiplicand.isMultiple(of: Int.zero) == false)
    }

    @Test(
        "Multiplying by positive zero returns positive zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func multiplyingByPositiveZeroReturnsPositiveZero(multiplicand: Int) {
        #expect(multiplicand * Int.zero == Int.zero)
    }
}
