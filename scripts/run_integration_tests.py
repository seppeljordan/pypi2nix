#!/usr/bin/env python
import argparse
import shlex
import subprocess
from typing import List
from typing import Optional

from pypi2nix.path import Path
from scripts.repository import ROOT


def parse_args() -> Optional[Path]:
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", default=None)
    candidate: Optional[str] = parser.parse_args().file
    return None if candidate is None else Path(candidate)


def run_tests_from_files(paths: List[Path]) -> None:
    junit_output_path = ROOT / "build"
    junit_output_path.ensure_directory()
    junit_output_path /= "integration_tests.xml"
    command = ["pytest", "--junit-xml", str(junit_output_path), "-k", "TestCase"] + [
        str(path) for path in paths
    ]
    print("Executing test: ", " ".join(map(shlex.quote, command)))
    subprocess.run(command, check=True)


def main() -> None:
    files: List[Path]
    file = parse_args()
    if file:
        files = [file]
    else:
        files = [
            ROOT / "integrationtests" / name
            for name in (ROOT / "integrationtests").list_files()
            if name.filename().startswith("test_") and name.endswith(".py")
        ]
    run_tests_from_files(files)


if __name__ == "__main__":
    main()
