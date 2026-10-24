// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Synchronization
import Testing

@Suite("Roman AtomicRepresentable Tests")
internal struct RomanAtomicRepresentableTests {
    internal init() {}

    @Test(
        "Representation round trip succeeds",
        arguments: [
            0,
            1,
            4,
            16,
            3_999
        ] as Array<Roman>
    )
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    internal func representationRoundTripSucceeds(initialValue: Roman) {
        let representation: Roman.AtomicRepresentation = Roman.encodeAtomicRepresentation(initialValue)
        let decodedValue: Roman = Roman.decodeAtomicRepresentation(representation)
        #expect(decodedValue == initialValue)
    }
}
