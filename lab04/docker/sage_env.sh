# Środowisko SageMath w kontenerze (source z entrypoint / shell_init / jnb).
# Jupyter Lab i jądro notebooka = Sage, nie osobny Python z uv.

SAGE_VENV="${SAGE_VENV:-/home/sage/sage/local/var/lib/sage/venv-python3.12.5}"

if [[ -d "${SAGE_VENV}/bin" ]]; then
  export PATH="/workspace/bin:${SAGE_VENV}/bin:${PATH}"
  export JUPYTER_PATH="${SAGE_VENV}/share/jupyter${JUPYTER_PATH:+:${JUPYTER_PATH}}"
fi

SAGE_JUPYTER="${SAGE_VENV}/bin/jupyter"
SAGE_KERNEL_NAME="${SAGE_KERNEL_NAME:-sagemath-10.8}"

ensure_sage_jupyter_kernel() {
  local base="${SAGE_VENV}/share/jupyter/kernels"
  local src="${base}/sagemath"
  local dst="${base}/${SAGE_KERNEL_NAME}"

  [[ -d "${src}" ]] || return 0
  if [[ ! -d "${dst}" ]]; then
    cp -a "${src}" "${dst}"
    echo "[sage] kernelspec: ${SAGE_KERNEL_NAME} (z sagemath)"
  fi
}
