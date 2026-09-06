# Coding Style

This guide describes the project's coding style. Follow it when changing source code, tests, documentation, and
configuration files.

The `.swift-format` file is authoritative for formatting that Swift Format can enforce. The Swift Format section
explains its configuration and rules. The Project Conventions section defines requirements that Swift Format cannot
fully enforce.

## Swift Format

### Configuration

- `fileScopedDeclarationPrivacy`: File-scoped declarations with restricted access use `fileprivate` rather than
  `private`.
- `indentation`: Indentation uses four spaces. Tabs count as eight columns if encountered.
- `indentBlankLines`: Blank lines are not indented.
- `indentConditionalCompilationBlocks`: Conditional compilation blocks do not add an indentation level.
- `indentSwitchCaseLabels`: Case labels align with their enclosing `switch` statement.
- `lineLength`: Swift source lines are limited to 120 characters where possible.
- `lineBreakAroundMultilineExpressionChainComponents`: Multiline expression chains are not required to break around
  every component.
- `lineBreakBeforeControlFlowKeywords`: Keywords such as `else` remain beside the preceding closing brace.
- `lineBreakBeforeEachArgument`: Once an argument list is multiline, every argument begins on its own line.
- `lineBreakBeforeEachGenericRequirement`: Generic requirements may remain together where they fit.
- `lineBreakBetweenDeclarationAttributes`: Each declaration attribute begins on its own line.
- `maximumBlankLines`: At most one consecutive blank line is permitted.
- `multiElementCollectionTrailingCommas`: Multiline collection literals do not use trailing commas.
- `noAssignmentInExpressions`: No function is exempt from the prohibition on assignments inside expressions.
- `orderedImports`: Imports inside conditional compilation blocks are included when ordering imports.
- `prioritizeKeepingFunctionOutputTogether`: Line breaking prioritizes keeping a function's output with its declaration.
- `reflowMultilineStringLiterals`: Multiline string literals are never reflowed automatically.
- `respectsExistingLineBreaks`: Existing line breaks are preserved where the formatter permits them.
- `spacesAroundRangeFormationOperators`: Range operators have spaces on both sides.
- `spacesBeforeEndOfLineComments`: End-of-line comments have one preceding space.
- `tabWidth`: Tabs occupy eight columns when the formatter calculates layout.

Swift Format also removes trailing whitespace as part of its standard formatting behavior.

### Enabled Rules

- `AlwaysUseLiteralForEmptyCollectionInit`: Empty collections use literal syntax, such as
  `let values: Array<Int> = []`, rather than `Array<Int>()`.
- `AlwaysUseLowerCamelCase`: Value identifiers use lowerCamelCase. Test function names may contain underscores where
  Swift Format permits them.
