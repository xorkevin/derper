.PHONY: all build publish

IMAGE=xorkevin/derper
VERSION=1.18
TAG=$(IMAGE):$(VERSION)
LATEST=$(IMAGE):latest

all: build

build:
	docker build -t $(LATEST) -t $(TAG) .

publish:
	docker push $(TAG)
	docker push $(LATEST)
