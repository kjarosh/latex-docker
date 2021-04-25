IMAGE_ID ?= kjarosh/latex
VERSION ?= latest

_default: medium

all: minimal basic small medium full

minimal:
	docker build . -t $(IMAGE_ID):$(VERSION)-minimal \
	    --build-arg TL_SCHEME_BASIC=n \
	    --build-arg TL_SCHEME_SMALL=n \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

basic:
	docker build . -t $(IMAGE_ID):$(VERSION)-basic \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=n \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

small:
	docker build . -t $(IMAGE_ID):$(VERSION)-small \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

medium:
	docker build . -t $(IMAGE_ID):$(VERSION)-medium -t $(IMAGE_ID):$(VERSION) \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=y \
	    --build-arg TL_SCHEME_FULL=n

full:
	docker build . -t $(IMAGE_ID):$(VERSION)-full \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=y \
	    --build-arg TL_SCHEME_FULL=y

push_all:
	docker push $(IMAGE_ID):$(VERSION)-minimal
	docker push $(IMAGE_ID):$(VERSION)-basic
	docker push $(IMAGE_ID):$(VERSION)-small
	docker push $(IMAGE_ID):$(VERSION)-medium
	docker push $(IMAGE_ID):$(VERSION)-full
	docker push $(IMAGE_ID):$(VERSION)

.PHONY: _default
.PHONY: all
.PHONY: minimal
.PHONY: basic
.PHONY: small
.PHONY: medium
.PHONY: full
.PHONY: push_all
