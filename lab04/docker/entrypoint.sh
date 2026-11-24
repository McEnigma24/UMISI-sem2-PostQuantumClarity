#!/usr/bin/env bash
set -euo pipefail

cd /workspace

# shellcheck source=docker/sage_env.sh
source /workspace/docker/sage_env.sh

VENV="${UV_PROJECT_ENVIRONMENT:-/workspace/build/venv}"
mkdir -p /workspace/build/uv-cache /workspace/build/python /workspace/build/run /workspace/build/logs

export UV_PROJECT_ENVIRONMENT="${VENV}"
export UV_CACHE_DIR="${UV_CACHE_DIR:-/workspace/build/uv-cache}"
export UV_PYTHON_INSTALL_DIR="${UV_PYTHON_INSTALL_DIR:-/workspace/build/python}"
export PATH="/workspace/bin:${VENV}/bin:/root/.local/bin:${PATH}"
# Po uv PATH — nadpisuje sage_env; przywróć Sage na początek
if [[ -d "${SAGE_VENV}/bin" ]]; then
  export PATH="/workspace/bin:${SAGE_VENV}/bin:${VENV}/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
fi

_skip_sync=0
if [[ "${1:-}" == "bash" && "${2:-}" == "-c" ]]; then
  _skip_sync=1
fi
if [[ $_skip_sync -eq 0 ]] && [[ -f pyproject.toml ]]; then
  echo "[entrypoint] uv sync (narzędzia dev → ${VENV})"
  uv sync
fi

ensure_sage_jupyter_kernel

print_banner() {
  cat <<EOF

=== SageMath dev shell (${PROJECT_NAME:-lab04}) ===
  jnb        Jupyter Lab (Sage)  -> http://127.0.0.1:${JUPYTER_PORT:-8888}/
  sage       konsola SageMath w terminalu
  tb         TensorBoard (opcjonalnie) -> http://127.0.0.1:${TENSORBOARD_PORT:-6006}/
  jnb|tb: stop | status | logs
  W Jupyterze wybierz jądro: SageMath 10.8 (${SAGE_KERNEL_NAME})
  exit       zamyka kontener (pierwszy terminal)

EOF
}

if [[ "${1:-}" == "bash" && $# -eq 1 ]]; then
  clear
  print_banner
  exec bash --rcfile /workspace/docker/shell_init.sh
fi

exec "$@"
