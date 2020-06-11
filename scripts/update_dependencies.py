#!/usr/bin/env python

import argparse
import subprocess

from repository import ROOT


def main() -> None:
    is_verbose: bool = parse_arguments()
    subprocess.run(
        [
            "pypi2nix",
            "-r",
            "requirements.txt",
            "-r",
            "requirements-dev.txt",
            "-s",
            "pytest-runner",
            "-s",
            "setupmeta",
            "--no-default-overrides",
            "-E",
            "openssl libffi",
        ]
        + (["-v"] if is_verbose else []),
        cwd=str(ROOT),
        check=True,
    )


def parse_arguments() -> bool:
    argument_parser = argparse.ArgumentParser(
        description="Update development dependencies of pypi2nix"
    )
    argument_parser.add_argument(
        "--verbose",
        "-v",
        help="Print debugging output",
        default=False,
        action="store_true",
    )
    args = argument_parser.parse_args()
    return True if args.verbose else False


if __name__ == "__main__":
    main()
