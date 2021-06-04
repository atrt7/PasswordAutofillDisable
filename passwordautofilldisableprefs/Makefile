TARGET := iphone:clang:latest:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PasswordAutofillDisablePrefs

PasswordAutofillDisablePrefs_FILES = PADRootListController.m
PasswordAutofillDisablePrefs_FRAMEWORKS = UIKit
PasswordAutofillDisablePrefs_PRIVATE_FRAMEWORKS = Preferences
PasswordAutofillDisablePrefs_EXTRA_FRAMEWORKS = AltList
PasswordAutofillDisablePrefs_INSTALL_PATH = /Library/PreferenceBundles
PasswordAutofillDisablePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
