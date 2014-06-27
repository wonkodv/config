alias diff='colordiff'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -m'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5 -O '
alias shred='shred -uz'

alias bd="lsblk --output name,mountpoint,fstype,size,label,partlabel,model"
alias l='ls --color=auto -lh --file-type'

alias ln='ln -i'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sudo='sudo '

alias :q=' false'
alias :Q=' false'
alias :x=' false'


o(){
	while [ -n "$1" ]
	do
		(
			xdg-open "$1" 2>/dev/null >/dev/null &
		)
		shift;
	done
}
