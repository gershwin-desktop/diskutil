#import <Foundation/Foundation.h>

@interface DiskUtil : NSObject
- (void)handleCommand:(NSString *)command withArguments:(NSArray<NSString *> *)arguments;
@end

