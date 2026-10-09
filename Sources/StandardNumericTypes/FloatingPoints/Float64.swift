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

extension Float64: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Decreasable

extension Float64: Decreasable {}

// MARK: - Divisible

extension Float64: Divisible {
    public typealias Divisor = Self
    public typealias Quotient = Self
    public typealias RemainderDivisor = Self
    public typealias Remainder = Self

    public static func % (
        _ lhs: Self,
        _ rhs: Self.RemainderDivisor
    ) -> Self.Remainder {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
}

// MARK: - Increasable

extension Float64: Increasable {}

// MARK: - Multipliable

extension Float64: Multipliable {
    public typealias Multiplier = Self
    public typealias Product = Self
}

// MARK: - Negateable

extension Float64: Negateable {}

// MARK: - Raisable

extension Float64: Raisable {
    public typealias Exponent = Int
    public typealias Power = Self
}

// MARK: - RepresentableByInfinity

extension Float64: RepresentableByInfinity {}

// MARK: - RepresentableByNaN

extension Float64: RepresentableByNaN {}

// MARK: - RepresentableByZero

extension Float64: RepresentableByZero {}

// MARK: - Roundable

extension Float64: Roundable {
    public typealias DecimalPlace = UInt
}

// MARK: - Subtractable

extension Float64: Subtractable {
    public typealias Subtrahend = Self
    public typealias Difference = Self
}

// MARK: - Truncatable

extension Float64: Truncatable {}
