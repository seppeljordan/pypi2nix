from abc import ABC
from abc import abstractmethod

from pypi2nix.logger import Logger
from pypi2nix.path import Path
from pypi2nix.utils import cmd


class CodeFormatter(ABC):
    @abstractmethod
    def format_file(self, path: Path) -> None:
        pass


class Nixfmt(CodeFormatter):
    def __init__(self, logger: Logger):
        self._logger = logger

    def format_file(self, path: Path) -> None:
        if self._is_nixfmt_installed():
            cmd(["nixfmt", str(path)], logger=self._logger)
        else:
            self._logger.warning(f"Could not format {path}, nixfmt is not installed")

    def _is_nixfmt_installed(self) -> bool:
        try:
            cmd(["nixfmt", "-h"], self._logger)
        except FileNotFoundError:
            return False
        else:
            return True
