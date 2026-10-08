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

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: Divisible {
    public typealias Remainder = Self
    public typealias Quotient = Self
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self
}

// MARK: - Multipliable

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: Multipliable {
    public typealias Product = Self
    public typealias Multiplier = Self
}

// MARK: - Raisable

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: ReportableAsOverflow {}

// MARK: - RepresentableByZero

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: RepresentableByZero {}

// MARK: - Subtractable

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension UInt128: Subtractable {
    public typealias Subtrahend = Self
}
