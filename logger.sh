log_info() {
  echo ""
  info "$1"
  [ -d logs ] && echo "[INFO]: $1" >> logs/script.log
}
log_error() {
  echo ""
  error "$1"
  [ -d logs ] && echo "[ERROR]: $1" >> logs/script.log
}
log_success() {
  echo ""
  success "$1"
  [ -d logs ] && echo "[SUCCESS]: $1" >> logs/script.log
}
