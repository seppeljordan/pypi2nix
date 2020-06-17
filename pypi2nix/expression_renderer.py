import os
import shlex
import sys
from abc import ABCMeta
from abc import abstractmethod
from typing import Dict
from typing import Iterable
from typing import List

import jinja2

from pypi2nix.logger import Logger
from pypi2nix.nix_language import escape_string
from pypi2nix.overrides import Overrides
from pypi2nix.path import Path
from pypi2nix.python_version import PythonVersion
from pypi2nix.sources import Sources
from pypi2nix.target_platform import TargetPlatform
from pypi2nix.version import pypi2nix_version
from pypi2nix.wheel import Wheel

HERE = os.path.dirname(__file__)
TEMPLATES = jinja2.Environment(loader=jinja2.FileSystemLoader(HERE + "/templates"))


class ExpressionRenderer(metaclass=ABCMeta):
    @abstractmethod
    def render_expression(
        self, packages_metadata: Iterable[Wheel], sources: Sources,
    ) -> None:
        pass


class FlakeRenderer(ExpressionRenderer):
    def __init__(
        self,
        target_path: Path,
        target_platform: TargetPlatform,
        logger: Logger,
        extra_build_inputs: List[str],
        overrides: Iterable[Overrides] = [],
    ) -> None:
        self._target_path = target_path
        self._extra_build_inputs = extra_build_inputs
        self._target_platform = target_platform
        self._overrides = overrides
        self._logger = logger

    def render_expression(
        self, packages_metadata: Iterable[Wheel], sources: Sources,
    ) -> None:
        context = {
            "extra_build_inputs": " ".join(self._extra_build_inputs),
            "packages": [
                {
                    "name": wheel.name,
                    "version": wheel.version,
                    "license": wheel.license,
                    "description": wheel.description,
                    "fetch_expression": sources[wheel.name].nix_expression(),
                    "format": wheel.package_format,
                    "build_dependencies": [
                        dependency.name()
                        for dependency in wheel.build_dependencies(
                            self._target_platform
                        )
                    ],
                    "common_overrides": "\n".join(
                        [
                            "    (" + override.nix_expression(self._logger) + ")"
                            for override in self._overrides
                        ]
                    ),
                    "runtime_dependencies": [
                        dependency.name()
                        for dependency in wheel.runtime_dependencies(
                            self._target_platform
                        )
                    ],
                }
                for wheel in packages_metadata
            ],
        }
        flake_template = TEMPLATES.get_template("flake.nix.j2")
        flake_content: str = flake_template.render(**context)
        self._target_path.write_text(flake_content)
        self._render_overrides_file()

    def _render_overrides_file(self) -> None:
        overrides_path = (
            self._target_path.directory_name() / "requirements_override.nix"
        )
        if not overrides_path.exists():
            overrides = TEMPLATES.get_template("overrides.nix.j2").render()
            overrides_path.write_text(overrides)


class RequirementsRenderer(ExpressionRenderer):
    def __init__(
        self,
        requirements_name: str,
        extra_build_inputs: Iterable[str],
        python_version: PythonVersion,
        target_directory: str,
        logger: Logger,
        target_platform: TargetPlatform,
        requirements_frozen: str,
        common_overrides: Iterable[Overrides] = [],
    ):
        self._requirements_name = requirements_name
        self._extra_build_inputs = extra_build_inputs
        self._python_version = python_version
        self._target_directory = target_directory
        self._logger = logger
        self._target_platform = target_platform
        self._common_overrides = common_overrides
        self._frozen_file = os.path.join(
            self._target_directory, f"{requirements_name}_frozen.txt"
        )
        self._requirements_frozen = requirements_frozen

    def render_expression(
        self, packages_metadata: Iterable[Wheel], sources: Sources,
    ) -> None:
        """Create Nix expressions.
        """

        default_file = os.path.join(
            self._target_directory, f"{self._requirements_name}.nix"
        )
        overrides_file = os.path.join(
            self._target_directory, f"{self._requirements_name}_override.nix"
        )
        metadata_by_name: Dict[str, Wheel] = {x.name: x for x in packages_metadata}

        generated_packages_metadata = []
        for item in sorted(packages_metadata, key=lambda x: x.name):
            if item.build_dependencies:
                buildInputs = "\n".join(
                    sorted(
                        [
                            '        self."{}"'.format(dependency.name())
                            for dependency in item.build_dependencies(
                                self._target_platform
                            )
                        ]
                    )
                )
                buildInputs = "[\n" + buildInputs + "\n      ]"
            else:
                buildInputs = "[ ]"
            propagatedBuildInputs = "[ ]"
            dependencies = item.dependencies(extras=[])
            if dependencies:
                deps = [
                    x.name()
                    for x in dependencies
                    if x.name() in metadata_by_name.keys()
                ]
                if deps:
                    propagatedBuildInputs = "[\n%s\n      ]" % (
                        "\n".join(
                            sorted(
                                [
                                    '        self."%s"' % (metadata_by_name[x].name)
                                    for x in deps
                                    if x != item.name
                                ]
                            )
                        )
                    )
            source = sources[item.name]
            fetch_expression = source.nix_expression()
            package_format = item.package_format
            generated_packages_metadata.append(
                dict(
                    name=item.name,
                    version=item.version,
                    fetch_expression=fetch_expression,
                    buildInputs=buildInputs,
                    propagatedBuildInputs=propagatedBuildInputs,
                    homepage=item.homepage,
                    license=item.license,
                    description=escape_string(item.description),
                    package_format=package_format,
                )
            )

        generated_template = TEMPLATES.get_template("generated.nix.j2")
        generated = "\n\n".join(
            generated_template.render(**x) for x in generated_packages_metadata
        )

        overrides = TEMPLATES.get_template("overrides.nix.j2").render()

        common_overrides_expressions = [
            "    (" + override.nix_expression(self._logger) + ")"
            for override in self._common_overrides
        ]

        default_template = TEMPLATES.get_template("requirements.nix.j2")
        overrides_file_nix_path = os.path.join(".", os.path.split(overrides_file)[1])
        default = default_template.render(
            version=pypi2nix_version,
            command_arguments=" ".join(map(shlex.quote, sys.argv[1:])),
            python_version=self._python_version.derivation_name(),
            extra_build_inputs=(
                self._extra_build_inputs
                and "with pkgs; [ %s ]" % (" ".join(self._extra_build_inputs))
                or "[]"
            ),
            overrides_file=overrides_file_nix_path,
            enable_tests="false",
            generated_package_nix=generated,
            common_overrides="\n".join(common_overrides_expressions),
            python_major_version=self._python_version.major_version(),
        )

        if not os.path.exists(overrides_file):
            with open(overrides_file, "w+") as f:
                f.write(overrides.strip())
                self._logger.info("|-> writing %s" % overrides_file)

        with open(default_file, "w+") as f:
            f.write(default.strip())
        with open(self._frozen_file, "w+") as f:
            f.write(self._requirements_frozen)
