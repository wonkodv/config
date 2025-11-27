shopt -s cdspell
shopt -s globstar
shopt -s gnu_errfmt
shopt -s checkjobs
shopt -s progcomp_alias

# set -o vi
# bind '"\e.": yank-last-arg'
# bind '"\e_": yank-last-arg'
# bind '"\C-u": unix-line-discard'
# bind '"\C-w": unix-word-rubout'

# don't think about what stty did before
set bind-tty-special-chars off

# disable terminal reacting to <C-s>
stty -ixon 2>/dev/null

# C-BKSP
bind '"\C-h": backward-kill-word'
bind '"\M-h": unix-word-rubout'

# unset C-W because I use it in browsers too often
stty werase undef
bind '"\C-w": redraw-current-line'

bind "set colored-completion-prefix on"
# if above don't work try: bind "set completion-prefix-display-length 10"
