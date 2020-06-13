import pytest

from pypi2nix.path import Path


@pytest.mark.parametrize(
    "text, expected_hash",
    (
        ("", "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73"),
        ("12345", "1ifgr9rw3agmrarmknh6k2wi3xdlfk6gcnc1q7y2l481pcd4g52r"),
    ),
)
def test_sha256_sum_gives_correct_hash_for_empty_file(
    tmpdir_factory, text, expected_hash
):
    file_path = Path(str(tmpdir_factory.mktemp("sha256_example"))) / "empty.txt"
    file_path.write_text(text)

    assert file_path.sha256_sum() == expected_hash
