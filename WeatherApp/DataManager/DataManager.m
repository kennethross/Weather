//
//  DataManager.m
//  WeatherApp
//
//  Created by kenneth palermo on 12/18/17.
//  Copyright © 2017 kenneth palermo. All rights reserved.
//

#import "DataManager.h"
#import <Realm/Realm.h>

@implementation DataManager

@end

@implementation WeatherItem
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        self.code = @([dict[@"code"] integerValue]);
        self.date = dict[@"date"];
        self.conditionTemp = [dict[@"temp"] floatValue];
        self.conditionText = dict[@"text"]; //Probably need to use date library for easier converting
    }
    
    return self;
}
@end

@implementation ForecastItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        self.code = @([dict[@"code"] integerValue]);
        self.date = dict[@"date"];
        self.day = dict[@"day"];
        self.high = [dict[@"high"] integerValue];
        self.low = [dict[@"low"] integerValue];
        self.text = dict[@"text"];
    }
    
    return self;
}
@end

RLM_ARRAY_TYPE(ForecastItem)

@implementation Location

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if(self){
        self.city = dict[@"city"];
        self.country = dict[@"country"];
        self.region = dict[@"region"];
    }
    
    return self;
}
@end
