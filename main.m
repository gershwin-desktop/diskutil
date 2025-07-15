#import "DiskUtil.h"
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[])
{
  @autoreleasepool {
    DiskUtil *diskUtil = [[DiskUtil alloc] init];
    
    if (argc < 2) {
      [diskUtil printUsage];
      return 1;
    }

    // Extract command and arguments
    NSString *command = [NSString stringWithUTF8String:argv[1]];
    NSMutableArray<NSString *> *arguments = [NSMutableArray array];

    for (int i = 2; i < argc; i++) {
      [arguments addObject:[NSString stringWithUTF8String:argv[i]]];
    }

    // Dispatch command
    [diskUtil handleCommand:command withArguments:arguments];
  }
  return 0;
}
