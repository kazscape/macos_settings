.PHONY: all apply check

all: apply

apply:
	ansible-playbook local.yml

apply-config:
	ansible-playbook local.yml --skip-tags "brew"

check:
	ansible-playbook local.yml --syntax-check
