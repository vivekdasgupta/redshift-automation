
VERSION = $(shell whoami)
PROJECT = $(notdir $(shell pwd))
REGISTRY = your.dockerregistry.com
QA_IMG_POSTFIX ?= $(shell git rev-parse --abbrev-ref HEAD)
TOOLS_IMAGE = your.dockerregistry.com/tools/redshift-automation
TEST_IMAGE = your.dockerregistry.com/tools/test-redshift-automation
PWD = $(shell pwd)
REPORTER = nyan

buildSpecImage:
	echo "Building test container"
	docker build -t $(TEST_IMAGE) -f SpecDockerfile .
.PHONY: buildTestImage

test: buildSpecImage
	docker run \
		-t\
    -v $(PWD):/opt/app \
    -w /opt/app	\
    $(TEST_IMAGE) \
		sh -c "rspec spec"
.PHONY: test

# build app
build:
	echo "Building container"
	docker build -t $(TOOLS_IMAGE) .
.PHONY: build

push: build
	echo "Pushing container"
	docker push  $(TOOLS_IMAGE)
.PHONY: push

buildQAImage:
	echo "Building container"
	docker build -t $(TOOLS_IMAGE)-$(QA_IMG_POSTFIX) .
.PHONY: buildQAImage

pushQAImage: buildQAImage
	echo "Pushing container $(TOOLS_IMAGE)-$(QA_IMG_POSTFIX)"
	docker push $(TOOLS_IMAGE)-$(QA_IMG_POSTFIX)
.PHONY: pushQAImage


buildRedshiftCluster:
	docker run -t\
	-v $(PWD):/opt/app/src \
	-w /opt/app	\
	$(TOOLS_IMAGE) \
	buildRedshiftCluster["$(PROJECT)","$(ENV)","$(FILE)"]
.PHONY: buildRedshiftCluster

updateRedshiftCluster:
	docker run -t\
	-v $(PWD):/opt/app/src \
	-w /opt/app	\
	$(TOOLS_IMAGE) \
	updateRedshiftCluster["$(PROJECT)","$(ENV)","$(FILE)"]
.PHONY: updateRedshiftCluster


deleteRedshiftCluster:
	docker run -t\
	-v $(PWD):/opt/app/src \
	-w /opt/app	\
	$(TOOLS_IMAGE) \
	deleteRedshiftCluster["$(PROJECT)","$(ENV)","$(CLUSTER_NAME)"]
.PHONY: deleteRedshiftCluster


createRedshiftSubnetGroup:
	docker run -t\
	-v $(PWD):/opt/app/src \
	-w /opt/app	\
	$(TOOLS_IMAGE) \
	createRedshiftSubnetGroup["$(PROJECT)","$(ENV)","$(FILE)"]
.PHONY: createRedshiftSubnetGroup
