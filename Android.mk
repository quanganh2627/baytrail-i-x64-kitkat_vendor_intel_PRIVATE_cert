LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := email.p12
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT)/etc/security
LOCAL_SRC_FILES := email.p12
include $(BUILD_PREBUILT)

ADDITIONAL_BUILD_PROPERTIES += ro.intel.corp.email=1
