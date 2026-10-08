// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols
import StandardNumericProtocols

// MARK: - Addable

extension Float32: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Decreasable

extension Float32: Decreasable {}

// MARK: - Divisible

extension Float32: Divisible {
    public typealias Remainder = Self
    public typealias Quotient = Self
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self

    public static func % (
        _ lhs: Self,
        _ rhs: Self.RemainderDivisor
    ) -> Self.Remainder {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
}

// MARK: - Increasable

extension Float32: Increasable {}

// MARK: - Multipliable

extension Float32: Multipliable {
    public typealias Product = Self
    public typealias Multiplier = Self
}

// MARK: - Negateable

extension Float32: Negateable {}

// MARK: - Raisable

extension Float32: Raisable {
    public typealias Power = Self
    public typealias Exponent = Int
}

// MARK: - RepresentableByInfinity

extension Float32: RepresentableByInfinity {}

// MARK: - RepresentableByNaN

extension Float32: RepresentableByNaN {}

// MARK: - RepresentableByZero

extension Float32: RepresentableByZero {}

// MARK: - Roundable

extension Float32: Roundable {
    public typealias DecimalPlace = UInt
}

// MARK: - Subtractable

extension Float32: Subtractable {
    public typealias Subtrahend = Self
}

// MARK: - Truncatable

extension Float32: Truncatable {}
