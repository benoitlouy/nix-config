set -e
set -o pipefail


: "${PINENTRY_PROGRAM:=@pinentry@}"

OP=@op@
JQ=@jq@

# login() {
#   if command -v $PINENTRY_PROGRAM > /dev/null; then
#     $PINENTRY_PROGRAM << EOS | grep -oP 'D \K.*' | op signin my > ~/.op/session
# SETDESC Enter your 1password master password:
# SETPROMPT Master Password:
# GETPIN
# EOS
#   fi
#   source ~/.op/session
# }

print-account-list() {
  set +e
  op items list --format=json | $JQ -r '.[] | " - \(.title) \((.urls // [] | .[] | select(.primary) | .href) // "") [\(.id)]"'
  LOGGED_IN=${PIPESTATUS[0]}
  set -e

  if [ $LOGGED_IN -eq 127 ]; then
    echo "1password CLI tool 'op' not found"
    exit 2
  fi
}

open-account-url() {
  local url=$(op get item "$1" | jq -r '.overview.url')
  if [[ -n $url ]]; then
    xdg-open "$url" >/dev/null 2>/dev/null
  else
    exit 2
  fi
}

is-actual-url() {
  local url="$1"
  if [[ -n $url && "$url" != " " && "$url" != "http://" && "$url" != "https://" ]]; then
    return 0
  else
    return 1
  fi
}

show-account-options() {
  local id="$1"
  local entry=$(op item get --format=json "$id")

  if [[ -n $(echo $entry | $JQ -r '.fields[] | select(.id == "password")' ) ]]; then
    echo ">> Copy password [$id]"
  fi

  if [[ -n $(echo $entry | $JQ -r '.fields[] | select(.id == "username")' ) ]]; then
    echo ">> Copy username [$id]"
  fi

  if [[ -n $(echo $entry | $JQ -r '.fields[] | select(.type == "OTP")') ]]; then
    echo ">> Copy OTP [$id]"
  fi

  # url=$(echo $entry | jq -r '.overview.url')
  # if is-actual-url "$url"; then
  #   echo ">> Open $url [$id]"
  #   echo ">> Copy URL [$id]"
  # fi

  echo ">> Copy ID [$id]"
}

is-entry-selected() {
  if [[ -n $@ ]]; then
    return 0
  else
    return 1
  fi
}

id-in-selection() {
  echo "$1" | grep -oE '\[[a-z0-9]+\]$' | tr -d '[]'
}

debug() {
  echo "$@" > /dev/stderr
}

eval $(op signin)

if is-entry-selected "$1"; then
  selected="$1"

  id="$(id-in-selection "$selected")"

  if [[ -n $id ]]; then
    case "$selected" in
      '>> Copy password'*)
        op item get --format=json "$id" | $JQ -j '.fields[] | select(.id == "password") | .value' | wl-copy ;;
      '>> Copy username'*)
        op item get --format=json "$id" | $JQ -j '.fields[] | select(.id == "username") | .value' | wl-copy ;;
      '>> Copy OTP'*)
        op item get --format=json "$id" | $JQ -j '.fields[] | select(.type == "OTP") | .totp' | wl-copy ;;
      # '>> Copy URL'*)
      #   op get item "$id" | $JQ -j '.overview.url' | wl-copy ;;
      '>> Copy ID'*)
        echo "$id" | wl-copy ;;
      # '>> Open'*)
      #   open-account-url "$id" ;;
      *)
        show-account-options "$id" ;;
    esac
  else
    echo "Could not detect the entry ID of \"${selection}\""
    exit 1
  fi
else
  print-account-list
fi
