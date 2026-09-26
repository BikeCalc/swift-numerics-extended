# ``NumericsExtended``

A Swift package extending numeric protocols, standard numeric types, and experimental numeric types.

## Overview

Numerics Extended provides a layered set of numeric protocols and utilities for Swift. It includes core numeric
operators, core numeric protocols, extensions for standard library numeric protocols, standard numeric type
conformances, experimental numeric constants, experimental numeric protocols, and experimental numeric types such as
`Fraction`, `Roman`, `Int4`, and `UInt4`.

Experimental numeric types are included for exploration and documentation, and their APIs may evolve across major
releases.

## Topics

### Start Here

- <doc:Installation>
- <doc:PackageArchitecture>
- <doc:NumericProtocolHierarchy>

### Articles

- <doc:UnderstandingFourBitIntegers>
- <doc:UnderstandingRationalTypes>
- <doc:UnderstandingRomanNumerals>

### Operations

- ``/CoreNumericProtocols/Operatable``
- ``/CoreNumericProtocols/Addable``
- ``/CoreNumericProtocols/Subtractable``
- ``/CoreNumericProtocols/Multipliable``
- ``/CoreNumericProtocols/Divisible``
- ``/CoreNumericProtocols/Negateable``
- ``/CoreNumericProtocols/Raisable``

### Relations

- ``/CoreNumericProtocols/ApproximatelyEquatable``
- ``/CoreNumericProtocols/CanonicallyEquatable``

### Representations

- ``/CoreNumericProtocols/RepresentableByZero``
- ``/CoreNumericProtocols/RepresentableByMin``
- ``/CoreNumericProtocols/RepresentableByMax``
- ``/CoreNumericProtocols/RepresentableByInfinity``
- ``/CoreNumericProtocols/RepresentableByNaN``

### Transformations

- ``/CoreNumericProtocols/Canonicalizable``
- ``/CoreNumericProtocols/Roundable``
- ``/CoreNumericProtocols/Truncatable``

### Adjustments

- ``/CoreNumericProtocols/Increasable``
- ``/CoreNumericProtocols/Decreasable``

### Overflow Reporting

- ``/CoreNumericProtocols/ReportableAsOverflow``

### Experimental Numeric Protocols

- ``/ExperimentalNumericProtocols/Rational``
- ``/ExperimentalNumericProtocols/SymbolicInteger``

### Experimental Numeric Types

- ``/ExperimentalNumericTypes/Fraction``
- ``/ExperimentalNumericTypes/Int4``
- ``/ExperimentalNumericTypes/UInt4``
- ``/ExperimentalNumericTypes/Roman``

### Wrappers

- ``/CoreNumericProtocols/Canonicalized``
