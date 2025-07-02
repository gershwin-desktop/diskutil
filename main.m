#import "DiskUtil.h"
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[])
{
  @autoreleasepool {
    if (argc < 2) {
      NSLog(@"Usage: diskutil <command> [options]");
      return 1;
    }

    // Extract command and arguments
    NSString *command = [NSString stringWithUTF8String:argv[1]];
    NSMutableArray<NSString *> *arguments = [NSMutableArray array];

    for (int i = 2; i < argc; i++) {
      [arguments addObject:[NSString stringWithUTF8String:argv[i]]];
    }

    // Dispatch command
    DiskUtil *diskUtil = [[DiskUtil alloc] init];
    [diskUtil handleCommand:command withArguments:arguments];
  }
  return 0;
}
