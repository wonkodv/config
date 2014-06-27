all: generated/bashrc generated/bash_profile

install: all
	ln -i -s $(PWD)/generated/bashrc $(HOME)/.bashrc
	ln -i -s $(PWD)/generated/bash_profile $(HOME)/.bash_profile

generated/%: enabled/%.d/*.bash
	mkdir -p generated && cat $(sort $^) > $@

enableall:
	for f in available/*/*; do x="enabled/$${f#available/}"; mkdir -p "`dirname "$$x"`" && ln -s "../../$$f" "$$x"; done

clean:
	rm -rf generated/*
