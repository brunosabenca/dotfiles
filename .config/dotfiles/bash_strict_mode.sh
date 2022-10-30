
# Inspiration from here:
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://olivergondza.github.io/2019/10/01/bash-strict-mode.html

# Bash strict mode
set -euo pipefail
# Neat way to show the line and program which caused the error in a pipeline
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'
