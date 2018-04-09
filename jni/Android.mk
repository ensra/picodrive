LOCAL_PATH := $(call my-dir)

CORE_DIR     := $(LOCAL_PATH)/..
COMMON_DIR   := $(CORE_DIR)/platform/common
LIBRETRO_DIR := $(CORE_DIR)/platform/libretro
UNZIP_DIR    := $(CORE_DIR)/unzip
R            := $(CORE_DIR)/
FR           := $(R)

SRCS_COMMON :=
DEFINES     :=
ARCH        := $(TARGET_ARCH)

use_cyclone  := 0
use_fame     := 1
use_musashi  := 0
use_drz80    := 0
use_cz80     := 1
use_sh2drc   := 0
use_sh2mame  := 1
use_svpdrc   := 0

asm_memory   := 0
asm_render   := 0
asm_ym2612   := 0
asm_misc     := 0
asm_cdmemory := 0
asm_mix      := 0

ifeq ($(TARGET_ARCH),arm)
  use_cyclone := 1
  use_sh2drc  := 1
  use_svpdrc  := 1
  asm_render  := 1
  asm_misc    := 1
  asm_mix     := 1
  use_fame    := 0
  use_sh2mame := 0
endif

ifeq ($(TARGET_ARCH_ABI),armeabi)
  CYCLONE_CONFIG := cyclone_config_armv4.h
endif

include $(COMMON_DIR)/common.mak

SOURCES_C := $(LIBRETRO_DIR)/libretro.c \
             $(COMMON_DIR)/mp3.c \
             $(COMMON_DIR)/mp3_dummy.c \
             $(UNZIP_DIR)/unzip.c

COREFLAGS := $(addprefix -D,$(DEFINES)) -fno-strict-aliasing

GIT_VERSION := " $(shell git rev-parse --short HEAD || echo unknown)"
ifneq ($(GIT_VERSION)," unknown")
  COREFLAGS += -DGIT_VERSION=\"$(GIT_VERSION)\"
endif

include $(CLEAR_VARS)
LOCAL_MODULE     := retro
LOCAL_SRC_FILES  := $(SRCS_COMMON) $(SOURCES_C)
LOCAL_CFLAGS     := $(COREFLAGS)
LOCAL_C_INCLUDES := $(CORE_DIR)
LOCAL_LDFLAGS    := -Wl,-version-script=$(LIBRETRO_DIR)/link.T
LOCAL_LDLIBS     := -llog -lz

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  LOCAL_ARM_NEON := true
endif

include $(BUILD_SHARED_LIBRARY)
