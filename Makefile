.PHONY: all
all: images

.PHONY: images
images: master-image standby-image follower-image 

.PHONY: master-image
master-image:
	docker build -t conjur-master master

.PHONY: standby-image
standby-image:
	docker build -t conjur-standby standby

.PHONE: follower-image
follower-image:
	docker build -t conjur-follower follower

