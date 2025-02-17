include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = diskutil

# Source files
diskutil_OBJC_FILES = main.m DiskUtil.m

# Framework search path
ADDITIONAL_CPPFLAGS += -I/System/Library/Frameworks/FreeBSDKit.framework/Headers
ADDITIONAL_LDFLAGS  += -L/System/Library/Frameworks/FreeBSDKit.framework -lFreeBSDKit

# Link against libgeom
ADDITIONAL_LDFLAGS += -lgeom

include $(GNUSTEP_MAKEFILES)/tool.make

# This should be installed into /System/Tools on Gershwin systems
