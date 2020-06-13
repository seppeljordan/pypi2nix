#!/usr/bin/env python

import sys
from typing import List

from pypi2nix.logger import StreamLogger
from pypi2nix.pypi import Pypi
from pypi2nix.wheels import Index
from scripts.package_source import PackageSource
from scripts.repository import ROOT


def main() -> None:
    logger = StreamLogger(sys.stdout)
    pypi = Pypi(logger=logger)
    pip_requirements: List[str] = ["setuptools", "wheel", "pip"]
    git_requirements: List[str] = []
    index = Index(logger=logger, path=ROOT / "pypi2nix" / "wheels" / "index.json",)
    package_source = PackageSource(index=index, pypi=pypi, logger=logger)
    for requirement in pip_requirements:
        package_source.update_package_from_pip(requirement)
    for requirement in git_requirements:
        package_source.update_package_from_master(requirement)


if __name__ == "__main__":
    main()
