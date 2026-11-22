#!/usr/bin/env python3
"""Check deployment constraints on a disposable copy of the pinned upstream core."""

import argparse
import json
import platform
import shutil
import subprocess
from pathlib import Path


REVISION = "baef9ff4ad67f87082fa6aa8c5a1e154d1a284ac"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--upstream", type=Path, required=True)
    args = parser.parse_args()
    upstream = args.upstream.resolve()
    revision = subprocess.check_output(
        ["git", "-C", str(upstream), "rev-parse", "HEAD"], text=True
    ).strip()
    if revision != REVISION:
        parser.error("The upstream checkout must be at " + REVISION)
    if platform.system() != "Darwin":
        parser.error("Apple deployment checks require macOS and an installed Apple SDK")

    output = Path(__file__).resolve().parent / ".build" / "compatibility-checks"
    output.mkdir(parents=True, exist_ok=True)
    cache = output / "module-cache"
    cache.mkdir(exist_ok=True)
    results = []
    cases = [("guarded-macos13", "13.0", None),
             ("lowered-macos15", "15.0", "@available(macOS 15.0, *)"),
             ("lowered-macos13", "13.0", "@available(macOS 13.0, *)")]
    for name, version, replacement in cases:
        sources = output / name
        if sources.exists():
            shutil.rmtree(sources)
        sources.mkdir()
        for source in (upstream / "Sources" / "DecimalCore").glob("*.swift"):
            text = source.read_text()
            if replacement is not None:
                text = text.replace("@available(anyAppleOS 26.0, *)", replacement)
            (sources / source.name).write_text(text)
        command = ["xcrun", "swiftc", "-typecheck", "-module-name", "DecimalCore",
                   "-target", platform.machine() + "-apple-macosx" + version,
                   "-module-cache-path", str(cache)]
        paths = sorted(sources.glob("*.swift"),
                       key=lambda path: (path.name != "Decimal128+Conversions.swift", path.name))
        command.extend(str(path) for path in paths)
        result = subprocess.run(command, text=True, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, check=False)
        (output / (name + ".log")).write_text(result.stdout)
        messages = sorted({line.split("error:", 1)[1].strip()
                           for line in result.stdout.splitlines() if "error:" in line})
        results.append({"case": name, "exit_code": result.returncode, "errors": messages})
        print(name + ": " + ("passed" if result.returncode == 0 else "rejected"))
        for message in messages[:6]:
            print("  " + message)
    (output / "summary.json").write_text(json.dumps(results, indent=2) + "\n")
    expected = (results[0]["exit_code"] == 0
                and all(result["exit_code"] != 0 for result in results[1:]))
    if not expected:
        raise SystemExit("Unexpected result; inspect " + str(output))
    print("Observed the expected guarded success and rejected annotation-only backports.")


if __name__ == "__main__":
    main()
