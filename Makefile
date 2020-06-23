ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
else
    DETECTED_OS := $(shell uname)
endif

.PHONY: dev build test clean

download-bins:
	yarn download-bins

install-deps:
	yarn install --frozen-lockfile

out/app_vue.js:
	yarn dev:renderer:vue

out/app_react.js:
	yarn dev:renderer:react

dev: install-deps out/app_vue.js out/app_react.js
	yarn dev:main
	yarn dev-run-renderer --watch -k

test:
	yarn test

integration-linux:
	yarn build:linux
	yarn integration

integration-mac:
	yarn build:mac
	yarn integration

integration-win:
	yarn build:win
	yarn integration

build: install-deps
ifeq "$(DETECTED_OS)" "Windows"
	yarn dist:win
else
	yarn dist
endif

clean:
	rm -rf binaries/client/*
	rm -rf dist/*
	rm -rf out/*
