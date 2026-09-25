# Documentation

Build and publish the package documentation.

## Overview

The documentation build produces a DocC website for GitHub Pages. The same build script can generate the site locally
without publishing it. Generated files stay under `.build/` and are not committed.

## Requirements

Use Swift 6.3 or later with DocC available; CI uses macOS 26. Run commands from the repository root.

Package resolution needs network access when dependencies are not cached. Publishing requires GitHub Pages configured
for GitHub Actions; local generation does not require deployment permissions.

## Continuous Integration

The [Documentation workflow](/.github/workflows/documentation.yml) runs on pushes to `main` and manual dispatch. Its
`Deploy Documentation` job builds the site, configures GitHub Pages, uploads `.build/github-pages/`, and deploys that
artifact. The deployment URL appears in the `github-pages` environment. A failed build prevents deployment. A newer
Pages run cancels an older run in progress.

## Build Script

[BuildDocumentation.swift](/Scripts/BuildDocumentation.swift) generates the website:

```shell
swift Scripts/BuildDocumentation.swift
```

The script takes no arguments. It writes the site to `.build/github-pages/` and adds a landing-page redirect after a
successful build. Build or file-writing failures return a nonzero exit status. The script does not publish the site.

The script invokes the package's Swift-DocC command plugin with combined documentation enabled, the selected module
targets, and static hosting configured for this repository. The site root redirects to `documentation/`.

## Command Plugin

The `generate-documentation` command comes from the `swift-docc-plugin` dependency in [Package
Manifest](/Package.swift). The build script supplies the module list, output path, hosting base path, and permission to
write the generated site. Use the build script to reproduce the published configuration; building documentation directly
in Xcode may use a different target selection and hosting configuration.