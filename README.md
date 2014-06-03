My Bash
=====

Files
----

Everythin is Split in 1 File per topic, in 1 folder per resulting file.

* `bashrc.d`
  * `50-some-function.bash`
  * `60-other-function.bash`
* `bash_profile`
  * ...


make
----

* `make all` conactenates all parts of the respective files
* `make install` creates symlinks in HOME pointing to the concated files


BashRC
==========

* Color Prompt
  * Shows Status,
  * implemented in `50-colorpromt-*.bash`
  * composed in `51-colorprompt.bash`
* Command Not Found Hook
  * looks for pacman packages that contain such a command
  * stores them (~/tmp/.missing-packages)
  * can be directly installed with `givemethat` alias
* `70-bashjump` needs [BashJump](https://github.com/wonkodv/bashjump)


Bash_Profile
------------

* Start SSH agent
* start GPG agent
* Start X
  * Do some stuff in background once X is up
