
PACKER=@envchain do packer
CONFIG=image.pkr.hcl

validate:
	$(PACKER) validate $(CONFIG)

build:
	$(PACKER) build $(CONFIG)