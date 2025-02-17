#import <Foundation/Foundation.h>
#import "DiskUtil.h"
// #import <FreeBSDKit/FreeBSDKit.h>
// #import <FreeBSDKit/FBDiskManager.h>
// #include <libgeom.h>
// #include <string.h>

/* @interface DiskManager : NSObject
- (void)listDiskProvidersAsJSON;
@end

@implementation DiskManager
- (void)handleCommand:(NSString *)command withArguments:(NSArray<NSString *> *)arguments {
    NSDictionary *commands = @{
        @"list"   : NSStringFromSelector(@selector(listDisks:)),
        @"info"   : NSStringFromSelector(@selector(diskInfo:)),
        @"mount"  : NSStringFromSelector(@selector(mountDisk:)),
        @"unmount": NSStringFromSelector(@selector(unmountDisk:))
    };

    SEL selector = NSSelectorFromString(commands[command]);
    if (selector && [self respondsToSelector:selector]) {
        [self performSelector:selector withObject:arguments];
    } else {
        NSLog(@"Unknown command: %@", command);
        [self printUsage];
    }
}

- (void)listDiskProvidersAsJSON {
    // Get data from framework instead
    NSMutableDictionary *disksDictionary = [FBDiskManager getAllDiskInfo];

    // Convert to JSON
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:disksDictionary options:NSJSONWritingPrettyPrinted error:&error];

    if (!jsonData) {
        NSLog(@"Error creating JSON: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        printf("%s\n", [jsonString UTF8String]);
    }

}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // DiskManager *diskManager = [[DiskManager alloc] init];
        // [diskManager listDiskProvidersAsJSON];       
        // NSLog(@"%@", [FreeBSDKit frameworkInfo]);
        // NSLog(@"Installed Disks: %@", [FBDiskManager getDisks]);

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
}*/

#import <Foundation/Foundation.h>
#import "DiskUtil.h"

int main(int argc, const char * argv[]) {
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


