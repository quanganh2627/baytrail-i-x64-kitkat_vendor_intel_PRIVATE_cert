LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := email.p12
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/etc/security
LOCAL_SRC_FILES := email.p12
include $(BUILD_PREBUILT)

ADDITIONAL_BUILD_PROPERTIES += ro.intel.corp.email=1

include $(CLEAR_VARS)
LOCAL_MODULE := OS_priv.pem
LOCAL_HOST_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(HOST_OUT)/etc/cert
LOCAL_SRC_FILES := OS_priv.pem
include $(BUILD_PREBUILT)

# If LOCAL_SIGN is not set, sign the OS locally (don't use signing server)
# this can be overriden with an environment variable
LOCAL_SIGN ?= true

# Add OS_priv.pem to mkbootimg dependency items
ifeq ($(TARGET_OS_SIGNING_METHOD),isu_plat2)
$(MKBOOTIMG): OS_priv.pem
endif

