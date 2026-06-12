blue() {
 echo -ne "\033[0;34m"
 echo -n
 echo -e "\033[0m"
}
error() {
 echo -ne "\033[0;31m"
 echo -n "$1"
 echo -e "\033[0m"
}
success() {
 echo -ne "\033[0;32m"
 echo -n "$1"
 echo -e "\033[0m"
}
info() {
 echo -ne "\033[1;33m"
 echo -n "$1"
 echo -e "\033[0m"
}
info_continue() {
 printf "\033[1;33m%s\033[0m %s\n" "$1" "$2"
}
