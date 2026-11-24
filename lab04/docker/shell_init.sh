# Sourced by interactive shells (entrypoint bash + docker exec attach).
# shellcheck source=docker/sage_env.sh
source /workspace/docker/sage_env.sh

_extra="${PYTHONPATH_EXTRA:-}"
if [[ -n "${_extra}" ]]; then
  export PYTHONPATH="/workspace/src:${_extra}"
else
  export PYTHONPATH="/workspace/src"
fi

ensure_sage_jupyter_kernel 2>/dev/null || true
