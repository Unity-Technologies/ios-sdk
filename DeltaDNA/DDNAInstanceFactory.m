//
//  DDNAInstanceFactory.m
//  
//
//  Created by David White on 17/11/2015.
//
//

#import "DDNAInstanceFactory.h"
#import "DDNASDK.h"
#import "DDNAClientInfo.h"
#import "DDNANetworkRequest.h"
#import "DDNAEngageService.h"

@implementation DDNAInstanceFactory

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (DDNANetworkRequest *)buildNetworkRequestWithURL: (NSURL *)URL jsonPayload: (NSString *)jsonPayload delegate:(id<DDNANetworkRequestDelegate>)delegate
{
    DDNANetworkRequest *networkRequest = [[DDNANetworkRequest alloc] initWithURL:URL jsonPayload:jsonPayload];
    networkRequest.delegate = delegate;
    
    return networkRequest;
}

- (DDNAEngageService *)buildEngageService
{
    DDNASDK *ddnasdk = [DDNASDK sharedInstance];
    DDNAClientInfo *ddnaci = [DDNAClientInfo sharedInstance];
    
    DDNAEngageService *engageService = [[DDNAEngageService alloc] initWithEndpoint:ddnasdk.engageURL
                                                                    environmentKey:ddnasdk.environmentKey
                                                                        hashSecret:ddnasdk.hashSecret
                                                                            userID:ddnasdk.userID
                                                                         sessionID:ddnasdk.sessionID
                                                                           version:DDNA_ENGAGE_API_VERSION
                                                                        sdkVersion:DDNA_SDK_VERSION
                                                                          platform:ddnaci.platform
                                                                    timezoneOffset:ddnaci.timezoneOffset
                                                                      manufacturer:ddnaci.manufacturer
                                                            operatingSystemVersion:ddnaci.operatingSystemVersion];
    
    return engageService;
}

@end