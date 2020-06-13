#!/usr/bin/env python

import os
import os.path
import subprocess
import sys
from typing import List

from pypi2nix.logger import Logger
from pypi2nix.logger import StreamLogger
from scripts.repository import ROOT


class CodeFormatter:
    def __init__(self) -> None:
        self._logger = initialize_logger()

    def main(self) -> None:
        relative_paths = [
            "pypi2nix",
            "unittests",
            "integrationtests",
            "conftest.py",
            "setup.py",
            "mypy",
            "scripts",
        ]
        self.format_nix_files()
        absolute_paths: List[str] = [
            str(ROOT / relative) for relative in relative_paths
        ]
        self._logger.info("Running isort")
        subprocess.run(["isort", "-rc", "."], check=True)
        self._logger.info("Running black")
        subprocess.run(["black"] + absolute_paths, check=True)
        self.run_check_process("flake8")
        self.run_check_process("mypy")

    def run_check_process(self, executable: str, arguments: List[str] = []) -> None:
        self._logger.info(f"Running {executable}")
        try:
            subprocess.run([executable] + arguments, check=True)
        except subprocess.CalledProcessError:
            self._logger.error(f"{executable} failed, see errors above")
            exit(1)

    def format_nix_files(self) -> None:
        if is_nixfmt_installed():
            self._logger.info("Formatting nix files")
            integration_test_nix_files = find_nix_files_in_integration_tests()
            subprocess.run(
                ["nixfmt", "default.nix", "pypi2nix/pip/bootstrap.nix"]
                + integration_test_nix_files,
                check=True,
            )
        else:
            self._logger.warning(
                "Could not find `nixfmt` executable.  Cannot format .nix files"
            )


def find_nix_files_in_integration_tests() -> List[str]:
    found_files: List[str] = []
    for root, _, files in os.walk("integrationtests"):
        found_files += [
            os.path.join(root, file) for file in files if file.endswith(".nix")
        ]
    return found_files


def initialize_logger() -> Logger:
    return StreamLogger(output=sys.stdout)


def is_nixfmt_installed() -> bool:
    process_result = subprocess.run("nixfmt --version", shell=True, capture_output=True)
    return process_result.returncode == 0


if __name__ == "__main__":
    CodeFormatter().main()
