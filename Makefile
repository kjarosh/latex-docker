
build:
	docker build . -t kjarosh/latex:latest

push:
	docker push kjarosh/latex:latest
