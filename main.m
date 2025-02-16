#import <Foundation/Foundation.h>
#import <FreeBSDKit/FreeBSDKit.h>
#import <FreeBSDKit/FBDiskManager.h>
#include <libgeom.h>
#include <string.h>

@interface DiskManager : NSObject
- (void)listDiskProvidersAsJSON;
@end

@implementation DiskManager
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
        DiskManager *diskManager = [[DiskManager alloc] init];
        [diskManager listDiskProvidersAsJSON];
        NSLog(@"%@", [FreeBSDKit frameworkInfo]);
        NSLog(@"Installed Disks: %@", [FBDiskManager getDisks]);
    }
    return 0;
}

