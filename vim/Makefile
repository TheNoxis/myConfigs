# =====================================
## INFORMATIONS -----------------------
# =====================================
# Create date: 2016/10/11 - 21:52
# Describle:
#

# =====================================
## VARIABLES --------------------------
# =====================================
.PHONY: *
SHELL:=/usr/bin/bash


# =====================================
## MAIN -------------------------------
# =====================================

#install:
	#touch /tmp/$(NAME)

#clean:
	#@find ./ -type f -name "*.DELETEME"
status:
	for g in `ls -1d ./bundle/*`; do echo "> $${g} -------"; cd "$${g}"; git status; cd - 1>/dev/null; done

update:
	ls -1d ./bundle/* | xargs git pull
