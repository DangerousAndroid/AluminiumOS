log_info() {
echo ""
echo ""
info "$1"
echo "[INFO]: $1" >> logs/script.log
}
log_error() {
echo ""
echo ""
error "$1"
echo "[ERROR]: $1" >> logs/script.log
}
log_success() {
echo ""
echo ""
success "$1"
echo "[SUCCESS]: $1" >> logs/script.log
}
