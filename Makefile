all: generated/bashrc generated/bash_profile

install:
	ln -i -s $(PWD)/generated/bashrc $(HOME)/.bashrc
	ln -i -s $(PWD)/generated/bash_profile $(HOME)/.bash_profile

generated/%:
	mkdir -p generated
	{ echo "### Generated by $(PWD)/Makefile";                 \
		for f in $(@F).d/*.bash ;                              \
		do                                                     \
			echo "source $(PWD)/$$f";                          \
		done ;                                                 \
	}  > $@

clean:
	rm -rf generated/*
