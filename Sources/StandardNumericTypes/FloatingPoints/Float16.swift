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

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}
#endif

// MARK: - Decreasable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Decreasable {}
#endif

// MARK: - Divisible

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Divisible {
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
#endif

// MARK: - Increasable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Increasable {}
#endif

// MARK: - Multipliable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Multipliable {
    public typealias Product = Self
    public typealias Multiplier = Self
}
#endif

// MARK: - Negateable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Negateable {}
#endif

// MARK: - Raisable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Raisable {
    public typealias Exponent = Int
}
#endif

// MARK: - RepresentableByInfinity

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByInfinity {}
#endif

// MARK: - RepresentableByNaN

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByNaN {}
#endif

// MARK: - RepresentableByZero

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: RepresentableByZero {}
#endif

// MARK: - Roundable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Roundable {
    public typealias DecimalPlace = UInt
}
#endif

// MARK: - Subtractable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Subtractable {
    public typealias Subtrahend = Self
}
#endif

// MARK: - Truncatable

#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: Truncatable {}
#endif
