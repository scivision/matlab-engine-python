#!/usr/bin/env python3
"""
setup Matlab Engine in Python

Assumes your Python version is compatible with Matlab version.
"""

from pathlib import Path
import tempfile
import sys
import subprocess
import shutil

matlab = shutil.which("matlab")
if not matlab:
    raise FileNotFoundError("Matlab not found")

matlab_path = Path(matlab).parents[1]

setup_path = matlab_path / "extern/engines/python"
if not (setup_path / "setup.py").is_file():
    raise FileNotFoundError(f"Did not find Matlab Engine setup.py under: {setup_path}")

print("Matlab Engine setup.py at: ", setup_path)

cmd = [
    sys.executable,
    "setup.py",
    "build",
    f"--build-base={tempfile.gettempdir()}",
    "install",
    "--user",
]
print(" ".join(cmd))

subprocess.check_call(cmd, cwd=setup_path)
