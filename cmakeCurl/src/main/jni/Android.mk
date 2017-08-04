LOCAL_PATH:= $(call my-dir)

common_CFLAGS := -Wpointer-arith -Wwrite-strings -Wunused -Winline -Wnested-externs -Wmissing-declarations -Wmissing-prototypes -Wno-long-long -Wfloat-equal -Wno-multichar -Wsign-compare -Wno-format-nonliteral -Wendif-labels -Wstrict-prototypes -Wdeclaration-after-statement -Wno-system-headers -DHAVE_CONFIG_H

#########################
# Build the libcurl library

include $(CLEAR_VARS)
include $(LOCAL_PATH)/lib/Makefile.inc
CURL_HEADERS := \
	curlbuild.h \
	curl.h \
	curlrules.h \
	curlver.h \
	easy.h \
	mprintf.h \
	multi.h \
	stdcheaders.h \
	typecheck-gcc.h

LOCAL_SRC_FILES := $(addprefix lib/,$(CSOURCES))
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include/ $(LOCAL_PATH)/lib
LOCAL_CFLAGS += $(common_CFLAGS)

LOCAL_COPY_HEADERS_TO := libcurl/curl
LOCAL_COPY_HEADERS := $(addprefix include/curl/,$(CURL_HEADERS))

LOCAL_MODULE:= libcurl
LOCAL_MODULE_TAGS := optional

# Copy the licence to a place where Android will find it.
# Actually, this doesn't quite work because the build system searches
# for NOTICE files before it gets to this point, so it will only be seen
# on subsequent builds.
#ALL_PREBUILT += $(LOCAL_PATH)/NOTICE
#$(LOCAL_PATH)/NOTICE: $(LOCAL_PATH)/COPYING | $(ACP)
#	$(copy-file-to-target)

include $(BUILD_SHARED_LIBRARY)


#########################
# Build the curl binary

include $(CLEAR_VARS)
include $(LOCAL_PATH)/src/Makefile.inc
LOCAL_SRC_FILES := $(addprefix src/,$(CURL_CFILES))

LOCAL_MODULE := curltest
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libcurl
LOCAL_SYSTEM_SHARED_LIBRARIES := libc

LOCAL_C_INCLUDES += $(LOCAL_PATH)/include $(LOCAL_PATH)/lib

# This may also need to include $(CURLX_CFILES) in order to correctly link
# if libcurl is changed to be built as a dynamic library
LOCAL_CFLAGS += $(common_CFLAGS)

include $(BUILD_EXECUTABLE)

