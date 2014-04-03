# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

#
# Definitions for installing Certificate Authority (CA) certificates
#

define all-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find $(1) -type f) \
 )
endef

# $(1): module name
# $(2): source file
define include-prebuilt-cacert
include $$(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_STEM := $(notdir $(2))
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/security/cacerts
LOCAL_SRC_FILES := $(2)
include $$(BUILD_PREBUILT)
endef

cacerts := $(call all-files-under,intel_cacerts)

$(foreach cacert, $(cacerts), $(eval $(call include-prebuilt-cacert,target-cacert-$(notdir $(cacert)),$(cacert))))

include $(CLEAR_VARS)
LOCAL_MODULE := intel_cacerts
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := $(foreach cacert, $(cacerts), target-cacert-$(notdir $(cacert)))
include $(BUILD_PHONY_PACKAGE)

