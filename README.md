Bash Configuration
=====

For bashrc and bash_profile currently, other .files possible

Functions
----
Each behaviour in 1 file, for example set `EDITOR=vim` in:
    available/bashrc.d/20-editor.bash

Selection
------
Select which functions by simlinking them in the respective enabled folder.
Therefore behaviour can be customized without complicating git pulls

Installation
----

* `git clone` in some directory
* `make enableall` in that directory
* remove unneeded stuff from the enabled/ folder
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
