
scvcs_status(){
	git status -sb 2>/dev/null
	true
}
alias ?='scvcs_status'
