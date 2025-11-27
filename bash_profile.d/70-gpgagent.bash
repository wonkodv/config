startagent=true
if [ -f ~/.gnupg/gpg-agent-info ]; then
    source ~/.gnupg/gpg-agent-info
    if gpg-agent &>/dev/null; then
        startagent=false
    fi
fi
if $startagent; then
    gpg-agent --daemon &>/dev/null
    source ~/.gnupg/gpg-agent-info
fi
unset startagent
export GPG_AGENT_INFO
