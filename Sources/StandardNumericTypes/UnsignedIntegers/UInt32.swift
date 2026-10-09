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

extension UInt32: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

extension UInt32: Divisible {
    public typealias Divisor = Self
    public typealias Quotient = Self
    public typealias RemainderDivisor = Self
    public typealias Remainder = Self
}

// MARK: - Multipliable

extension UInt32: Multipliable {
    public typealias Multiplier = Self
    public typealias Product = Self
}

// MARK: - Raisable

extension UInt32: Raisable {
    public typealias Exponent = Self
    public typealias Power = Self
}

// MARK: - ReportableAsOverflow

extension UInt32: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension UInt32: RepresentableByZero {}

// MARK: - Subtractable

extension UInt32: Subtractable {
    public typealias Subtrahend = Self
    public typealias Difference = Self
}
