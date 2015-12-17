PROMPT_CHAR="\$"

TIME_BG=white
TIME_FG=black

STATUS_BG=green
STATUS_ERROR_BG=red
STATUS_FG=white

DIR_BG=blue
DIR_FG=white

GIT_BG=white
GIT_FG=black

NVM_BG=green
NVM_FG=white
NVM_PREFIX="⬡ "

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "

ZSH_THEME_GIT_PROMPT_SUFFIX=""

ZSH_THEME_GIT_PROMPT_DIRTY=" ✘"

ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"

ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"

ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{blue}✹%F{black}"

ZSH_THEME_GIT_PROMPT_DELETED=" %F{red}✖%F{black}"

ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"

ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"

ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"

ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"

ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"

ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%}%{%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG='NONE'
}

prompt_char() {
  local prompt_char
  prompt_char=""

  prompt_char="${PROMPT_CHAR}"

  echo -n $prompt_char
}

prompt_time() {
  prompt_segment $TIME_BG $TIME_FG %D{%T}
}

prompt_status() {
  prompt_segment $STATUS_ERROR_BG $STATUS_FG ";adlskf"
}

prompt_dir() {
  local dir=''
  dir="${dir}%4(c:...:)%3c"

  prompt_segment $DIR_BG $DIR_FG $dir
}

prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment $GIT_BG $\GIT_FG

    echo -n $(git_prompt_info)
  fi
}

prompt_nvm() {
  $(type nvm >/dev/null 2>&1) || return

  local nvm_prompt
  nvm_prompt=$(nvm current 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt}
  prompt_segment $NVM_BG $NVM_FG $NVM_PREFIX$nvm_prompt
}

build_prompt() {
  prompt_time
  # prompt_status
  prompt_dir
  prompt_nvm
  prompt_git
  prompt_end
}

NEWLINE='
'
PROMPT="$NEWLINE"'%{%f%b%k%}$(build_prompt)'"$NEWLINE"
PROMPT="$PROMPT"'%{${fg_bold[default]}%}'
PROMPT="$PROMPT"'$(prompt_char) %{$reset_color%}'
