# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' $(_current_dir)$(git_prompt_info)'

RPROMPT='[$(prompt_ip)]'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

_current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg[cyan]%}%-2~ ... %3~%{$reset_color%} "
  else
    echo "%{$fg[cyan]%}%~%{$reset_color%} "
  fi
}

prompt_ip() {
  local myip
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ -n $NEEWBEE_ZSH_THEME_IP_INTERFACE ]]; then
      myip=$(ipconfig getifaddr "$NEEWBEE_ZSH_THEME_IP_INTERFACE")
    else
      local interface
      interface=$(networksetup -listnetworkserviceorder | grep 'Wi-Fi' | grep -o  "Device:\s*[a-z0-9]*" | grep -o -E '[a-z0-9]*$')
      myip=$(ipconfig getifaddr ${interface})
    fi
  else
    if [[ -n $NEEWBEE_ZSH_THEME_IP_INTERFACE ]]; then
      # Get the IP address of the specified interface.
      myip=$(ip -4 a show "${NEEWBEE_ZSH_THEME_IP_INTERFACE}" | grep -o "inet\s*[0-9.]*" | grep -v 'brd'| grep -o "inet\s*[0-9.]*"| grep -o "[0-9.]*")
    else
      interfaces=$(ip link ls up | grep -o -E ":\s+[a-z0-9]+:" | grep -v "lo" | grep -o "[a-z0-9]*")
      callback='ip -4 a show $item | grep -o "inet\s*[0-9.]*" | grep -o "[0-9.]*"'
      # Get all network interface names that are up
      myip=$(getRelevantItem "$interfaces" "$callback")
      # ip=$(ip -4 a show eth0 | grep  "inet\s*[0-9.]*" | grep -v 'brd'| grep -o "inet\s*[0-9.]*"| grep -o "[0-9.]*")
    fi
  fi
  echo "${myip}"
}

getRelevantItem() {
  setopt shwordsplit

  local list callback
  list=$1
  callback=$2

  for item in $list; do
    try=$(eval "$callback")
    if [[ -n "$try" ]]; then
      echo "$try"
      break;
    fi
  done
}
