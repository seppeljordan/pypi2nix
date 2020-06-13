from .package_generator import PackageGenerator
from .switches import nix


@nix
def test_extracts_extras_require_if_extras_were_specified(
    build_wheels, package_generator: PackageGenerator
):
    package_generator.generate_setuptools_package(
        name="package3", extras_require={"myextra": ["package1"]}
    )
    package_generator.generate_setuptools_package(name="package1")
    wheels = build_wheels(["package3[myextra]"])
    assert [wheel for wheel in wheels if wheel.name == "package1"]


@nix
def test_does_not_pick_up_extras_require_if_no_extras_were_specified(
    build_wheels, package_generator: PackageGenerator
):
    package_generator.generate_setuptools_package(
        name="package3", extras_require={"myextra": ["package1"]}
    )
    package_generator.generate_setuptools_package(name="package1")
    wheels = build_wheels(["package3"])
    assert not [wheel for wheel in wheels if wheel.name == "package1"]


@nix
def test_does_detect_extras_requires_for_indirect_dependencies(
    build_wheels, package_generator: PackageGenerator
):
    package_generator.generate_setuptools_package(
        name="package4", install_requires=["package3[myextra]"]
    )
    package_generator.generate_setuptools_package(
        name="package3", extras_require={"myextra": ["package1"]}
    )
    package_generator.generate_setuptools_package(name="package1")
    wheels = build_wheels(["package4"])
    assert [wheel for wheel in wheels if wheel.name == "package1"]


@nix
def test_that_we_ignore_extra_requirements_for_other_platforms(
    build_wheels, package_generator: PackageGenerator,
):
    package_generator.generate_setuptools_package(
        name="package3",
        extras_require={"other_platform": ['package2; python_version == "1.0"']},
    )
    package_generator.generate_setuptools_package(name="package2")
    wheels = build_wheels(["package3[other_platform]"])
    assert not [wheel for wheel in wheels if wheel.name == "package2"]
