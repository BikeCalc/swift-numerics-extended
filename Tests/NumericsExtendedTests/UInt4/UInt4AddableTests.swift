// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Addable Tests")
internal struct UInt4AddableTests {
    private static let additionArguments: [(UInt4, UInt4, UInt4)] = [
        (2, 3, 5),
        (3, 4, 7)
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: UInt4,
        addend: UInt4,
        sum: UInt4
    ) {
        #expect(augend + addend == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: UInt4,
        addend: UInt4,
        sum: UInt4
    ) {
        var runningSum: UInt4 = augend
        runningSum += addend
        #expect(runningSum == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: UInt4,
        addend: UInt4,
        sum: UInt4
    ) {
        #expect(augend.adding(addend) == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: UInt4,
        addend: UInt4,
        sum: UInt4
    ) {
        var runningSum: UInt4 = augend
        runningSum.add(addend)
        #expect(runningSum == sum)
    }
}

extension UInt4AddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: UInt4,
        addend: UInt4,
        sum _: UInt4
    ) {
        #expect(augend + addend == addend + augend)
    }
}

// MARK: - Positive Zero

extension UInt4AddableTests {
    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            2,
            3
        ] as Array<UInt4>
    )
    internal func addingPositiveZeroPreservesAugend(augend: UInt4) {
        #expect(augend + UInt4.zero == augend)
    }
}
