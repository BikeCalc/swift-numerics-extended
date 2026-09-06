# Contributing

Everyone is welcome to contribute to this project. Contributing does not just mean submitting pull requests. There
are many different ways for you to get involved, including participating in discussions, reporting or triaging bugs, and
contributing code.

No matter how you want to get involved, please first learn what is expected of anyone who participates in this project.
If you are contributing code, you should also be comfortable writing Swift and working with Swift Package Manager.

By submitting a pull request, you represent that you have the right to license your contribution and agree that it is
licensed under the terms described in `LICENSE.md`.

## Reporting Bugs

Reporting bugs is a great way for anyone to help improve the project. This open source project uses GitHub issues
for tracking bugs.

When opening an issue, please use the bug report issue template and include the following:

- **A concise description of the problem.** Describe the behavior you were expecting to see, along with the behavior you
  actually observed.

- **A reproducible test case.** Double-check that your test case reproduces the issue. A relatively small sample
  (roughly within 50 lines of code) is best pasted directly into the description. Consider reducing the sample to the
  smallest amount of code; a smaller test case is easier to reason about and more appealing to contributors.

- **A description of the environment that reproduces the problem.** Include information about the Swift version,
  platform and platform version, deployment target if explicitly set, package tag, branch, or commit, and Xcode version
  if relevant.

Security vulnerabilities should not be reported through public issues. Follow the instructions in `SECURITY.md` instead.

## Triaging Bugs

Reporting bugs is an important part of improving software. Nearly as important is triaging those bugs to ensure that
they are reproducible, small, and unique.

There are a number of things you can do to help triage bugs in the repository's Issues page.

- **Reproduce bugs.** For a bug to be actionable, it needs to be reproducible. If you cannot reproduce the bug, try to
  figure out why. Get in touch with the submitter if you need more information.

- **Reduce bugs.** Once a bug can be reproduced, reduce it to the smallest amount of code possible. Reasoning about a
  sample that reproduces a bug in just a few lines of code is easier than reasoning about a longer sample.

- **Eliminate duplicate bugs.** If two bug reports refer to the same underlying problem, leave a comment linking them
  together. Doing so allows others to work more effectively.

## Planning Changes

### Issues

Substantial code changes should normally start with an issue so the problem, design, and scope can be discussed before
implementation begins.

Use public intake templates to report unrefined ideas and problems:

- Use **Request a feature** to propose a capability or improvement for consideration.
- Use **Report a bug** to provide reproducible incorrect or unexpected behavior.
- Use **Request documentation** to propose new documentation or an improvement to existing documentation.

After triage, maintainers should use **Plan a task** for accepted work that is ready for delivery, whether it originated
from a public request or was identified internally. Planned tasks describe intent: the overview explains why the work
matters, the acceptance criteria define what must be delivered, and the testing scenarios define how the expected
behavior will be verified.

#### Acceptance Criteria

Acceptance criteria define the observable outcomes, capabilities, and constraints that must be satisfied before an issue
can be closed. They should describe what must be delivered without prescribing implementation details unless those
details are intentional requirements.

#### Testing Scenarios

Testing scenarios define the representative behaviors, boundaries, failure conditions, and edge cases used to verify the
acceptance criteria. A scenario may be verified manually or through an automated test. A single scenario may require
multiple test functions to separate successful behavior, failure behavior, edge cases, or rule-specific behavior. One
parameterized test function may also exercise many cases within the same scenario.

In Swift Testing, a scenario often corresponds to an `@Test` function while its test cases are the values supplied
through `arguments`. This is a useful mapping, not a structural requirement; organize scenarios according to behavior
rather than the testing framework.

Do not duplicate every test case in an issue unless each case represents a distinct requirement or risk. When examples
make a scenario easier to refine or verify, add them as a nested list beneath the scenario. Use nested checkboxes only
when each case must be verified independently.

For example, document a testing scenario and its cases as follows:

```text
- [ ] Prevent form submission when required information is invalid.
  - A required value is missing.
  - A value uses an unsupported format.
    - An email address is malformed.
    - A date does not use the expected format.
  - Text length is outside the allowed range.
    - Character count is below the minimum.
    - Character count exceeds the maximum.
```

#### Sub-Issues

Use native GitHub sub-issues when a unit of work can be owned, reviewed, deferred, or closed independently. Keep closely
related code, tests, and documentation in one planned task when they are developed together.

#### Issue Metadata

Use GitHub's structured fields instead of repeating metadata in the issue description. Complete or update the fields as
information becomes available during triage, refinement, scheduling, and implementation:

- Assign the person responsible for the issue when ownership is known.
- Set the issue type to **Bug**, **Feature**, or **Task**.
- Set the priority to **Urgent**, **High**, **Medium**, or **Low**.
- Add optional start and target dates when the work is scheduled.
- Set the effort to **High**, **Medium**, or **Low** when it can be estimated.
- Assign the issue to a milestone when it is included in a release.
- Add parent, blocked-by, blocking, and related-to relationships when they apply.
- Link the development branch when implementation begins.

Use short, imperative issue titles that start with a verb. Issue titles should describe the work in human language;
branch names should describe the route. For example, an issue titled `Add DocC documentation` could use the branch
`docs/add-docc-documentation`.

Use sentence case for issue titles. Capitalize proper nouns, acronyms, and API names such as `DocC`, `UInt4`, `Roman`,
and `Swift Testing`.

Release issues should use the form:

```text
Prepare <semantic version> release
```

### Milestones

Normally, create and refine issues before assigning them to a release. Once the scope of a release begins to take shape,
create a milestone using the semantic version of that release:

```text
<major>.<minor>.<patch>
```

