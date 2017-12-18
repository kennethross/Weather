//
//  DataManager.h
//  WeatherApp
//
//  Created by kenneth palermo on 12/18/17.
//  Copyright © 2017 kenneth palermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface DataManager : NSObject

@end

@interface WeatherItem: RLMObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSNumber<RLMInt> * code;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic) CGFloat conditionTemp;
@property (nonatomic, strong) NSString * conditionText;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end

@interface ForecastItem: RLMObject

@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSNumber<RLMInt> * code;
@property (nonatomic, strong) NSString *day;
@property (nonatomic) NSInteger low;
@property (nonatomic) NSInteger high;
@property (nonatomic, strong) NSString * text;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface Location : RLMObject

@property (nonatomic, strong ) NSString * city;
@property (nonatomic, strong ) NSString * country;
@property (nonatomic, strong ) NSString * region;

- (instancetype)initWithDict:(NSDictionary*)dict;
@end
