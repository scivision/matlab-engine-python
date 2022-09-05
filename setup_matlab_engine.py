#!/usr/bin/env python3
"""
setup Matlab Engine in Python

Assumes the Python version is compatible with the Matlab version.
"""

import argparse
from pathlib import Path
import tempfile
import sys
import subprocess
import shutil

p = argparse.ArgumentParser(description="setup Matlab Engine in Python")
p.add_argument("matlab_exe", help="path to Matlab executable", nargs="?", default="matlab")
a = p.parse_args()

matlab = shutil.which(a.matlab_exe)
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
