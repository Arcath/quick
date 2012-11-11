if [[ ! -o interactive ]]; then
    return
fi

compctl -K _quick quick

_quick() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(quick commands)"
  else
    completions="$(quick completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