- `AmbiguousTrailingClosureOverload`: Overloads cannot be distinguished only by labels on a single closure parameter.
- `BeginDocumentationCommentWithOneLineSummary`: Documentation comments begin with a one-line summary.
- `DoNotUseSemicolons`: Swift statements do not use semicolons as separators or terminators.
- `FileScopedDeclarationPrivacy`: File-scoped restricted declarations consistently use `fileprivate`.
- `FullyIndirectEnum`: An enum is marked `indirect` when every one of its cases is indirect.
- `GroupNumericLiterals`: Long numeric literals use underscores to group digits according to their radix.
- `IdentifiersMustBeASCII`: Identifiers contain only ASCII characters; Unicode remains valid inside string values.
- `NeverForceUnwrap`: Optional values are not force-unwrapped.
- `NeverUseForceTry`: Throwing expressions do not use `try!`.
- `NeverUseImplicitlyUnwrappedOptionals`: Declarations do not use implicitly unwrapped optional types.
- `NoAccessLevelOnExtensionDeclaration`: Access levels are applied to members rather than extension declarations.
- `NoAssignmentInExpressions`: Assignments remain standalone statements instead of appearing inside other expressions.
- `NoBlockComments`: Comments use line-comment syntax rather than `/* ... */` blocks.
- `NoCasesWithOnlyFallthrough`: Cases are combined instead of using a case whose only statement is `fallthrough`.
- `NoEmptyLinesOpeningClosingBraces`: Blocks have no blank line immediately after `{` or immediately before `}`.
- `NoEmptyTrailingClosureParentheses`: A call with no arguments omits empty parentheses before its trailing closure.
- `NoParensAroundConditions`: Conditions omit outer parentheses unless they are required to avoid a parsing ambiguity.
- `NoPlaygroundLiterals`: Source code does not use playground-only color, file, or image literals.
- `NoVoidReturnOnFunctionSignature`: Functions returning no value omit an explicit `Void` or `()` return type.
- `OneCasePerLine`: Enum cases with associated values or raw values use separate case declarations.
- `OneVariableDeclarationPerLine`: Each declaration introduces one variable, except when destructuring a tuple.
- `OnlyOneTrailingClosureArgument`: Calls do not mix a trailing closure with another closure argument.
- `OrderedImports`: Imports are ordered lexicographically and grouped by import kind.
- `ReplaceForEachWithForLoop`: Use a `for` loop instead of `forEach`, except when passing a function reference.
- `ReturnVoidInsteadOfEmptyTuple`: Use `Void` rather than `()` where an explicit void type is required.
- `TypeNamesShouldBeCapitalized`: Structure, class, enumeration, and protocol names begin with a capital letter.
- `UseEarlyExits`: Replace an `if`/`else` whose alternative exits the scope with an equivalent early-exit `guard`.
- `UseExplicitNilCheckInConditions`: Use `value != nil` when an optional binding would immediately discard its value.
- `UseLetInEveryBoundCaseVariable`: Put `let` or `var` beside every value bound in a case pattern.
- `UseSingleLinePropertyGetter`: Read-only computed properties omit an unnecessary explicit `get` block.
- `UseTripleSlashForDocumentationComments`: Documentation comments use `///` rather than block-comment syntax.
- `UseWhereClausesInForLoops`: A loop whose entire body is one `if` statement moves that condition into `where`.
- `ValidateDocumentationComments`: Documentation comments use valid sections and document parameters, results, and
  thrown errors where applicable.

### Disabled Rules

Disabled rules represent intentional style choices rather than omissions:

- `AllPublicDeclarationsHaveDocumentation`: Public APIs should be documented at their original declaration, but
  protocol witnesses do not need to repeat documentation inherited from their requirements.
- `AvoidRetroactiveConformances`: Explicit `@retroactive` conformances are permitted when they are appropriate.
- `DontRepeatTypeInStaticProperties`: A static property name may repeat its return type when doing so improves clarity.
- `NoLabelsInCasePatterns`: Matching labels may remain in case patterns when they make the pattern easier to understand.
- `NoLeadingUnderscores`: Leading underscores are permitted when they serve a specific purpose, rather than being used
  only to communicate access level.
- `OmitExplicitReturns`: Explicit `return` statements are preferred because they make control flow easier to identify,
  including in single-expression declarations and closures.
- `UseShorthandTypeNames`: Full generic type names such as `Array<Element>` are preferred when they make the type clear.
- `UseSynthesizedInitializer`: An explicit initializer may remain when it makes construction requirements clearer, even
  if Swift could synthesize an equivalent initializer.

The `SwiftTestingNamingConventions` rule documented by newer Swift Format versions is intentionally omitted until the
package's pinned Swift Format version supports it.

## Project Conventions

These conventions cover project-wide or judgment-based requirements that `.swift-format` cannot fully enforce.

### Numeric Formatting

Use a period as the decimal separator. In prose and explanatory tables, group thousands with commas, such as
`1,000.25`.

### Imports and APIs

Avoid importing Foundation unless it is required. When Foundation is only needed for a specific platform or feature,
prefer wrapping the import with `#if canImport(Foundation)`.

Prefer Swift standard-library types and Swift-native API overlays when they provide equivalent behavior. Use
Objective-C types and APIs only when required for interoperability or when no suitable Swift-native alternative exists.
Prefer current, nondeprecated APIs that support the package's deployment targets.

### Identifier Naming

#### Acronyms

Preserve every letter of an acronym in the same case. Use uppercase acronyms in type-style names and lowercase an
acronym only when it begins a value-style name.

