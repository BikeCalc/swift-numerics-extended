// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

internal enum Decimal128Availability {
    internal static var isSupported: Bool {
        if #available(anyAppleOS 26.0, *) {
            return true
        }
        return false
    }
}
