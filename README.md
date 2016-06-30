![deltaDNA logo](https://deltadna.com/wp-content/uploads/2015/06/deltadna_www@1x.png)

## deltaDNA Analytics iOS SDK

[![Build Status](https://travis-ci.org/deltaDNA/ios-sdk.svg?branch=master)](https://travis-ci.org/deltaDNA/ios-sdk)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies using 3rd party libraries.

#### Podfile

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/deltaDNA/CocoaPods.git'

platform :ios, '7.0'

pod 'DeltaDNA', '~> 4.1'
```

The deltaDNA SDKs are available from our private spec repository, its url must be added as a source to your podfile.  

### Installation as a Framework

Open DeltaDNA.xcworkspace.  The DeltaDNA project contains targets to build iOS and tvOS frameworks.  Once built, drag the framework into your project.  The example project shows how to do this in XCode.

### Usage

Include the SDK header files.

```objective-c
#include <DeltaDNA/DeltaDNA.h>
```

Start the analytics SDK.

```objective-c
[DDNASDK sharedInstance].clientVersion = @"1.0";

[[DDNASDK sharedInstance] startWithEnvironmentKey:@"YOUR_ENVIRONMENT_KEY"
                                       collectURL:@"YOUR_COLLECT_URL"
                                        engageURL:@"YOUR_ENGAGE_URL"];

```

On the first run it will create a new user id and send a `newPlayer` event.  On every call it will send a `gameStarted` and `clientDevice` event.

#### iOS 9 Support

Since iOS 9, all HTTP connections are forced to be HTTPS.  To allow HTTP to be used you need to add the following key to your Info.plist file.

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Example

The DeltaDNA Example project shows how to use our analytics platform within your game.  The iOS example shows how to call it from Objective-C, the tvOS example with Swift.

### Custom Events

You can easily record custom events by using the `DDNAEvent` class.  Create a `DDNAEvent` with the name of your event schema.  Call `setParam:forKey` to add event parameters.  For example:

```objective-c
DDNAEvent *event = [DDNAEvent eventWithName:@"keyTypes"];
[event setParam:@5 forKey:@"userLevel"];
[event setParam:@YES forKey:@"isTutorial"];
[event setParam:[NSDate date] forKey:@"exampleTimestamp"];

[[DDNASDK sharedInstance] recordEvent:event];
```

### Engage

Change the behaviour of the game with an engagement.  Create a `DDNAEngagement` with the name of your decision point.  Engage will respond with a dictionary of key values for your player.  Depending on how the Engage campaign has been built on the platform, the response will look something like:

```json
{
    "parameters":{},
    "image":{},
    "heading":"An optional heading",
    "message":"An optional message"
}
```

The `parameters` key is always present if the request to Engage was successful, but will be empty if no parameters were returned.  The image, heading and message are optional.  The game can look in the parameters to customise it's behaviour for the player.

For example:

```objective-c
DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"gameLoaded"];
[engagement setParam:@4 forKey:@"userLevel"];
[engagement setParam:@1000 forKey:@"experience"];
[engagement setParam:@"Disco Volante" forKey:@"missionName"];

[[DDNASDK sharedInstance] requestEngagement:engagement completionHandler:^(NSDictionary* parameters, NSInteger statusCode, NSError* error) {
    NSLog(@"Engagement request returned the following parameters:\n%@", parameters[@"parameters"]);
}];
```

#### Image Message

One of the actions Engage supports is an Image Message.  This displays a custom popup on the game screen.  To test if Engage returned an Image Message you can create one from a `DDNAEngagement`.  If no image is defined for the Engagement, the Image Message will be nil.  The following shows how you can dynamically display an image popup depending on Engage's response.

```objective-c
DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"imageMessage"];

[[DDNASDK sharedInstance] requestEngagement:engagement engagementHandler:^(DDNAEngagement* response) {

    DDNAImageMessage* imageMessage = [DDNAImageMessage imageMessageWithEngagement:response delegate:self];
    if (imageMessage != nil) {
        // Engagement contained a valid image message response!
        [imageMessage fetchResources];
        // -didReceiveResourcesForImageMessage will be called once the resources are available.
    }
    else {
        NSLog(@"Engage response did not contain an image message.");
    }
}];
```

### Further Integration

Refer to our [documentation](http://docs.deltadna.com/advanced-integration/ios-sdk/) site for more details on how to use the SDK.

## License

The sources are available under the Apache 2.0 license.
