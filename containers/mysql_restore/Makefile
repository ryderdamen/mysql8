IMAGE_NAME=ryderdamen/mysql-restore
VERSION=10

.PHONY: build
build:
	@docker build -t $(IMAGE_NAME):$(VERSION) .

.PHONY: push
push:
	@docker push $(IMAGE_NAME):$(VERSION)

.PHONY: run
run:
	@docker run $(IMAGE_NAME):$(VERSION)
