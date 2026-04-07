#!/usr/bin/env bash
# Cross-platform Python resolver
# Windows: skip python3 (Windows Store stub is unreliable), use python directly
# macOS/Linux: prefer python3, fall back to python
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    exec python "$@"
    ;;
  *)
    if command -v python3 >/dev/null 2>&1; then
      exec python3 "$@"
    else
      exec python "$@"
    fi
    ;;
esac
