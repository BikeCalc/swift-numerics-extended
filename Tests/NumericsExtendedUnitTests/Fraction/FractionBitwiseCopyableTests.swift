// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Fraction BitwiseCopyable Tests")
internal struct FractionBitwiseCopyableTests {
    internal init() {}

    @Test(
        "Bitwise copying preserves values",
        arguments: [
            .init(1, 2),
            .init(2, 4),
            .init(2, -4)
        ] as Array<Fraction<Int>>
    )
    internal func bitwiseCopyPreservesValue(value: Fraction<Int>) {
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}

// MARK: - NaN

extension FractionBitwiseCopyableTests {
    @Test("Bitwise copying preserves NaN")
    internal func nanBitwiseCopyPreservesValue() {
        let value: Fraction<Int> = .nan
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}

// MARK: - Negative Infinity

extension FractionBitwiseCopyableTests {
    @Test("Bitwise copying preserves negative infinity")
    internal func negativeInfinityBitwiseCopyPreservesValue() {
        let value: Fraction<Int> = .negativeInfinity
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}

// MARK: - Negative Zero

extension FractionBitwiseCopyableTests {
    @Test("Bitwise copying preserves negative zero")
    internal func negativeZeroBitwiseCopyPreservesValue() {
        let value: Fraction<Int> = .init(0, -2)
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}

// MARK: - Positive Infinity

extension FractionBitwiseCopyableTests {
    @Test("Bitwise copying preserves positive infinity")
    internal func positiveInfinityBitwiseCopyPreservesValue() {
        let value: Fraction<Int> = .infinity
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}

// MARK: - Positive Zero

extension FractionBitwiseCopyableTests {
    @Test("Bitwise copying preserves positive zero")
    internal func positiveZeroBitwiseCopyPreservesValue() {
        let value: Fraction<Int> = .init(0, 2)
        let copy: Fraction<Int> = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Fraction<Int>.self)
        }
        #expect(copy.numerator == value.numerator)
        #expect(copy.denominator == value.denominator)
        #expect(copy.description == value.description)
    }
}
