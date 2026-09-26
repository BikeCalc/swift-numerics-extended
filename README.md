![](/Assets/GitHubBanner.png)

# Swift Numerics Extended

A Swift package extending numeric protocols, standard numeric types, and experimental numeric types.

## Overview

Numerics Extended provides a layered set of numeric protocols and utilities for Swift. It includes core numeric
operators, core numeric protocols, extensions for standard library numeric protocols, standard numeric type
conformances, experimental numeric constants, experimental numeric protocols, and experimental numeric types such as
`Fraction`, `Roman`, `Int4`, and `UInt4`.

Experimental numeric types are included for exploration and documentation, and their APIs may evolve across major
releases.

## Requirements

- Swift 6.3+

Numerics Extended is written in Swift and avoids platform-specific APIs where possible.

## Installation

1. Add Numerics Extended to the dependencies in your `Package.swift` file:

    ```swift
    let package: Package = .init(
        ...
        dependencies: [
            .package(
                url: "https://github.com/bikecalc/swift-numerics-extended.git",
                from: "2.0.0"
            )
        ],
        ...
    )
    ```

2. Add the `NumericsExtended` product to the dependencies of the target that will import it. Replace `YourTarget` with
   the name of that target:

    ```swift
    let package: Package = .init(
        ...
        targets: [
            .target(
                name: "YourTarget",
                dependencies: [
                    .product(
                        name: "NumericsExtended",
                        package: "swift-numerics-extended"
                    )
                ]
            )
        ],
        ...
    )
    ```

3. Import the package in your source code:

    ```swift
    import NumericsExtended
    ```

## Demonstration

- Combine `Addable` and `RepresentableByZero` to total a sequence of values, starting from zero or an initial value:

  ```swift
  func total<Value>(
      _ values: some Sequence<Value>,
      startingAt initialValue: Value = .zero
  ) -> Value
  where Value: Addable & RepresentableByZero {
      var result = initialValue

      for value in values {
          result += value
      }

      return result
  }

  print(total([1, 2, 3]))
  // Prints "6"

  print(total([2.5, 3.5]))
  // Prints "6.0"
  ```

  The package provides small, composable protocols and extends Swift’s standard numeric types to conform where
  appropriate. Combine these protocols to require only the capabilities your algorithm needs, without requiring
  broader numeric protocols such as Swift’s `BinaryInteger` or `FloatingPoint`.

- Keep a `Fraction` in canonical form while doing arithmetic:

  ```swift
  @Canonicalized
  var value: Fraction<Int> = .init(2, 4)
  print(value)
  // Prints "1/2"

  value += .init(1, 4)
  print(value)
  // Prints "3/4"

  value *= .init(2, 3)
  print(value)
  // Prints "1/2"
  ```

  `Fraction` conforms to `Rational`, which builds on Swift's numeric protocols. Beyond the operations shown here, it
  supports subtraction, division, exponentiation, and comparisons.

## Documentation

You can read more about this package by visiting the
[documentation](https://bikecalc.github.io/swift-numerics-extended/documentation/numericsextended).

## Contributing

Everyone is welcome to contribute to Numerics Extended. See the [Contributing](/CONTRIBUTING.md) guide to get started.

If you find a bug, please create an [issue](https://github.com/bikecalc/swift-numerics-extended/issues). Security
vulnerabilities should be reported using the [Security Policy](/SECURITY.md).

## Code of Conduct

This project follows a [Code of Conduct](/CODE_OF_CONDUCT.md).

## License

Distributed under Apache License v2.0 with Runtime Library Exception. See the [License](/LICENSE.md) for more
information.
