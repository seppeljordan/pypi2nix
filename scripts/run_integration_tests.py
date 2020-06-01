#!/usr/bin/env python

import argparse
import shlex
import subprocess

from repository import ROOT


def generator(iterable):
    yield from iterable


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", default=None)
    args = parser.parse_args()
    return args.file


def run_tests_from_file(path: str) -> None:
    command = ["python", "-m", "unittest", path, "-k", "TestCase"]
    print("Executing test: ", " ".join(map(shlex.quote, command)))
    subprocess.run(command, check=True)


def main():
    file = parse_args()
    if file:
        files = generator([file])
    else:
        files = (
            ROOT / "integrationtests" / name
            for name in (ROOT / "integrationtests").list_files()
            if name.filename().startswith("test_") and name.endswith(".py")
        )
    for path in files:
        run_tests_from_file(str(path))


if __name__ == "__main__":
    main()
