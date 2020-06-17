import os
import os.path
import sys
from typing import List

from pypi2nix.configuration import ApplicationConfiguration
from pypi2nix.dependency_graph import DependencyGraph
from pypi2nix.expression_renderer import ExpressionRenderer
from pypi2nix.expression_renderer import FlakeRenderer
from pypi2nix.expression_renderer import RequirementsRenderer
from pypi2nix.external_dependencies import ExternalDependency
from pypi2nix.external_dependency_collector import ExternalDependencyCollector
from pypi2nix.external_dependency_collector import RequirementDependencyRetriever
from pypi2nix.logger import Logger
from pypi2nix.logger import StreamLogger
from pypi2nix.memoize import memoize
from pypi2nix.metadata_fetcher import MetadataFetcher
from pypi2nix.nix import Nix
from pypi2nix.path import Path
from pypi2nix.pip import NixPip
from pypi2nix.pypi import Pypi
from pypi2nix.requirement_parser import RequirementParser
from pypi2nix.requirements_collector import RequirementsCollector
from pypi2nix.sources import Sources
from pypi2nix.target_platform import PlatformGenerator
from pypi2nix.target_platform import TargetPlatform
from pypi2nix.version import pypi2nix_version
from pypi2nix.wheel_builder import WheelBuilder


class Pypi2nix:
    def __init__(self, configuration: ApplicationConfiguration) -> None:
        self.configuration = configuration

    def run(self) -> None:
        requirements = self.requirements_collector().requirements()
        self.logger().info("pypi2nix v{} running ...".format(pypi2nix_version))
        if not requirements:
            self.logger().info("No requirements were specified.  Ending program.")
            return

        setup_requirements = self.setup_requirements_collector().requirements()
        requirements_name = os.path.join(
            self.configuration.target_directory, self.configuration.output_basename
        )

        sources = Sources()
        sources.update(setup_requirements.sources())
        sources.update(requirements.sources())
        sources.update(self.setup_requirements_collector().sources())
        sources.update(self.requirements_collector().sources())

        self.logger().info("Downloading wheels and creating wheelhouse ...")

        pip = NixPip(
            nix=self.nix(),
            project_directory=self.configuration.project_directory,
            extra_env=self.configuration.extra_environment,
            extra_build_inputs=self._extra_build_inputs(),
            wheels_cache=self.configuration.wheels_caches,
            target_platform=self.target_platform(),
            logger=self.logger(),
            requirement_parser=self.requirement_parser(),
        )
        wheel_builder = WheelBuilder(
            pip=pip,
            download_directory=self.configuration.project_directory / "downloads",
            lib_directory=self.configuration.project_directory / "lib",
            extracted_wheel_directory=self.configuration.project_directory
            / "extracted-wheels",
            wheel_directory=self.configuration.project_directory / "wheels",
            logger=self.logger(),
            requirement_parser=self.requirement_parser(),
            target_platform=self.target_platform(),
            base_dependency_graph=self.base_dependency_graph(),
        )
        wheels = wheel_builder.build(
            requirements=requirements, setup_requirements=setup_requirements
        )
        requirements_frozen = wheel_builder.get_frozen_requirements()
        source_distributions = wheel_builder.source_distributions

        self.logger().info("Extracting metadata from pypi.python.org ...")

        metadata_fetcher = MetadataFetcher(
            sources=sources,
            logger=self.logger(),
            requirement_parser=self.requirement_parser(),
            pypi=Pypi(logger=self.logger()),
        )

        packages_metadata = metadata_fetcher.main(
            wheel_paths=wheels,
            target_platform=self.target_platform(),
            source_distributions=source_distributions,
        )
        self.logger().info("Generating Nix expressions ...")

        renderers: List[ExpressionRenderer] = []
        renderers.append(
            RequirementsRenderer(
                requirements_name=requirements_name,
                extra_build_inputs=self.extra_build_inputs(),
                python_version=self.configuration.python_version,
                target_directory=self.configuration.target_directory,
                logger=self.logger(),
                common_overrides=self.configuration.overrides,
                target_platform=self.target_platform(),
                requirements_frozen=requirements_frozen,
            )
        )
        renderers.append(
            FlakeRenderer(
                target_path=Path(self.configuration.target_directory) / "flake.nix",
                target_platform=self.target_platform(),
                logger=self.logger(),
                overrides=self.configuration.overrides,
                extra_build_inputs=self.extra_build_inputs(),
            )
        )
        for renderer in renderers:
            renderer.render_expression(
                packages_metadata=packages_metadata, sources=sources,
            )

        if self.configuration.dependency_graph_output_location:
            dependency_graph = DependencyGraph()
            for wheel in packages_metadata:
                dependency_graph.import_wheel(wheel, self.requirement_parser())
            with open(
                str(self.configuration.dependency_graph_output_location), "w"
            ) as output_file:
                output_file.write(dependency_graph.serialize())
        self.print_user_information()

    @memoize
    def extra_build_inputs(self) -> List[str]:
        return (
            self.configuration.extra_build_inputs
            if self.configuration.emit_extra_build_inputs
            else []
        )

    def print_user_information(self) -> None:
        self.logger().info(
            "\n".join(
                [
                    "",
                    "Nix expressions generated successfully.",
                    "",
                    "To start development run:",
                    "    nix-shell requirements.nix -A interpreter",
                    "",
                    "More information you can find at",
                    "    https://github.com/nix-community/pypi2nix",
                    "",
                ]
            )
        )

    @memoize
    def _extra_build_inputs(self) -> List[ExternalDependency]:
        retriever = RequirementDependencyRetriever()
        collector = ExternalDependencyCollector(
            requirement_dependency_retriever=retriever
        )
        for external_input in self.configuration.extra_build_inputs:
            collector.collect_explicit(external_input)
        return list(collector.get_collected())

    @memoize
    def requirements_collector(self) -> RequirementsCollector:
        requirement_collector = RequirementsCollector(
            self.target_platform(),
            self.requirement_parser(),
            self.logger(),
            str(self.configuration.project_directory),
            self.base_dependency_graph(),
        )
        for item in self.configuration.requirements:
            requirement_collector.add_line(item)
        for requirement_file_path in self.configuration.requirement_files:
            requirement_collector.add_file(requirement_file_path)
        return requirement_collector

    @memoize
    def setup_requirements_collector(self) -> RequirementsCollector:
        setup_requirement_collector = RequirementsCollector(
            self.target_platform(),
            self.requirement_parser(),
            self.logger(),
            str(self.configuration.project_directory),
            DependencyGraph(),
        )
        for build_input in self.configuration.setup_requirements:
            setup_requirement_collector.add_line(build_input)
        return setup_requirement_collector

    @memoize
    def requirement_parser(self) -> RequirementParser:
        return RequirementParser(self.logger())

    @memoize
    def target_platform(self) -> TargetPlatform:
        platform_generator = PlatformGenerator(nix=self.nix(), logger=self.logger())
        target_platform = platform_generator.from_python_version(
            self.configuration.python_version
        )
        return target_platform

    @memoize
    def nix(self) -> Nix:
        return Nix(
            nix_path=self.configuration.nix_path,
            executable_directory=self.configuration.nix_executable_directory,
            logger=self.logger(),
        )

    @memoize
    def logger(self) -> Logger:
        logger: Logger = StreamLogger(output=sys.stdout)
        logger.set_verbosity(self.configuration.verbosity)
        return logger

    @memoize
    def base_dependency_graph(self) -> DependencyGraph:
        return self.configuration.dependency_graph_input
