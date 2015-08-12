autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(rb_prompt)in $(directory_name) $(git_dirty)$(need_push) %(?..[%?])\n$(emoji-clock) '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}

# my stuff
function emoji-clock() {
  # Add 15 minutes to the current time and save the value as $minutes.
  (( minutes = $(date '+%M') + 15 ))
  (( hour = $(date '+%I') + minutes / 60 ))
  # make sure minutes and hours don't exceed 60 nor 12 respectively
  (( minutes %= 60 )); (( hour %= 12 ))
  case $hour in
     0) clock="🕛"; [ $minutes -ge 30 ] && clock="🕧";;
     1) clock="🕐"; [ $minutes -ge 30 ] && clock="🕜";;
     2) clock="🕑"; [ $minutes -ge 30 ] && clock="🕝";;
     3) clock="🕒"; [ $minutes -ge 30 ] && clock="🕞";;
     4) clock="🕓"; [ $minutes -ge 30 ] && clock="🕟";;
     5) clock="🕔"; [ $minutes -ge 30 ] && clock="🕠";;
     6) clock="🕕"; [ $minutes -ge 30 ] && clock="🕡";;
     7) clock="🕖"; [ $minutes -ge 30 ] && clock="🕢";;
     8) clock="🕗"; [ $minutes -ge 30 ] && clock="🕣";;
     9) clock="🕘"; [ $minutes -ge 30 ] && clock="🕤";;
    10) clock="🕙"; [ $minutes -ge 30 ] && clock="🕥";;
    11) clock="🕚"; [ $minutes -ge 30 ] && clock="🕦";;
     *) clock="⌛";;
  esac
  echo $clock
}
