import subprocess


def to_base32(digest: str) -> str:
    completed_process = subprocess.run(
        ["nix-hash", "--type", "sha256", "--to-base32", digest],
        stdout=subprocess.PIPE,
        universal_newlines=True,
    )
    return completed_process.stdout[:-1]
