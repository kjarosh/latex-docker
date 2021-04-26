IMAGE_ID ?= kjarosh/latex
VERSION ?= latest

_default: medium

all: minimal basic small medium full

minimal:
	docker build . \
	  -f Dockerfile.minimal \
	  --build-arg "VERSION=$(VERSION)" \
	  -t $(IMAGE_ID):$(VERSION)-minimal

basic: minimal
	docker build . \
	  -f Dockerfile.basic \
	  --build-arg "VERSION=$(VERSION)" \
	  -t $(IMAGE_ID):$(VERSION)-basic

small: basic
	docker build . \
	  -f Dockerfile.small \
	  --build-arg "VERSION=$(VERSION)" \
	  -t $(IMAGE_ID):$(VERSION)-small

medium: small
	docker build . \
	  -f Dockerfile.medium \
	  --build-arg "VERSION=$(VERSION)" \
	  -t $(IMAGE_ID):$(VERSION)-medium \
	  -t $(IMAGE_ID):$(VERSION)

full: medium
	docker build . \
	  -f Dockerfile.full \
	  --build-arg "VERSION=$(VERSION)" \
	  -t $(IMAGE_ID):$(VERSION)-full

push_all:
	docker push $(IMAGE_ID):$(VERSION)-full
	docker push $(IMAGE_ID):$(VERSION)-small
	docker push $(IMAGE_ID):$(VERSION)-basic
	docker push $(IMAGE_ID):$(VERSION)-minimal
	docker push $(IMAGE_ID):$(VERSION)-medium
	docker push $(IMAGE_ID):$(VERSION)

.PHONY: _default
.PHONY: all
.PHONY: minimal
.PHONY: basic
.PHONY: small
.PHONY: medium
.PHONY: full
.PHONY: push_all
