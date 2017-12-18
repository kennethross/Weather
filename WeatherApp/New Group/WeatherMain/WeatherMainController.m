//
//  WeatherMainController.m
//  WeatherApp
//
//  Created by kenneth palermo on 12/12/17.
//  Copyright © 2017 kenneth palermo. All rights reserved.
//

#import "WeatherMainController.h"
#import "CustomCell.h"
#import "AFHTTPSessionManager.h"

#import "DataManager.h"
#import "FTIndicator.h"
#import <Realm/Realm.h>

@interface WeatherMainController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *lblMainWeatherDate;
@property (strong, nonatomic) IBOutlet UILabel *lblMainTemperature;
@property (strong, nonatomic) IBOutlet UILabel *lblMainWeatherType;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Location * weatherLocation;
@property (strong, nonatomic) WeatherItem * weatherItem;
@property (strong, nonatomic) NSMutableArray <ForecastItem*> * forcastItems;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSArray<ForecastItem*> *tableItems;

@property (strong, nonatomic) RLMRealm *realm;
@end

@implementation WeatherMainController

- (NSArray<ForecastItem*>*)tableItems {
    if(_tableItems != nil){
        return _tableItems;
    }
    
    RLMResults <ForecastItem*> *result = [ForecastItem allObjects];
    
    if(result.count > 0){
        NSMutableArray * getItems = [NSMutableArray new];
        
        for (ForecastItem * item in result) {
            [getItems addObject:item];
        }
        _tableItems = [[NSArray alloc] initWithArray:getItems];
    }
    
    return _tableItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RLMResults <ForecastItem*> *result = [ForecastItem allObjects];
    if(result.count == 0){
        [self getDataFromAPI];
    }
    
    if(!self.realm){
        self.realm = [RLMRealm defaultRealm];
    }
}

- (void)refreshUI{
    [self.tableView reloadData];
    [self navBarTitleReset];
}

- (void)navBarTitleReset{
    self.lblTitle.text = [NSString stringWithFormat:@"%@, %@", self.weatherLocation.city, self.weatherLocation.country];
}

#pragma mark - GET DATA
-(void)getDataFromAPI {
    
        NSString *url = @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22singapore%2C%20sg%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
    
    [FTIndicator showProgressWithMessage:@"Getting Data"];
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            [FTIndicator showSuccessWithMessage:@"Done"];
            
            NSDictionary *resultDict;
            if([responseObject isKindOfClass:[NSData class]]){
                resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }else if([responseObject isKindOfClass:[NSDictionary class]]){
                NSLog(@"is an dict");
                resultDict = [[NSDictionary alloc] initWithDictionary:responseObject];
            }else if([responseObject isKindOfClass:[NSArray class]]){
                NSLog(@"array");
            }
            NSLog(@"NSDICT: %@", resultDict);
            
            [self processData:resultDict];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [FTIndicator showErrorWithMessage:error.localizedDescription];
        }];
}

- (void)processData:(NSDictionary*)dict {
    
    NSDictionary * query = dict[@"query"];
    NSDictionary *result = query[@"results"];
    NSDictionary * channel = result[@"channel"];
    NSDictionary * item = channel[@"item"];
    
    NSDictionary * condition = item[@"condition"];
    NSArray * forecast = item[@"forecast"];
    
    self.weatherItem = [[WeatherItem alloc] initWithDict:condition];
    self.weatherLocation = [[Location alloc] initWithDict:channel[@"location"]];
    
    for (int i = 0; i < forecast.count; i++) {
        ForecastItem * fItem = [[ForecastItem alloc] initWithDict:forecast[i]];
        [self.realm transactionWithBlock:^{
            [self.realm addObject:fItem];
        }];
    }
    
    [self refreshUI];
}

#pragma mark - UItableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableItems.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ForecastItem *item = self.tableItems[indexPath.row];

    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        cell.lblWeatherDate.text = [NSString stringWithFormat:@"%@", item.date];
    cell.lblWeatherTemp.text = [NSString stringWithFormat:@"%ld - %ld", (long)item.low, (long)item.high];
        cell.lblWeathertype.text = item.text;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

@end

