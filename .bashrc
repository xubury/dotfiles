#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

LANG=en_US.UTF-8

source ~/.git-prompt.sh
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
    local x2 the_new_dir adir index
    local -i cnt

    if [[ $1 ==  "--" ]]; then
        dirs -v
        return 0
    fi

    the_new_dir=$1
    [[ -z $1 ]] && the_new_dir=$HOME

    if [[ ${the_new_dir:0:1} == '-' ]]; then
        #
        # Extract dir N from dirs
        index=${the_new_dir:1}
        [[ -z $index ]] && index=1
        adir=$(dirs +$index)
        [[ -z $adir ]] && return 1
        the_new_dir=$adir
    fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
      x2=$(dirs +${cnt} 2>/dev/null)
      [[ $? -ne 0 ]] && return 0
      [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
      if [[ "${x2}" == "${the_new_dir}" ]]; then
          popd -n +$cnt 2>/dev/null 1>/dev/null
          cnt=cnt-1
      fi
  done

  return 0
}

alias cd=cd_func

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -alh'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
## Print nickname for git/hg/bzr/svn version control in CWD
## Optional $1 of format string for printf, default "(%s) "
function be_get_branch {
  local dir="$PWD"
  local vcs
  local nick
  while [[ "$dir" != "/" ]]; do
    for vcs in git hg svn bzr; do
      if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
        case "$vcs" in
          git) __git_ps1 "${1:-(%s) }"; return;;
          hg) nick=$(hg branch 2>/dev/null);;
          svn) nick=$(svn info 2>/dev/null\
                | grep -e '^Repository Root:'\
                | sed -e 's#.*/##');;
          bzr)
            local conf="${dir}/.bzr/branch/branch.conf" # normal branch
            [[ -f "$conf" ]] && nick=$(grep -E '^nickname =' "$conf" | cut -d' ' -f 3)
            conf="${dir}/.bzr/branch/location" # colo/lightweight branch
            [[ -z "$nick" ]] && [[ -f "$conf" ]] && nick="$(basename "$(< $conf)")"
            [[ -z "$nick" ]] && nick="$(basename "$(readlink -f "$dir")")";;
        esac
        [[ -n "$nick" ]] && printf "${1:-(%s) }" "$nick"
        return 0
      fi
    done
    dir="$(dirname "$dir")"
  done
}

stty -ixon

## Add branch to PS1 (based on $PS1 or $1), formatted as $2
export GIT_PS1_SHOWDIRTYSTATE=yes
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[1;33m\]\w \[\033[0;35m\]\$(be_get_branch "$2")\n\[\033[0m\]\$ "

[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
    [[ -n "$ATTACH_ONLY" ]] && {
        tmux a 2>/dev/null || {
            cd && exec tmux
        }
        exit
    }

    tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
    exec tmux
}

export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
