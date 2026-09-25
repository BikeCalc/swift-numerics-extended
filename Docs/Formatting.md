# Formatting

Apply and validate a consistent coding style.

## Overview

The formatting workflow and command plugin check Swift source files using the package's Swift Format configuration.
Developers can also apply formatting explicitly. See [Coding Style](/Docs/CodingStyle.md) for the configuration, rules,
project conventions, and formatting exceptions.

## Requirements

Run commands from the repository root in a Git checkout with Swift 6.3 or later. Package resolution needs network access
when dependencies are not cached. CI uses macOS 26 and the formatter version selected by the package.

## Continuous Integration

The [Format workflow](/.github/workflows/format.yml) invokes the linter plugin for pushes to `main` and pull requests
targeting `main` or release branches. It uses the same package-pinned formatter and configuration as local development.

The workflow is informational: formatting findings do not fail the job. Build and execution failures do fail the
required `Lint Source Formatting` check.

## Command Plugin

Use the [NumericsExtendedLinterPlugin](/Plugins/NumericsExtendedLinterPlugin/NumericsExtendedLinterPlugin.swift) to
report formatting issues as warnings across the whole package without changing source files:

```shell
swift package plugin lint
```

The plugin is also available from Xcode's package commands and checks the whole package regardless of the target
selected in Xcode. Formatting remains an explicit action; the repository does not automatically format files when they
are saved or committed.

The linter uses Git to discover all tracked and nonignored untracked `.swift` files throughout the repository, including
scripts, plugins, and tutorial samples. Deleted files are skipped. Ignored untracked files, such as build outputs and
checked-out dependencies under `.build`, are excluded. Run the plugin from a Git checkout; new source directories are
included automatically.

To apply the configured formatting to the package's source targets, run the Format Source Code package command in Xcode
or use:

```shell
swift package plugin --allow-writing-to-package-directory format-source-code
```
