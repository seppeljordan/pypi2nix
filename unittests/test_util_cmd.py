from pypi2nix.logger import Logger
from pypi2nix.utils import cmd


def test_consistent_output(logger: Logger):
    exit_code, output = cmd(["seq", "5"], logger=logger)
    assert output == "1\n2\n3\n4\n5\n"


def test_can_send_input(logger: Logger):
    exit_code, output = cmd(["cat", "-"], logger=logger, input="test_input")
    assert output == "test_input"
