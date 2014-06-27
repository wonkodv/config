
scvcs_status(){
	echo 'git:'
	git status -sb 2>/dev/null
	echo 'svn:'
	svn status 2>/dev/null
	true
}
alias ?='scvcs_status'
