include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = diskutil

# Source files
diskutil_OBJC_FILES = main.m

# Framework search path
ADDITIONAL_CPPFLAGS += -I/System/Library/Frameworks/FreeBSDKit.framework/Headers
ADDITIONAL_LDFLAGS  += -L/System/Library/Frameworks/FreeBSDKit.framework -lFreeBSDKit

# Link against libgeom
ADDITIONAL_LDFLAGS += -lgeom

include $(GNUSTEP_MAKEFILES)/tool.make



# -----------------------------------------
# ORIGINAL WORKING FILE BEFORE FRAMEWORK USAGE
# GNUmakefile for diskutil on FreeBSD

# Use the GNUstep make system
# include $(GNUSTEP_MAKEFILES)/common.make

# Set the type to a tool (command-line application)
# TOOL_NAME = diskutil

# Source files
# diskutil_OBJC_FILES = main.m

# Link against necessary FreeBSD libraries
# diskutil_LDFLAGS += -lgeom -lzfs

# Use GNUstep and Objective-C runtime
# diskutil_OBJCFLAGS += -fobjc-runtime=gnustep-2.0 -fblocks

# Use GNUstep Base (Foundation equivalent)
# include $(GNUSTEP_MAKEFILES)/tool.make
# -----------------------------------------


# -----------------------------------------
# Dock app makefile for comparison
#
# include $(GNUSTEP_MAKEFILES)/common.make

# APP_NAME = Dock  # Name of the application
# Dock_OBJC_FILES = main.m DockAppController.m DockGroup.m DockIcon.m ActiveLight.m DockDivider.m # List of Objective-C source files
# Dock_RESOURCE_FILES = Resources/Info-gnustep.plist  Resources/Icons/*.png # Resource files (plist, images, etc.)

# Compiler flags to enable ARC
# ADDITIONAL_OBJCFLAGS = -fobjc-arc

# include $(GNUSTEP_MAKEFILES)/application.make
# -----------------------------------------
