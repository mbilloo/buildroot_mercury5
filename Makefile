OUTPUTS=$(PWD)/outputs
DLDIR=$(PWD)/dl

BUILDROOT_PATH=./buildroot
BUILDROOT_ARGS=BR2_DEFCONFIG=../br2midrive08/configs/midrive08_defconfig \
        BR2_DL_DIR=$(DLDIR) \
	BR2_EXTERNAL="../br2midrive08"

define clean_pkg
        rm -rf $(1)/output/build/$(2)/
endef

define update_git_package
	@echo updating git package $(1)
	git -C dl/$(1)/git fetch --force --all --tags
	- git -C dl/$(1)/git reset --hard origin/$(2)
	- git -C dl/$(1)/git reset --hard $(2)
	git -C dl/$(1)/git clean -fd
	rm -f dl/$(1)/$(1)-$(2).tar.gz
endef

.PHONY: all bootstrap buildroot_config buildroot linux_clean linux_update


all: buildroot


bootstrap:
	git submodule init
	git submodule update

buildroot_config:
	$(MAKE) -C $(BUILDROOT_PATH) $(BUILDROOT_ARGS) defconfig
	$(MAKE) -C $(BUILDROOT_PATH) $(BUILDROOT_ARGS) menuconfig
	$(MAKE) -C $(BUILDROOT_PATH) $(BUILDROOT_ARGS) savedefconfig

buildroot: $(OUTPUTS) $(DLDIR)
	$(MAKE) -C $(BUILDROOT_PATH) $(BUILDROOT_ARGS) defconfig
	$(MAKE) -C $(BUILDROOT_PATH) $(BUILDROOT_ARGS)

linux_clean:
	$(call clean_pkg,$(BUILDROOT_PATH),linux-msc313e_dev)

linux_update: linux_clean
	$(call update_git_package,linux,msc313e_dev)
