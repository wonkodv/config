alias clip='xclip -selection clipboard'
alias clipo='xclip -selection clipboard -out'
alias clipi='xclip -selection clipboard -in'
alias cp='cp -i'
alias crontab='crontab -i'
alias dd='dd status=progress'
alias df='df -h'
alias diff='colordiff'
alias du='du -c -h'
alias free='free -h'
alias grep='grep --color=auto'
alias ip="ip --color=auto"
alias ipython='ipython --no-confirm-exit'
alias ln='ln -i'
alias mkdir='mkdir -p -v'
alias mv='mv -i'
alias nano='nano -w'
alias rm='rm -i'
alias rsync='rsync --progress'
alias shred='shred -uz'
alias sudo='sudo '

alias icat="kitty +kitten icat"
alias bd="lsblk --output name,partlabel,label,mountpoint,fstype,size,fsavail,fsuse%,model"
alias l='ls --color=auto -lh --file-type --hyperlink=auto'
alias f='feh --auto-rotate --auto-zoom --draw-filename --draw-tinted --fullscreen --action ";echo %f"'
alias :q='false'
alias :wq='false'
alias :e="nvr --remote-tab"


alias ?="_status"
function _status() {
    local bold="\e[1m"
    local red="\e[1;31m"
    local clear="\e[0m"

    if [[ $(jobs |wc -l ) -gt 0 ]]
    then
        echo -e "${bold}Jobs${clear}"
        jobs
    fi

    if [ -n "$VIRTUAL_ENV" ]
    then
        echo -ne"${bold}VENV${clear}    "
        echo "$VIRTUAL_ENV"
    fi

    if [ -n "$SSH_CLIENT" ]
    then
        echo -ne "${bold}SSH${clear}   "
        echo "$SSH_CONNECTION"
    fi

    echo -en "${bold}ID${clear}      "
    [ "$USER" == root ] && echo -ne ${red}
    echo -e $USER${clear}@$HOSTNAME

    if [ -r /sys/class/power_supply/BAT0/ ]
    then
        echo -en "${bold}BATTERY${clear} "
        full=`cat /sys/class/power_supply/BAT0/energy_full`
        now=`cat /sys/class/power_supply/BAT0/energy_now`
        echo -n "$((now*100/full))% "
        cat /sys/class/power_supply/BAT0/status
    fi

    if   git rev-parse &>/dev/null
    then
        echo -e "${bold}GIT${clear}"
        git --no-pager -c color.status=always status -bs --show-stash --ahead-behind -M
        git --no-pager stash list
    fi

    echo -en "${bold}PWD${clear}     "
    echo  "$PWD"
}

o(){
(
    (
    while [ -n "$1" ]
    do
        case `file --mime-type --brief "$1"` in
            application/pdf)    evince    "$1";;
            image/*)            feh       "$1";;
            *)                  xdg-open  "$1";;
        esac
        shift;
    done
    ) &>/dev/null &
)
}


if [ -n "$WSL_DISTRO_NAME" ]
then
    function o() {
        w=$(wslpath -wa "$1")
        /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command Start-Process "$w"
    }

    function x() {
        w=$(wslpath -wa "$1")
        /mnt/c/Windows/SysWOW64/explorer.exe /select, "$w"
        true # because explorer.exe has the weirdest return codes :/
    }
fi
