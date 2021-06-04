TARGET := iphone:clang:latest:13.0
ARCHS = arm64 arm64e
THEOSDEVICEIP = 192.168.254.67


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PasswordAutofillDisable

PasswordAutofillDisable_FILES = Tweak.x
PasswordAutofillDisable_CFLAGS = -fobjc-arc
PasswordAutofillDisable_EXTRA_FRAMEWORKS = AltList

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
	
SUBPROJECTS += passwordautofilldisableprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
