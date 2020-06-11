import os
import os.path
import shlex
import shutil
import subprocess
import sys
from typing import Dict
from typing import List
from typing import Optional
from unittest import TestCase

import yaml
from attr import attrib
from attr import attrs
from attr import evolve

from pypi2nix.dependency_graph import DependencyGraph
from pypi2nix.logger import StreamLogger
from pypi2nix.memoize import memoize
from pypi2nix.nix import EvaluationFailed
from pypi2nix.nix import Nix
from pypi2nix.requirement_parser import RequirementParser

HERE = os.path.dirname(__file__)


class IntegrationTest(TestCase):
    """Methods to implement for a valid test case:

    name_of_testcase
    requirements

    optional:

    setup_requires() -- default: []
    executables_for_testing() -- default: []
    extra_environment() -- default: dict()
    external_dependencies
    requirements_file_check(content) -- default: (lambda content: None)
    constraints
    code_for_testing
    python_version
    code_for_testing_filename
    explicit_build_directory
    dependencyGraph -- default {}: yaml that will be used as input for pypi2nix

    check_dependency_graph(
        self,
        dependency_graph: DependencyGraph,
        requirement_parser: RequirementParser
    ):
        Override this function in your test case to perform checks on the
        dependency graph information that pypi2nix renders.  You can use
        the requirement_parser supplied though the method argument to
        generate Requirement objects. For example::
            django = requirement_parser.parse('django')
            pytz = requirement_parser.parse('pytz')

        If we wanted to check that pypi2nix detected the dependency of django
        on the pytz package than we could do it the following way:
            self.assertTrue(
                dependency_graph.is_runtime_dependency(
                    dependent=django,
                    dependency=pytz,
                )
            )
    """

    def setUp(self) -> None:
        self.logger = StreamLogger(output=sys.stdout)
        self.nix = Nix(logger=self.logger)
        self.assertNotEqual(self.name_of_testcase, "undefined")
        self.requirement_parser = RequirementParser(self.logger)

    def test_build_example(self) -> None:
        self.build_pypi2nix()
        self.generate_requirements_file()
        self.build_nix_expression()
        self.check_requirements_file_content()
        self.run_expression_tests()
        self.run_dependency_graph_tests()

    def build_pypi2nix(self) -> None:
        print("Build pypi2nix executable")
        try:
            self.nix.build(
                os.path.join(os.path.dirname(HERE), "default.nix"),
                out_link=os.path.join(HERE, "pypi2nix"),
            )
        except EvaluationFailed:
            self.fail("Could not build pypi2nix executable")

    def generate_requirements_file(self) -> None:
        print("Generate requirements.txt")
        requirements_file_content = self.generate_requirements_file_content()
        self.write_requirements_file(requirements_file_content)

    def build_nix_expression(self) -> None:
        print("Build nix expression")
        if self.explicit_build_directory:
            self.prepare_build_directory()
        process = subprocess.Popen(
            self.build_nix_expression_command(),
            cwd=self.example_directory(),
            env=self.nix_build_env(),
            stdin=subprocess.DEVNULL,
        )
        process.communicate()
        if process.returncode != 0:
            self.fail(
                "Could not build nix expression for {testname}".format(
                    testname=self.name_of_testcase
                )
            )

    def build_nix_expression_command(self) -> List[str]:
        command = [
            os.path.join(HERE, "pypi2nix", "bin", "pypi2nix"),
            "-vvv",
            "-V",
            self.python_version,
            "-r",
            "requirements.txt",
            "--default-overrides",
            "--dependency-graph-input",
            self.rendered_dependency_graph(),
            "--dependency-graph-output",
            self._dependency_graph_output_path(),
        ]
        for requirement in self.setup_requires():
            command.append("-s")
            command.append(requirement)
        for variable_name, value in self.extra_environment().items():
            command.append("-N")
            command.append("{name}={value}".format(name=variable_name, value=value))
        for dependency in self.external_dependencies:
            command.append("-E")
            command.append(dependency)
        if self.explicit_build_directory:
            command.append("--build-directory")
            command.append(self.build_directory())
        return command

    def setup_requires(self) -> List[str]:
        return []

    def check_requirements_file_content(self) -> None:
        requirements_file_content = self.read_requirements_file_contents()
        self.requirements_file_check(requirements_file_content)

    def run_expression_tests(self) -> None:
        self.build_interpreter_from_generated_expression()
        self.build_additional_attributes()
        self.run_interpreter_with_test_code()
        self.run_executable_tests()

    def run_dependency_graph_tests(self) -> None:
        dependency_graph = self._read_dependency_graph()
        self.check_dependency_graph(dependency_graph, self.requirement_parser)

    def build_interpreter_from_generated_expression(self) -> None:
        print("Build python interpreter from generated expression")
        try:
            self.nix.build(
                os.path.join(self.example_directory(), "requirements.nix"),
                attribute="interpreter",
                out_link=os.path.join(self.example_directory(), "result"),
            )
        except EvaluationFailed:
            self.fail(
                "Failed to build python interpreter from nix expression generated"
            )

    def build_additional_attributes(self) -> None:
        for additional_path in self.additional_paths_to_build:
            try:
                self.nix.evaluate_file(
                    os.path.join(self.example_directory(), "requirements.nix"),
                    attribute=additional_path,
                )
            except EvaluationFailed:
                self.fail(f"Failed to build attribute path {additional_path}")

    def run_interpreter_with_test_code(self) -> None:
        if self.code_for_testing_string():
            test_code = self.code_for_testing_string()
            self.run_interpreter_with_test_code_from_result(test_code)
            self.run_interpreter_with_test_code_in_nix_shell(test_code)

    def run_interpreter_with_test_code_from_result(self, test_code: str) -> None:
        print("Run generated interpreter with test code")
        process = subprocess.Popen(
            [os.path.join(self.example_directory(), "result", "bin", "python")],
            stdin=subprocess.PIPE,
        )
        process.communicate(input=test_code.encode())
        if process.returncode != 0:
            self.fail("Executation of test code failed")

    def run_interpreter_with_test_code_in_nix_shell(self, test_code: str) -> None:
        print("Execute test code in nix-shell")
        try:
            self.nix.run_nix_command(
                "nix-shell",
                [
                    os.path.join(self.example_directory(), "requirements.nix"),
                    "-A",
                    "interpreter",
                    "--command",
                    "python",
                    "--show-trace",
                ],
                input=test_code,
            )
        except EvaluationFailed:
            self.fail("Executation of test code in nix-shell failed")

    def read_requirements_file_contents(self) -> str:
        with open(os.path.join(self.example_directory(), "requirements.nix")) as f:
            return f.read()

    def code_for_testing_string(self) -> str:
        if self.code_for_testing and self.code_for_testing_filename:
            self.fail(
                "Cannot set `both code_for_testing` and `code_for_testing_filename`."
            )
        if self.code_for_testing:
            return "\n".join(self.code_for_testing)
        elif self.code_for_testing_filename:
            with open(
                os.path.join(self.example_directory(), self.code_for_testing_filename)
            ) as f:
                return f.read()
        else:
            return ""

    code_for_testing: List[str] = []
    code_for_testing_filename: Optional[str] = None

    def extra_environment(self) -> Dict[str, str]:
        return dict()

    def run_executable_tests(self) -> None:
        for test_command in self.executables_for_testing():
            self.run_test_command_from_build_output(test_command)

    def run_test_command_from_build_output(self, test_command: "TestCommand") -> None:
        prepared_test_command = evolve(
            test_command,
            command=["./" + test_command.command[0]] + test_command.command[1:],
        )
        print("Run {command}".format(command=prepared_test_command))
        process = subprocess.Popen(
            prepared_test_command.command,
            cwd=os.path.join(self.example_directory(), "result", "bin"),
            env=dict(self.nix_build_env(), **prepared_test_command.env),
        )
        process.communicate()
        print()  # for empty line after command output
        if process.returncode != 0:
            self.fail(
                "Tested executable `{command}` returned non-zero exitcode.".format(
                    command=test_command
                )
            )

    def executables_for_testing(self) -> List["TestCommand"]:
        return []

    def nix_build_env(self) -> Dict[str, str]:
        environment_variables = dict(os.environ)
        del environment_variables["PYTHONPATH"]
        return environment_variables

    def generate_requirements_file_content(self) -> str:
        self.generate_constraints_txt()
        requirements_txt_extra_content = ["-c " + self.constraints_txt_path()]
        return "\n".join(self.requirements + requirements_txt_extra_content)

    def generate_constraints_txt(self) -> None:
        with open(self.constraints_txt_path(), "w") as f:
            f.write("\n".join(self._constraints()))

    def constraints_txt_path(self) -> str:
        return os.path.join(self.example_directory(), "constraints.txt")

    def write_requirements_file(self, content: str) -> None:
        os.makedirs(os.path.dirname(self.requirements_file_path()), exist_ok=True)
        with open(self.requirements_file_path(), "w") as f:
            f.write(content)

    def requirements_file_path(self) -> str:
        return os.path.join(self.example_directory(), "requirements.txt")

    def example_directory(self) -> str:
        return os.path.join(HERE, self.name_of_testcase)

    def requirements_file_check(self, _: str) -> None:
        pass

    def _dependency_graph_output_path(self) -> str:
        return os.path.join(self.example_directory(), "dependency-graph.yml")

    def build_directory(self):
        return os.path.join(self.example_directory(), "build")

    def prepare_build_directory(self):
        if os.path.exists(self.build_directory()):
            shutil.rmtree(self.build_directory())
        os.makedirs(self.build_directory())

    def check_dependency_graph(
        self, dependency_graph: DependencyGraph, requirement_parser: RequirementParser
    ):
        pass

    def _read_dependency_graph(self) -> DependencyGraph:
        with open(self._dependency_graph_output_path()) as f:
            return DependencyGraph.deserialize(f.read())

    def _constraints(self) -> List[str]:
        return self.constraints + self._read_global_constraints()

    def _read_global_constraints(self) -> List[str]:
        global_constraints_path = os.path.join(
            os.path.dirname(self.example_directory()), "constraints.txt"
        )
        with open(global_constraints_path) as f:
            content = f.read()
        return content.splitlines()

    constraints: List[str] = []
    python_version: str = "python3"
    requirements: List[str] = []
    name_of_testcase: str = "undefined"
    external_dependencies: List[str] = []
    explicit_build_directory: bool = False
    additional_paths_to_build: List[str] = []
    dependency_graph: Dict[str, Dict[str, List[str]]] = {}

    @memoize
    def rendered_dependency_graph(self) -> str:
        path = os.path.join(self.example_directory(), "dependency-input.yml")
        with open(path, "w") as f:
            yaml.dump(
                self.dependency_graph, f,
            )
        return path


@attrs
class TestCommand:
    command: List[str] = attrib()
    env: Dict[str, str] = attrib(default=dict())

    def unquoted_command(self) -> str:
        return " ".join(self.command)

    def quoted_command(self) -> str:
        return shlex.quote(self.unquoted_command())
