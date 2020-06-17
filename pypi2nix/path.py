from __future__ import annotations

import os
import os.path
import pathlib
from hashlib import sha256
from typing import List
from typing import Union

from pypi2nix.hash import to_base32


class Path:
    def __init__(self, path: Union[pathlib.Path, str, Path]) -> None:
        self._path: pathlib.Path
        if isinstance(path, str):
            self._path = pathlib.Path(path)
        elif isinstance(path, pathlib.Path):
            self._path = path
        else:
            self._path = path._path

    def list_files(self) -> List[Path]:
        return list(map(lambda f: self / f, os.listdir(str(self))))

    def filename(self) -> str:
        return self._path.name

    def ensure_directory(self) -> None:
        return os.makedirs(self._path, exist_ok=True)

    def read_text(self) -> str:
        with open(self._path) as f:
            return f.read()

    def read_binary(self) -> bytes:
        with open(self._path, "rb") as f:
            return f.read()

    def write_text(self, text: str) -> None:
        self._path.write_text(text)

    def endswith(self, suffix: str) -> bool:
        return str(self).endswith(suffix)

    def is_file(self) -> bool:
        return os.path.isfile(self._path)

    def is_directory(self) -> bool:
        return os.path.isdir(self._path)

    def resolve(self) -> Path:
        return Path(self._path.resolve())

    def exists(self) -> bool:
        return os.path.exists(self._path)

    def sha256_sum(self) -> str:
        return to_base32(sha256(self.read_binary()).hexdigest())

    def directory_name(self) -> Path:
        return Path(os.path.dirname(self._path))

    def __truediv__(self, other: Union[str, Path]) -> Path:
        if isinstance(other, str):
            return Path(self._path / other)
        else:
            return Path(self._path / other._path)

    def __str__(self) -> str:
        return str(self._path)

    def __hash__(self) -> int:
        return hash(self._path)

    def __eq__(self, other: object) -> bool:
        if isinstance(other, Path):
            return self._path == other._path
        else:
            return False
