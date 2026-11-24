#!/usr/bin/env python3
"""Weryfikacja SageMath — uruchom: ./scripts/drun verify"""

from __future__ import annotations

import os
import subprocess
import sys


def main() -> int:
    # Obraz sagemath/sagemath: `sage` i `jupyter` są w venv Sage (PATH z sage_env.sh)
    try:
        ver = subprocess.run(
            ["sage", "--version"],
            check=True,
            capture_output=True,
            text=True,
            timeout=120,
        )
    except FileNotFoundError:
        print("BŁĄD: brak polecenia `sage` w PATH.")
        return 1
    except subprocess.TimeoutExpired:
        print("BŁĄD: sage --version przekroczył limit czasu.")
        return 1

    print("=== SageMath ===")
    print(ver.stdout.strip() or ver.stderr.strip())

    try:
        specs = subprocess.run(
            ["jupyter", "kernelspec", "list"],
            check=True,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except FileNotFoundError:
        print("BŁĄD: brak `jupyter` (oczekiwany w venv Sage).")
        return 1

    print("\n=== Jupyter kernels ===")
    print(specs.stdout.strip())
    if "sagemath" not in specs.stdout and "sagemath-10.8" not in specs.stdout:
        print("BŁĄD: brak jądra SageMath w kernelspec list.")
        return 1

    print("\n=== Gotowe (uruchom ./shell.sh, potem: jnb) ===")
    return 0


if __name__ == "__main__":
    sys.exit(main())
