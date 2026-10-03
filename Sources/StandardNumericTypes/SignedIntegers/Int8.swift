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

extension Int8: Addable {
    public typealias Addend = Self
}

// MARK: - Divisible

extension Int8: Divisible {
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self
}

// MARK: - Multipliable

extension Int8: Multipliable {
    public typealias Multiplier = Self
}

// MARK: - Negateable

extension Int8: Negateable {}

// MARK: - Raisable

extension Int8: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension Int8: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension Int8: RepresentableByZero {}

// MARK: - Subtractable

extension Int8: Subtractable {
    public typealias Subtrahend = Self
}
