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

extension Int32: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

extension Int32: Divisible {
    public typealias Divisor = Self
    public typealias Quotient = Self
    public typealias RemainderDivisor = Self
    public typealias Remainder = Self
}

// MARK: - Multipliable

extension Int32: Multipliable {
    public typealias Multiplier = Self
    public typealias Product = Self
}

// MARK: - Negateable

extension Int32: Negateable {}

// MARK: - Raisable

extension Int32: Raisable {
    public typealias Exponent = Self
    public typealias Power = Self
}

// MARK: - ReportableAsOverflow

extension Int32: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension Int32: RepresentableByZero {}

// MARK: - Subtractable

extension Int32: Subtractable {
    public typealias Subtrahend = Self
    public typealias Difference = Self
}
