github_pages_name := badasstronaut.github.io
deploy_base_url := https://$(github_pages_name)
deploy_repo := https://github.com/BadAsstronaut/$(github_pages_name).git

.PHONY: github_pages_update
github_pages_update:
	rsync -vrc --delete ./build/ ./$(github_pages_name) --exclude .git \
		&& pushd $(github_pages_name) \
		&& git add . \
		&& git commit -m "New build" \
		&& git push

.PHONY: github_pages_clone
github_pages_clone:
	git clone $(deploy_repo)

.PHONY: hugo_build
hugo_build:
	hugo build \
		--baseURL $(deploy_base_url) \
		--cleanDestinationDir \
		--destination build \
		--minify

.PHONY: hugo_run
hugo_run:
	hugo server --cleanDestinationDir

.PHONY: install_hugo
install_hugo:
	brew install hugo

.PHONY: update_submodules
update_submodules:
	git submodule update --init --recursive
