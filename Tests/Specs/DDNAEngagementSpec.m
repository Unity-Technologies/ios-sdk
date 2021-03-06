//
// Copyright (c) 2016 deltaDNA Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "DDNAEngagement.h"

SpecBegin(DDNAEngagement)

describe(@"engagement", ^{
    
    it(@"create without parameters", ^{
        
        DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"myDecisionPoint"];
        
        NSDictionary *result = @{
            @"decisionPoint": @"myDecisionPoint",
            @"flavour": @"engagement",
            @"parameters": @{}
        };
        
        expect([engagement.dictionary isEqualToDictionary:result]).to.beTruthy();
        
    });
    
    it(@"create with parameters", ^{
        
        DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"myDecisionPoint"];
        [engagement setParam:@5 forKey:@"level"];
        [engagement setParam:@"Kaboom!" forKey:@"ending"];
        
        NSDictionary *result = @{
            @"decisionPoint": @"myDecisionPoint",
            @"flavour": @"engagement",
            @"parameters": @{
                @"level": @5,
                @"ending": @"Kaboom!"
            }
        };
        
        expect([engagement.dictionary isEqualToDictionary:result]).to.beTruthy();
    });
    
    it(@"create with nested parameters", ^{
        
        DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"myDecisionPoint"];
        [engagement setParam:@{@"level2": @{@"yo!": @"greeting"}} forKey:@"level1"];
        
        NSDictionary *result = @{
            @"decisionPoint": @"myDecisionPoint",
            @"flavour": @"engagement",
            @"parameters": @{
                @"level1": @{
                    @"level2": @{
                        @"yo!": @"greeting"
                    }
                }
            }
        };
        
        expect([engagement.dictionary isEqualToDictionary:result]).to.beTruthy();
        
    });
    
    it(@"throws if decisionPoint is nil or empty", ^{
        
        expect(^{[DDNAEngagement engagementWithDecisionPoint:nil];}).to.raiseWithReason(NSInvalidArgumentException, @"decisionPoint cannot be nil or empty");
        
        expect(^{[DDNAEngagement engagementWithDecisionPoint:@""];}).to.raiseWithReason(NSInvalidArgumentException, @"decisionPoint cannot be nil or empty");
    });
    
    it(@"json is empty if raw is not json", ^{
        
        DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"myDecisionPoint"];
        engagement.raw = @"Not valid JSON";
        
        expect(engagement.raw).to.equal(@"Not valid JSON");
        expect([engagement.json isEqualToDictionary:@{}]).to.beTruthy();
        
    });
    
    it(@"json is valid if raw is json", ^{
       
        DDNAEngagement *engagement = [DDNAEngagement engagementWithDecisionPoint:@"myDecisionPoint"];
        engagement.raw = @"{\"x\": 1,\"y\": \"Hello\",\"z\": [{\"1\": \"a\"}]}";
        
        expect(engagement.raw).to.equal(@"{\"x\": 1,\"y\": \"Hello\",\"z\": [{\"1\": \"a\"}]}");
        expect(engagement.json).toNot.beNil();
    
        NSDictionary *result = @{
            @"x": @1,
            @"y": @"Hello",
            @"z": @[@{ @"1": @"a" }]
        };
        
        expect([engagement.json isEqualToDictionary:result]).to.beTruthy();
        
    });
    
});

SpecEnd