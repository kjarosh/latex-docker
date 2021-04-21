VERSION := latest

build:
	docker build . -t kjarosh/latex:$(VERSION)

push:
	docker push kjarosh/latex:$(VERSION)
