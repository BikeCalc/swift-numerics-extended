// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended

/// The arithmetic, comparison, and canonicalization benchmarks for `Fraction`.
internal let fractionBenchmarks: Array<Benchmark> = {
    let lhs: Fraction<Int> = .init(1_234, 5_679)
    let rhs: Fraction<Int> = .init(8_765, 4_321)
    let equalityRHS: Fraction<Int> = lhs
    let base: Fraction<Int> = .init(12, 17)
    let exponent: Int = 5
    let noncanonicalValue: Fraction<Int> = .init(123_456, -789_012)

    return [
        .init(name: "Fraction.addition") {
            consumeBenchmarkResult(lhs + rhs)
        },
        .init(name: "Fraction.subtraction") {
            consumeBenchmarkResult(lhs - rhs)
        },
        .init(name: "Fraction.multiplication") {
            consumeBenchmarkResult(lhs * rhs)
        },
        .init(name: "Fraction.division") {
            consumeBenchmarkResult(lhs / rhs)
        },
        .init(name: "Fraction.negation") {
            consumeBenchmarkResult(-lhs)
        },
        .init(name: "Fraction.exponentiation") {
            consumeBenchmarkResult(base ** exponent)
        },
        .init(name: "Fraction.equality") {
            consumeBenchmarkResult(lhs == equalityRHS)
        },
        .init(name: "Fraction.comparison") {
            consumeBenchmarkResult(lhs < rhs)
        },
        .init(name: "Fraction.canonicalization") {
            consumeBenchmarkResult(noncanonicalValue.canonicalized())
        }
    ]
}()
