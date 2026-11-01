// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Multipliable Tests")
internal struct Int4MultipliableTests {
    internal init() {}

    private static let multiplicationArguments: [(Int4, Int4.Multiplier, Int4)] = [
        (2, 3, 6),
        (-2, 3, -6)
    ]

    private static let doublingArguments: [(Int4, Int4)] = [
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
        ] as Array<(Int4, Int4, Bool)>
    )
    internal func isMultipleOf(
        multiplicand: Int4,
        multiplier: Int4,
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
        multiplicand: Int4,
        multiplier: Int4.Multiplier,
        product: Int4
    ) {
        let result: Int4 = multiplicand * multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Int4,
        multiplier: Int4.Multiplier,
        product: Int4
    ) {
        var result: Int4 = multiplicand
        result *= multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Int4,
        multiplier: Int4.Multiplier,
        product: Int4
    ) throws {
        let result: Int4 = try multiplicand.multiplying(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Int4,
        multiplier: Int4.Multiplier,
        product: Int4
    ) throws {
        var result: Int4 = multiplicand
        try result.multiply(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Int4,
        product: Int4
    ) {
        let result: Int4 = multiplicand.doubled()
        #expect(result == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Int4,
        product: Int4
    ) {
        var result: Int4 = multiplicand
        result.double()
        #expect(result == product)
    }
}

extension Int4MultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Int4,
        multiplier: Int4.Multiplier,
        product _: Int4
    ) {
        let result: Int4 = multiplicand * multiplier
        #expect(result == multiplier * multiplicand)
    }
}

// MARK: - Negative One

extension Int4MultipliableTests {
    @Test(
        "Multiplying by negative one returns opposite value",
        arguments: [
            (2, -2),
            (3, -3),
            (-2, 2),
            (-3, 3)
        ] as Array<(Int4, Int4)>
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Int4,
        product: Int4
    ) {
        let result: Int4 = multiplicand * -1
        #expect(result == product)
    }

    @Test(
        "Is multiple of negative one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func isMultipleOfNegativeOneReturnsTrue(multiplicand: Int4) {
        let result: Bool = multiplicand.isMultiple(of: -1)
        #expect(result == true)
    }
}

// MARK: - Negative Zero

extension Int4MultipliableTests {
    @Test("Negative zero is multiple of negative zero")
    internal func negativeZeroIsMultipleOfNegativeZero() {
        let result: Bool = Int4.negativeZero.isMultiple(of: Int4.negativeZero)
        #expect(result == true)
    }

    @Test(
        "Is multiple of negative zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Int4) {
        let result: Bool = multiplicand.isMultiple(of: Int4.negativeZero)
        #expect(result == false)
    }

    @Test(
        "Multiplying by negative zero returns negative zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func multiplyingByNegativeZeroReturnsNegativeZero(multiplicand: Int4) {
        let result: Int4 = multiplicand * Int4.negativeZero
        #expect(result == Int4.negativeZero)
    }
}

// MARK: - Positive One

extension Int4MultipliableTests {
    @Test(
        "Multiplying by positive one preserves multiplicand",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Int4) {
        let result: Int4 = multiplicand * 1
        #expect(result == multiplicand)
    }

    @Test(
        "Is multiple of positive one returns true",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func isMultipleOfPositiveOneReturnsTrue(multiplicand: Int4) {
        let result: Bool = multiplicand.isMultiple(of: 1)
        #expect(result == true)
    }
}

// MARK: - Positive Zero

extension Int4MultipliableTests {
    @Test("Positive zero is multiple of positive zero")
    internal func positiveZeroIsMultipleOfPositiveZero() {
        let result: Bool = Int4.zero.isMultiple(of: Int4.zero)
        #expect(result == true)
    }

    @Test(
        "Is multiple of positive zero returns false",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Int4) {
        let result: Bool = multiplicand.isMultiple(of: Int4.zero)
        #expect(result == false)
    }

    @Test(
        "Multiplying by positive zero returns positive zero",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int4>
    )
    internal func multiplyingByPositiveZeroReturnsPositiveZero(multiplicand: Int4) {
        let result: Int4 = multiplicand * Int4.zero
        #expect(result == Int4.zero)
    }
}
