from typing import Any

import pytest

from pypi2nix.expression_renderer import FlakeRenderer
from pypi2nix.logger import Logger
from pypi2nix.nix import Nix
from pypi2nix.path import Path
from pypi2nix.sources import Sources
from pypi2nix.target_platform import TargetPlatform
from unittests.package_generator import PackageGenerator


def test_flake_renderer_creates_flake_nix_file(
    flake_renderer: FlakeRenderer, flake_path: Path
):
    flake_renderer.render_expression(
        packages_metadata=[], sources=Sources(),
    )
    assert flake_path.is_file()


def test_flake_can_be_built(
    flake_renderer: FlakeRenderer, result_path: Path, flake_directory: Path, nix: Nix
):
    flake_renderer.render_expression(
        packages_metadata=[], sources=Sources(),
    )
    nix.build_flake(flake_directory, out_link=result_path)
    assert (result_path / "bin" / "python").exists()


def test_flake_with_packages_can_be_built(
    flake_renderer: FlakeRenderer,
    build_wheels,
    package_generator: PackageGenerator,
    generated_sources: Sources,
    result_path: Path,
    nix: Nix,
    flake_directory: Path,
) -> None:
    package_generator.generate_setuptools_package(name="package1")
    wheels = build_wheels(["package1"])
    flake_renderer.render_expression(
        packages_metadata=wheels, sources=generated_sources,
    )
    nix.build_flake(flake_directory, out_link=result_path)
    assert (result_path / "bin" / "python").exists()


@pytest.fixture
def flake_path(flake_directory: Path) -> Path:
    return flake_directory / "flake.nix"


@pytest.fixture
def flake_directory(tmpdir_factory: Any) -> Path:
    path_as_str: str = str(tmpdir_factory.mktemp("flake_path"))
    return Path(path_as_str)


@pytest.fixture
def result_path(tmpdir_factory: Any) -> Path:
    path_as_str: str = str(tmpdir_factory.mktemp("result_path"))
    return Path(path_as_str) / "result"


@pytest.fixture
def flake_renderer(
    flake_path: Path, current_platform: TargetPlatform, logger: Logger
) -> FlakeRenderer:
    return FlakeRenderer(
        target_path=flake_path,
        target_platform=current_platform,
        logger=logger,
        extra_build_inputs=[],
    )
