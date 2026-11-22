// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Numerics
import NumericsExtended
import Testing

@Suite("Complex Addable Tests")
internal struct ComplexAddableTests {
    internal init() {}

    private static let additionArguments: Array<(Complex<Double>, Complex<Double>, Complex<Double>)> = [
        (.init(2, 3), .init(3, 4), .init(5, 7)),
        (.init(-2, -3), .init(3, -4), .init(1, -7)),
        (.init(0.5, 1.5), .init(1.5, 2.5), .init(2, 4)),
        (.init(-0.5, -1.5), .init(1.5, -2.5), .init(1, -4))
    ]

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Complex<Double>,
        addend: Complex<Double>,
        sum: Complex<Double>
    ) throws {
        let result: Complex<Double> = try augend.adding(addend)
        #expect(result == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Complex<Double>,
        addend: Complex<Double>,
        sum: Complex<Double>
    ) throws {
        var result: Complex<Double> = augend
        try result.add(addend)
        #expect(result == sum)
    }
}
