#import "DiskUtil.h"
#import <FreeBSDKit/FBDiskManager.h>
#import <FreeBSDKit/FreeBSDKit.h>
#import <unistd.h> // For getopt_long

@implementation DiskUtil

- (void)handleCommand:(NSString *)command withArguments:(NSArray<NSString *> *)arguments
{
  NSDictionary *commands = @{
    @"list" : NSStringFromSelector(@selector(listDiskProviders:)),
    @"listDisks" : NSStringFromSelector(@selector(listDiskNames:)),
    @"info" : NSStringFromSelector(@selector(diskInfo:)),
    @"mount" : NSStringFromSelector(@selector(mountDisk:)),
    @"unmount" : NSStringFromSelector(@selector(unmountDisk:))
  };

  SEL selector = NSSelectorFromString(commands[command]);
  if (selector && [self respondsToSelector:selector]) {
    [self performSelector:selector withObject:arguments];
  }
  else {
    printf("Unknown command: %s", [command UTF8String]);
    [self printUsage];
  }
}

// These pragma markers are supposed to help the DX when viewing in IDEs. Remove
// if not necessary
#pragma mark - Output Formatting Helper

- (NSString *)formatData:(id)data asFormat:(NSString *)format
{
  NSError *error;

  if ([format isEqualToString:@"json"]) {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
      NSLog(@"Error creating JSON: %@", error);
      return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }

  if ([format isEqualToString:@"xml"]) {
    NSMutableString *xmlString =
        [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n"];
    [self appendXML:data toString:xmlString withIndent:@"  "];
    [xmlString appendString:@"</root>\n"];
    return xmlString;
  }

  return nil; // Unsupported format
}

- (void)appendXML:(id)data toString:(NSMutableString *)xmlString withIndent:(NSString *)indent
{
  if ([data isKindOfClass:[NSDictionary class]]) {
    for (NSString *key in data) {
      [xmlString appendFormat:@"%@<%@>\n", indent, key];
      [self appendXML:data[key]
             toString:xmlString
           withIndent:[indent stringByAppendingString:@"  "]];
      [xmlString appendFormat:@"%@</%@>\n", indent, key];
    }
  }
  else if ([data isKindOfClass:[NSArray class]]) {
    for (id item in data) {
      [xmlString appendFormat:@"%@<item>\n", indent];
      [self appendXML:item toString:xmlString withIndent:[indent stringByAppendingString:@"  "]];
      [xmlString appendFormat:@"%@</item>\n", indent];
    }
  }
  else {
    [xmlString appendFormat:@"%@%@\n", indent, data];
  }
}

- (void)outputData:(id)data withFormat:(NSString *)format
{
  if ([format isEqualToString:@"text"]) {
    [self outputPlainText:data];
  }
  else {
    NSString *formattedData = [self formatData:data asFormat:format];
    if (formattedData) {
      printf("%s\n", formattedData.UTF8String);
    }
    else {
      printf("Invalid format specified: %s", [format UTF8String]);
    }
  }
}

- (void)outputPlainText:(id)data
{
  [self outputPlainText:data withIndent:@""];
}

- (void)outputPlainText:(id)data withIndent:(NSString *)indent
{
  if ([data isKindOfClass:[NSArray class]]) {
    for (id item in (NSArray *)data) {
      printf("%s%s\n", [indent UTF8String], [[item description] UTF8String]);
    }
  }
  else if ([data isKindOfClass:[NSDictionary class]]) {
    for (NSString *key in [(NSDictionary *)data allKeys]) {
      id value = [(NSDictionary *)data objectForKey:key];

      // Print key-value pair on the same line
      printf("%s%s:  ", [indent UTF8String], [key UTF8String]);

      if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        printf("%s\n", [[value description] UTF8String]);
      }
      else if ([value isKindOfClass:[NSArray class]]) {
        printf("\n");
        [self outputPlainText:value withIndent:[indent stringByAppendingString:@"    "]];
      }
      else if ([value isKindOfClass:[NSDictionary class]]) {
        printf("\n");
        [self outputPlainText:value withIndent:[indent stringByAppendingString:@"    "]];
      }
      else {
        printf("Unsupported Type\n");
      }
    }
  }
  else {
    printf("%s%s\n", [indent UTF8String], [[data description] UTF8String]);
  }
}

#pragma mark - List Disk (via GEOM Providers Info)

- (void)listDiskProviders:(NSArray<NSString *> *)arguments
{
  NSString *format = [self getOutputFormat:arguments];

  NSMutableDictionary *disksDictionary = [FBDiskManager getAllDiskInfo];
  [self outputData:disksDictionary withFormat:format];
}

#pragma mark - List Disk Names (with JSON & XML Options)

- (void)listDiskNames:(NSArray<NSString *> *)arguments
{
  NSString *format = [self getOutputFormat:arguments];

  NSArray *disks = [FBDiskManager getDiskNames];
  [self outputData:disks withFormat:format];
}

#pragma mark - Disk Info

- (void)diskInfo:(NSArray<NSString *> *)arguments
{
  if (arguments.count < 1) {
    printf("Usage: diskutil info <disk> [--json | --xml]\n");
    return;
  }

  NSString *format = [self getOutputFormat:arguments];
  NSString *diskName = arguments[0];

  // NSDictionary *diskInfo = @{ @"disk": diskName, @"info": @"Sample Disk Info"
  // }; // Placeholder
  NSMutableDictionary *diskInfo = [FBDiskManager getDiskInfo:diskName];
  [self outputData:diskInfo withFormat:format];
}

#pragma mark - Mount Disk (No JSON/XML Output)

- (void)mountDisk:(NSArray<NSString *> *)arguments
{
  if (arguments.count < 1) {
    printf("Usage: diskutil mount <disk> [--readonly]\n");
    return;
  }

  NSString *diskName = arguments[0];
  BOOL readOnly = [self hasFlag:@"--readonly" inArguments:arguments];

  if (readOnly) {
    printf("Mounting %s as read-only...\n", [diskName UTF8String]);
  }
  else {
    printf("Mounting %s...\n", [diskName UTF8String]);
  }
}

#pragma mark - Unmount Disk (No JSON/XML Output)

- (void)unmountDisk:(NSArray<NSString *> *)arguments
{
  if (arguments.count < 1) {
    printf("Usage: diskutil unmount <disk>\n");
    return;
  }

  NSString *diskName = arguments[0];
  printf("Unmounting disk: %s\n", [diskName UTF8String]);
}

#pragma mark - Helper Methods

- (NSString *)getOutputFormat:(NSArray<NSString *> *)arguments
{
  if ([self hasFlag:@"--json" inArguments:arguments]) {
    return @"json";
  }
  if ([self hasFlag:@"--xml" inArguments:arguments]) {
    return @"xml";
  }
  return @"text"; // Default to plain text
}

- (BOOL)hasFlag:(NSString *)flag inArguments:(NSArray<NSString *> *)arguments
{
  return [arguments containsObject:flag];
}

- (void)printUsage
{
  printf("Usage: diskutil <command> [options]\n");
  printf("Available commands:\n");
  printf("  list       - List available disks with provider info [--json | "
         "--xml]\n");
  printf("  listDisks                    - List available disks [--json | "
         "--xml]\n");
  printf("  info <disk>             - Show disk information [--json | --xml]\n");
  printf("  mount <disk> [--readonly] - Mount a disk\n");
  printf("  unmount <disk>          - Unmount a disk\n");
}

@end
