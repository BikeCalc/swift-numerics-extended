// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended

/// The arithmetic and comparison benchmarks for canonicalized `Fraction` values.
internal let canonicalizedFractionBenchmarks: Array<Benchmark> = {
    let lhs: Canonicalized<Fraction<Int>> = .init(wrappedValue: .init(1_234, 5_679))
    let rhs: Fraction<Int> = .init(8_765, 4_321)
    let equalityRHS: Canonicalized<Fraction<Int>> = lhs
    let comparisonRHS: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
    let base: Canonicalized<Fraction<Int>> = .init(wrappedValue: .init(12, 17))
    let exponent: Int = 5

    return [
        .init(name: "CanonicalizedFraction.addition") {
            var result: Canonicalized<Fraction<Int>> = lhs
            result.wrappedValue += rhs
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.subtraction") {
            var result: Canonicalized<Fraction<Int>> = lhs
            result.wrappedValue -= rhs
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.multiplication") {
            var result: Canonicalized<Fraction<Int>> = lhs
            result.wrappedValue *= rhs
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.division") {
            var result: Canonicalized<Fraction<Int>> = lhs
            result.wrappedValue /= rhs
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.negation") {
            var result: Canonicalized<Fraction<Int>> = lhs
            result.wrappedValue.negate()
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.exponentiation") {
            var result: Canonicalized<Fraction<Int>> = base
            result.wrappedValue **= exponent
            consumeBenchmarkResult(result)
        },
        .init(name: "CanonicalizedFraction.equality") {
            consumeBenchmarkResult(lhs == equalityRHS)
        },
        .init(name: "CanonicalizedFraction.comparison") {
            consumeBenchmarkResult(lhs < comparisonRHS)
        }
    ]
}()
