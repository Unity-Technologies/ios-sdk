//
//  DDNACache.m
//  DeltaDNA
//
//  Created by David White on 05/02/2016.
//
//

#import "DDNACache.h"
#import "DDNALog.h"

static NSString *const kCacheName = @"Cache.plist";

@interface DDNACache ()

@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, copy) NSString *cacheLocation;

@end

@implementation DDNACache

+ (instancetype)sharedCache
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init
{
    if ((self = [super init])) {
        self.cacheLocation = [self getCacheLocation];
        self.cache = [NSMutableDictionary dictionaryWithContentsOfFile:self.cacheLocation];
        if (!self.cache) {
            self.cache = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (void)setObject:(NSObject *)object forKey:(NSString *)key
{
    @try {
        if (object != nil) {
            [self.cache setObject:object forKey:key];
            [self.cache writeToFile:self.cacheLocation atomically:YES];
        }
    }
    @catch (NSException *exception) {
        DDNALogDebug(@"Error saving to cache: %@", exception.reason);
    }
}

- (id)objectForKey:(NSString *)key
{
    return [self.cache objectForKey:key];
}

- (void)clear
{
    [self.cache removeAllObjects];
    [self.cache writeToFile:self.cacheLocation atomically:YES];
}

- (NSString *)getCacheLocation
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"DeltaDNA"];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    return [documentsDirectory stringByAppendingPathComponent:kCacheName];
}

@end