Types, protocols, type aliases, associated types, and their matching filenames use UpperCamelCase. Keep an acronym
uppercase whether it appears at the beginning or end of one of these names:

```swift
protocol HTTPRequest {}
struct RemoteURL {}
```

Functions, properties, parameters, local variables, and enum cases use lowerCamelCase. Lowercase an acronym at the
beginning of one of these names, but keep it uppercase when it appears at the end:

```swift
let httpRequest = "HTTP Client"
let remoteURL = "Remote URL"
func httpRequest() {}
func remoteURL() {}
```

When an acronym is the complete value name, write the entire name in lowercase, such as `url` or `http`.

#### Shortened Words

Some shortened words are not acronyms. For example, treat `Id` as a shortened form of `identifier`. Use `UserId` in
type-style names, `userId` in value-style names, and `id` when it is the complete value name:

```swift
struct UserId {}
let userId = "User Identifier"
func userId() {}
```

### Declaration Order

Organize declarations by their role and relationship rather than alphabetically or by access level. Use the following
order as a baseline, but keep closely related declarations, overloads, and paired operations together when that makes
the API easier to understand. Within each category, place fundamental behavior before convenience behavior.

Within a concrete type, use the following order when applicable:

1. Enumeration cases
2. Type aliases
3. Nested types
4. Stored instance properties
5. Initializers
6. Deinitializers
7. Computed instance properties
8. Type properties
9. Instance subscripts
10. Type subscripts
11. Instance functions
12. Type functions and operators

Apply the same relative order to protocols and extensions, omitting categories that do not apply. Protocols place
associated types alongside type aliases at the beginning. Order protocol-conformance extensions alphabetically by
protocol name, and follow the applicable declaration order within each extension while keeping related requirements and
implementations together.

### Declaration Layout

Expand parameter and argument lists that contain more than one item, even when Swift Format could keep them on one
line. Keep the opening parenthesis on the declaration or call line, place each parameter or argument on its own line,
and place the closing parenthesis on its own line.

A short initializer call designed as tuple-like value construction may remain on one line when its unlabeled arguments
fit comfortably within the line limit, such as `Foo(1, 2)`. Keep the initializer declaration expanded so its parameter 
names remain visible.

Keep tuple types and tuple literals on one line when they fit within the line limit and remain readable. Expand them
only when their labels, types, or expressions make the single-line form difficult to understand.

Keep a short collection literal on the same line as its argument when it remains readable. Expand a longer collection
literal vertically, placing each element on its own line.

For example:

```swift
func foo(bar: String) {
    print(bar)
}

func foo(
    bar: String,
    baz: Array<String>
) {
    print([bar] + baz)
}

foo(bar: "foo")

foo(
    bar: "foo",
    baz: ["foo", "bar", "baz"]
)

foo(
    bar: "foo",
    baz: [
        "foo",
        "bar",
        "baz",
        "qux",
        "quux",
        "quuz",
        "corge",
        "grault",
        "garply",
        "waldo",
        "fred",
        "plugh",
        "xyzzy",
        "thud"
    ]
)
```

### Documentation

User-facing concepts, tutorials, and guides belong in the DocC catalog.

Protocol and protocol-extension documentation should describe requirements and guarantees without Swift examples that
assume a particular conforming type's behavior. Place examples only on public concrete types and their public
declarations, where their results are guaranteed. Keep examples short and focused on illustrating ordinary usage; use
tests instead for comprehensive cases and edge conditions.

Introduce every example with `For example:` on its own documentation line. Print the demonstrated value and show the
expected output with a `// Prints "..."` comment.

For example, document a public declaration as follows:

````text
/// For example:
///
/// ```swift
/// let value = 2 + 2
///
/// print(value)
/// // Prints "4"
/// ```
````

## Formatting Exceptions

Use `// swift-format-ignore` only where formatting would change syntax-sensitive fixtures or produce a materially less
readable representation that cannot be configured. Keep each ignore as close to and as narrowly scoped around the
affected declaration or expression as the installed formatter supports.

Current exceptions preserve exact macro-expansion fixtures and keep external macro declarations readable.
