log() {
 info "$1"
 echo "[INFO]: $1" >> logs/script.log
}
log_error() {
 error "$1"
 echo "[ERROR]: $1" >> logs/script.log
}
