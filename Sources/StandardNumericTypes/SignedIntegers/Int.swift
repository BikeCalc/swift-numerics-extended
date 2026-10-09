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

extension Int: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

extension Int: Divisible {
    public typealias Divisor = Self
    public typealias Quotient = Self
    public typealias RemainderDivisor = Self
    public typealias Remainder = Self
}

// MARK: - Multipliable

extension Int: Multipliable {
    public typealias Multiplier = Self
    public typealias Product = Self
}

// MARK: - Negateable

extension Int: Negateable {}

// MARK: - Raisable

extension Int: Raisable {
    public typealias Exponent = Self
    public typealias Power = Self
}

// MARK: - ReportableAsOverflow

extension Int: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension Int: RepresentableByZero {}

// MARK: - Subtractable

extension Int: Subtractable {
    public typealias Subtrahend = Self
    public typealias Difference = Self
}
