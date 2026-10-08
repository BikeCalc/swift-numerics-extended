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

extension UInt64: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

extension UInt64: Divisible {
    public typealias Remainder = Self
    public typealias Quotient = Self
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self
}

// MARK: - Multipliable

extension UInt64: Multipliable {
    public typealias Product = Self
    public typealias Multiplier = Self
}

// MARK: - Raisable

extension UInt64: Raisable {
    public typealias Power = Self
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension UInt64: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension UInt64: RepresentableByZero {}

// MARK: - Subtractable

extension UInt64: Subtractable {
    public typealias Difference = Self
    public typealias Subtrahend = Self
}
