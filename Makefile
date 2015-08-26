.PHONY: all
all: images

.PHONY: images
images: master-image follower-image

.PHONY: master-image
master-image:
	docker build -t conjur-master master

.PHONE: follower-image
follower-image:
	docker build -t conjur-follower follower

