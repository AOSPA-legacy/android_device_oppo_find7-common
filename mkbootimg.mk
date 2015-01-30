LOCAL_PATH := $(call my-dir)

CM_DTB_FILES = $(wildcard $(TOP)/$(TARGET_KERNEL_SOURCE)/arch/arm/boot/*.dtb)
CM_DTS_FILE = $(lastword $(subst /, ,$(1)))
DTB_FILE := $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%.dtb,$(call CM_DTS_FILE,$(1))))
ZIMG_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%-zImage,$(call CM_DTS_FILE,$(1))))
KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage

define append-cm-dtb
mkdir -p $(KERNEL_OUT)/arch/arm/boot;\
$(foreach d, $(CM_DTB_FILES), \
    cat $(KERNEL_ZIMG) $(call DTB_FILE,$(d)) > $(call ZIMG_FILE,$(d));)
endef


## Build and run dtbtool
DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbToolCM$(HOST_EXECUTABLE_SUFFIX)
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	@echo -e ${CL_CYN}"Start DT image: $@"${CL_RST}
	$(call append-cm-dtb)
	$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	$(hide) $(DTBTOOL) -2 -o $(INSTALLED_DTIMAGE_TARGET) -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/
	@echo -e ${CL_CYN}"Made DT image: $@"${CL_RST}


$(TARGET_ROOT_OUT)/sbin/static/busybox: $(PRODUCT_OUT)/utilities/busybox
	@echo -e ${CL_CYN}"----- Copying static busybox to ramdisk ------"${CL_RST}
	$(hide) mkdir -p $(TARGET_ROOT_OUT)/sbin/static
	$(hide) cp $(PRODUCT_OUT)/utilities/busybox $(TARGET_ROOT_OUT)/sbin/static/busybox


## Overload bootimg generation: Same as the original, + --dt arg
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(INSTALLED_DTIMAGE_TARGET) $(PRODUCT_OUT)/utilities/busybox
	$(call pretty,"Target boot image: $@")
	@echo -e ${CL_CYN}"----- Making boot ramdisk ------"${CL_RST}
	$(hide) rm -f $(INSTALLED_RAMDISK_TARGET)
	$(hide) $(MKBOOTFS) $(TARGET_ROOT_OUT) | $(MINIGZIP) > $(INSTALLED_RAMDISK_TARGET)
	@echo -e ${CL_CYN}"----- Making boot image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

## Overload recoveryimg generation: Same as the original, + --dt arg
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo -e ${CL_CYN}"----- Copying configuration files ------"${CL_RST}
	$(hide) cp $(LOCAL_PATH)/rootdir/recovery/init.recovery.target.rc $(TARGET_RECOVERY_ROOT_OUT)
	$(hide) cp $(LOCAL_PATH)/rootdir/recovery/qhdcp.sh $(TARGET_RECOVERY_ROOT_OUT)/sbin
	$(hide) cp $(LOCAL_PATH)/rootdir/recovery/lvm_init_recovery.sh $(TARGET_RECOVERY_ROOT_OUT)/sbin
	$(hide) cp $(LOCAL_PATH)/rootdir/recovery/twrp.fstab.std $(TARGET_RECOVERY_ROOT_OUT)/etc
	$(hide) cp $(LOCAL_PATH)/rootdir/recovery/twrp.fstab.lvm $(TARGET_RECOVERY_ROOT_OUT)/etc
	## TWRP build are universal for find7s/find7a, unified/non-unified
	## ro.product.device is set in init	to find7/find7a
	$(hide) sed -ie 's/^\(ro.product.device=\)/# \1/' $(TARGET_RECOVERY_ROOT_OUT)/default.prop
	## set obsolete ro.build.product to a generic "find7" for older install-scripts
	$(hide) sed -ie 's/^\(ro.build.product=\).*/\1find7/' $(TARGET_RECOVERY_ROOT_OUT)/default.prop
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
