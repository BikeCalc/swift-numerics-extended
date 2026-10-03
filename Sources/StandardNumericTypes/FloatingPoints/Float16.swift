// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols
import StandardNumericProtocols

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Addable {
    public typealias Addend = Self
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Decreasable {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Divisible {
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self

    public static func % (
        _ lhs: Self,
        _ rhs: Self.RemainderDivisor
    ) -> Self {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Increasable {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Multipliable {
    public typealias Multiplier = Self
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Negateable {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Raisable {
    public typealias Exponent = Int
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByInfinity {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByNaN {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByZero {}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Roundable {
    public typealias DecimalPlace = UInt
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Subtractable {
    public typealias Subtrahend = Self
}

@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Truncatable {}
#endif
