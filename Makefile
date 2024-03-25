IMAGE_ID ?= kjarosh/latex
VERSION ?= latest

TL_MIRROR ?= https://texlive.info/CTAN/systems/texlive/tlnet

_default: all

all: minimal basic small medium full

minimal:
	docker build . -t $(IMAGE_ID):$(VERSION)-minimal \
	    --build-arg TL_MIRROR="$(TL_MIRROR)" \
	    --build-arg TL_SCHEME_BASIC=n \
	    --build-arg TL_SCHEME_SMALL=n \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

basic:
	docker build . -t $(IMAGE_ID):$(VERSION)-basic \
	    --build-arg TL_MIRROR="$(TL_MIRROR)" \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=n \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

small:
	docker build . -t $(IMAGE_ID):$(VERSION)-small \
	    --build-arg TL_MIRROR="$(TL_MIRROR)" \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=n \
	    --build-arg TL_SCHEME_FULL=n

medium:
	docker build . -t $(IMAGE_ID):$(VERSION)-medium \
	    --build-arg TL_MIRROR="$(TL_MIRROR)" \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=y \
	    --build-arg TL_SCHEME_FULL=n

full:
	docker build . -t $(IMAGE_ID):$(VERSION)-full -t $(IMAGE_ID):$(VERSION) \
	    --build-arg TL_MIRROR="$(TL_MIRROR)" \
	    --build-arg TL_SCHEME_BASIC=y \
	    --build-arg TL_SCHEME_SMALL=y \
	    --build-arg TL_SCHEME_MEDIUM=y \
	    --build-arg TL_SCHEME_FULL=y

test: minimal basic
	IMAGE_ID=$(IMAGE_ID) VERSION=$(VERSION) \
	    docker compose -f test.compose.yaml run --build sut

.PHONY: *