Create one release issue, assign it and every issue included in the release to the milestone, and make those issues
sub-issues of the release issue. The release issue should summarize the included outcomes and other release-wide work in
a high-level checklist without duplicating the detailed acceptance criteria or testing scenarios tracked by its
sub-issues.

## Implementing Changes

### Branches

Branch names should follow [Conventional Branch](https://conventionalbranch.org/).

Use lowercase branch names with hyphen-separated words in the form:

```text
<type>/<short-description>
```

The `main` branch is protected and represents the released package history. Release branches are also protected and
should use the form:

```text
release/<semantic version>
```

Use `feature`, `bugfix`, `chore`, `docs`, or `test` branches for regular work. These branches should be merged into a
release branch. Use `hotfix` branches only for urgent fixes that need to be merged directly into `main`.

Delete short-lived branches after they are merged.

Allowed pull request routes are:

- `release/*` or `hotfix/*` into `main`.
- `feature/*`, `bugfix/*`, `chore/*`, `docs/*`, or `test/*` into `release/*`.

### Project Files

#### File Names

Name Swift source files using UpperCamelCase. When a file defines a type or protocol, or contains extensions of one, its
name should match the declaration being defined or extended. For example, `Fraction.swift` defines `Fraction`, while
`BinaryInteger.swift` extends `BinaryInteger`.

Keep each top-level type or protocol declaration in its own source file. Extensions of the same declaration may remain
in that file when appropriate, but supporting types and protocols should use separate files. Apply the same convention
to test files by matching each filename to its test suite.

#### File Headers

The license and copyright protections for the project are called out at the top of every source code file. When adding
a source file, copy the current header from a neighboring file. When adapting this guide for a repository, replace each
placeholder in the following template with that repository's values.

For Swift source files the code header should look like this:

```swift
// This source file is part of the <project name> open source project
//
// Copyright (c) <start year>-<current year> <copyright holder> and the <project name> project authors
// Licensed under <license type>
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of <project name> project authors
```

`Package.swift` must keep the Swift tools version declaration as the first line.

### Source Code

Read and follow [Coding Style](CODING_STYLE.md) for source code, tests, documentation, and configuration files. It
documents the repository's coding conventions and every rule configured in `.swift-format`.

#### Formatting Tools

Use the Swift Format lint plugin to report formatting issues without changing source files:

```text
swift package plugin lint-source-code
```

The plugin is also available from Xcode's package commands. Formatting remains an explicit action; the repository does
not automatically format files when they are saved or committed. When you intend to apply the configured formatting to
the package's source targets, run the Format Source Code package command in Xcode or use:

```text
swift package plugin --allow-writing-to-package-directory format-source-code
```

The `.swift-format` file at the package root is the authoritative automated formatting configuration.

### Tests

Behavior changes should include tests. New tests should use Swift Testing. Do not add new XCTest suites. Prefer focused
Swift Testing suites that match the existing project structure.

When adding argument-based tests, keep the existing conventions in mind:

- Use small, readable values.
- Keep related examples aligned where possible.
- Put boundary values, failure conditions, and other exceptional inputs in focused tests.
- Prefer explicit expected results over deriving expectations from the implementation being tested.
- Compare Boolean properties and function results explicitly with `true`, `false`, or an argument-provided expected
  result.

### Docs

Document new and changed public APIs and user-facing behavior as part of the same change. Use documentation comments for
APIs and the DocC catalog for concepts, tutorials, and guides. Follow [Coding Style](CODING_STYLE.md) for
documentation structure, formatting, and examples.

### Commits

Commit messages should follow [Conventional Commits](https://www.conventionalcommits.org/).

Use the form:

```text
<type>[optional scope]: <description>
```

When a scope is included, enclose it in parentheses. Append `!` after the type or scope to indicate a breaking change.

Allowed types are `fix`, `feat`, `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, and `test`.

## Submitting Changes

### Pull Requests

When creating a pull request, use the pull request template. Briefly explain its outcome in the Overview section and
summarize reviewer-relevant additions, updates, and removals in the Changes section without restating the issue or
describing line-by-line implementation details.

Use the Conventional Commit form described above for the pull request title:

```text
<type>[optional scope]: <description>
```

Link the pull request to its issue in GitHub.

Each issue included in a release should normally have its own pull request into the release branch. If work is already
present without a dedicated pull request, create or update the issue to document the delivered outcome, assign it to the
appropriate milestone and parent release issue when applicable, and close it once the outcome has been confirmed. Do not
create a retrospective pull request solely to reproduce a relationship that did not exist during implementation.

Once the release checklist is complete and its sub-issues are closed, open a pull request from the release branch into
`main` and link it to the release issue.

### Workflows

Configured workflows run automatically for pull requests and publish their checks on the pull request. Review their
results, address reported failures, and ensure every required check passes before merging.

### Rule Sets

Repository rule sets protect the main and release branches, enforce the allowed pull request routes, and require
applicable checks and review conversations to be resolved before a pull request can be merged. In exceptional cases
where a requirement cannot reasonably be satisfied, contact a repository administrator. Administrators may override a
rule set when necessary, but an override should not replace the normal review and validation process.

### Code Reviews

Pull requests are reviewed for correctness, maintainability, test coverage, documentation, and fit with the package
architecture. Code review is part of the contribution process, and requested changes are normal. A change may be
declined or redirected if it does not fit the project's goals.

### Attribution of Changes

Contributors are credited through the Git history. Contributors may also be listed in `CONTRIBUTORS.txt` when
appropriate.

## Releasing Changes

### Tags

Release versions should follow [Semantic Versioning](https://semver.org/).

Use the form:

```text
<major>.<minor>.<patch>
```

Create a version tag matching the release milestone after a release is merged into `main`. Create a version tag after a
hotfix is merged into `main`.
