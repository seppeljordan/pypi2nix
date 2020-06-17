from pypi2nix.logger import Logger
from pypi2nix.path import Path
from pypi2nix.utils import cmd


class FormatTester:
    def __init__(self, logger: Logger) -> None:
        self._logger = logger

    def has_correct_format(self, nix_file: Path):
        return_code, _ = cmd(["nixfmt", "-c", str(nix_file)], logger=self._logger)
        return return_code == 0
