.PHONY: build test cover bench audit outdated

setup/release:
	cd scripts/release && chmod +x setup_release.sh && ./setup_release.sh
setup/validate:
	cd scripts && chmod +x setup.sh && ./setup.sh

release:
	npx semantic-release

lint/all:
	cd analyzer && chmod +x validate.sh && ./validate.sh -l all
lint/repo:
	cd analyzer && chmod +x validate.sh && ./validate.sh -l repo
lint/diff:
	cd analyzer && chmod +x validate.sh && ./validate.sh -l diff
lint/staged:
	cd analyzer && chmod +x validate.sh && ./validate.sh -l staged
lint/ci:
	cd analyzer && chmod +x validate.sh && ./validate.sh -l ci