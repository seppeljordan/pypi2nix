#!/usr/bin/env python
import argparse
import os
import shutil
import subprocess

from pypi2nix.version import pypi2nix_version


def main() -> None:
    set_up_environment()
    pypi_name = parse_args()
    remove_old_build_artifacts()
    deploy_to(pypi_name)


def set_up_environment() -> None:
    os.putenv("SOURCE_DATE_EPOCH", "315532800")


def parse_args() -> str:
    parser = argparse.ArgumentParser(description="Deploy pypi2nix to pypi")
    parser.add_argument("--production", action="store_true", default=False)
    args = parser.parse_args()
    return "pypi" if args.production else "test-pypi"


def remove_old_build_artifacts() -> None:
    shutil.rmtree("pypi2nix.egg-info", ignore_errors=True)


def deploy_to(pypi_name: str) -> None:
    subprocess.run(["python", "setup.py", "sdist", "bdist_wheel"], check=True)
    distribution_paths = [
        f"dist/pypi2nix-{pypi2nix_version}.tar.gz",
        f"dist/pypi2nix-{pypi2nix_version}-py3-none-any.whl",
    ]
    subprocess.run(
        ["twine", "upload", "-r", pypi_name] + distribution_paths, check=True
    )


if __name__ == "__main__":
    main()
