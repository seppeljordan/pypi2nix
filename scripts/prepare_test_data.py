#!/usr/bin/env python
"This script prepares the test fixtures for the unittests of this package"

import os
import shutil
import subprocess

from scripts.build_wheel import build_wheel
from scripts.repository import ROOT

wheel_target_directory = ROOT / "unittests" / "data"
TEST_PACKAGES = ["setupcfg-package"]


def build_test_package(package_name: str) -> None:
    os.putenv("SOURCE_DATE_EPOCH", "315532800")
    package_name_with_underscores = package_name.replace("-", "_")
    package_dir = ROOT / "unittests" / "data" / package_name
    paths_to_delete = [
        f"{package_name_with_underscores}.egg-info",
        "dist",
        f"{package_name}.tar.gz",
    ]
    for path in paths_to_delete:
        shutil.rmtree(str(package_dir / "path"), ignore_errors=True)
    subprocess.run(["python", "setup.py", "sdist"], cwd=str(package_dir), check=True)
    shutil.copy(
        str(package_dir / "dist" / f"{package_name}-1.0.tar.gz"),
        str(wheel_target_directory),
    )
    shutil.move(
        str(package_dir / "dist" / f"{package_name}-1.0.tar.gz"),
        str(package_dir / f"{package_name}.tar.gz"),
    )
    build_wheel(wheel_target_directory, str(package_dir))


def download_flit_wheel() -> None:
    build_wheel(wheel_target_directory, "flit==1.3")


if __name__ == "__main__":
    for test_package in TEST_PACKAGES:
        build_test_package(test_package)
    download_flit_wheel()
