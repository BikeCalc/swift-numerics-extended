// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Addable Tests")
internal struct IntAddableTests {
    private static let additionArguments: [(Int, Int, Int)] = [
        (2, 3, 5),
        (3, 4, 7),
        (-2, 3, 1),
        (-3, -4, -7)
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Int,
        addend: Int,
        sum: Int
    ) {
        #expect(augend + addend == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Int,
        addend: Int,
        sum: Int
    ) {
        var runningSum: Int = augend
        runningSum += addend
        #expect(runningSum == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Int,
        addend: Int,
        sum: Int
    ) {
        #expect(augend.adding(addend) == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Int,
        addend: Int,
        sum: Int
    ) {
        var runningSum: Int = augend
        runningSum.add(addend)
        #expect(runningSum == sum)
    }
}

extension IntAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Int,
        addend: Int,
        sum _: Int
    ) {
        #expect(augend + addend == addend + augend)
    }
}

// MARK: - Negative Zero

extension IntAddableTests {
    @Test(
        "Adding negative zero preserves augend",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func addingNegativeZeroPreservesAugend(augend: Int) {
        #expect(augend + Int.negativeZero == augend)
    }
}

// MARK: - Positive Zero

extension IntAddableTests {
    @Test(
        "Adding opposite values returns positive zero",
        arguments: [
            (2, -2),
            (3, -3),
            (-2, 2),
            (-3, 3)
        ]
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Int,
        addend: Int
    ) {
        #expect(augend + addend == Int.zero)
    }

    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            2,
            3,
            -2,
            -3
        ]
    )
    internal func addingPositiveZeroPreservesAugend(augend: Int) {
        #expect(augend + Int.zero == augend)
    }
}
