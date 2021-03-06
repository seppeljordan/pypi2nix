import shutil
import subprocess
from tempfile import TemporaryDirectory
from typing import Dict
from typing import List

from attr import attrib
from attr import attrs

from pypi2nix.archive import Archive
from pypi2nix.logger import Logger
from pypi2nix.package_source import PathSource
from pypi2nix.path import Path
from pypi2nix.requirement_parser import RequirementParser
from pypi2nix.source_distribution import SourceDistribution
from pypi2nix.sources import Sources

from .templates import render_template


@attrs
class PackageGenerator:
    """Generate source distributions on for testing

    This class aims to provide an easy to use way of generating test
    data.  Since pypi2nix deals a lot with python packages it is
    necessary have python packages available for testing.
    """

    _target_directory: Path = attrib()
    _requirement_parser: RequirementParser = attrib()
    _logger: Logger = attrib()
    _sources: Sources = attrib()

    def generate_setuptools_package(
        self,
        name: str,
        version: str = "1.0",
        install_requires: List[str] = [],
        extras_require: Dict[str, List[str]] = {},
    ) -> SourceDistribution:
        with TemporaryDirectory() as directory_path_string:
            build_directory: Path = Path(directory_path_string)
            self._generate_setup_py(build_directory, name=name, version=version)
            self._generate_setup_cfg(
                build_directory,
                name=name,
                version=version,
                install_requires=install_requires,
                extras_require=extras_require,
            )
            self._generate_python_module(
                build_directory, name=name,
            )
            built_distribution_archive = self._build_package(
                build_directory=build_directory, name=name, version=version
            )
            source_distribution = SourceDistribution.from_archive(
                built_distribution_archive,
                logger=self._logger,
                requirement_parser=self._requirement_parser,
            )
            self._move_package_target_directory(built_distribution_archive)
            self._sources.add(
                name=name,
                source=PathSource(path=str(self._get_distribution_path(name, version))),
            )
        return source_distribution

    def _generate_setup_py(
        self, target_directory: Path, name: str, version: str
    ) -> None:
        content = render_template(Path("setup.py"), context={},)
        (target_directory / "setup.py").write_text(content)

    def _generate_setup_cfg(
        self,
        target_directory: Path,
        name: str,
        version: str,
        install_requires: List[str],
        extras_require: Dict[str, List[str]],
    ) -> None:
        content = render_template(
            Path("setup.cfg"),
            context={
                "name": name,
                "version": version,
                "install_requires": install_requires,
                "extras_require": extras_require,
            },
        )
        (target_directory / "setup.cfg").write_text(content)

    def _generate_python_module(self, target_directory: Path, name: str,) -> None:
        (target_directory / f"{name}.py").write_text("")

    def _build_package(self, build_directory: Path, name: str, version: str) -> Archive:
        subprocess.run(
            ["python", "setup.py", "sdist"], cwd=str(build_directory), check=True
        )
        tar_gz_path = build_directory / "dist" / f"{name}-{version}.tar.gz"
        return Archive(path=str(tar_gz_path))

    def _get_distribution_path(self, name, version):
        return self._target_directory / f"{name}-{version}.tar.gz"

    def _move_package_target_directory(self, distribution_archive: Archive) -> None:
        shutil.copy(distribution_archive.path, str(self._target_directory))
