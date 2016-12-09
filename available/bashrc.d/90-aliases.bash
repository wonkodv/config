alias diff='colordiff'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -m'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5 -O '
alias shred='shred -uz'

alias bd="lsblk --output name,mountpoint,ro,fstype,size,label,partlabel,model"
alias l='ls --color=auto -lh --file-type'

alias ln='ln -i'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sudo='sudo '

alias :q='false'
alias :wq='false'

alias ipython='ipython --no-confirm-exit'

alias crontab='crontab -i'

o(){
(
    (
    while [ -n "$1" ]
    do
        case `file --mime-type --brief "$1"` in
            application/pdf)evince    "$1";;
            image/*)		feh       "$1";;
            *)				xdg-open  "$1";;
        esac
        shift;
    done

    ) &>/dev/null &
)
}

function vimgrep {
    vim -c "vimgrep '$1' **/*.${2:-*}"
}

