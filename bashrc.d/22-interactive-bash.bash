if [[ -z "$INTERACTIVE_BASH" && "$(readlink -f "$BASH")" == *interactive* ]]; then
	export INTERACTIVE_BASH="$BASH"
fi
PROMPT_COMMAND='export SHELL="$INTERACTIVE_BASH"'
