#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\e[33m\u\e[0m@\e[35m\h \W\e[0m]\$ '
alias v='nvim'
