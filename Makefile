.PHONY: all apply apply-sudo check

all: apply

apply:
	ansible-playbook local.yml

apply-sudo:
	ansible-playbook local.yml --ask-become-pass

apply-config:
	ansible-playbook local.yml --skip-tags "brew"

check:
	ansible-playbook local.yml --syntax-check
