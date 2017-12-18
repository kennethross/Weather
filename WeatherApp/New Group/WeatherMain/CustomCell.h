//
//  CustomCell.h
//  WeatherApp
//
//  Created by kenneth palermo on 12/17/17.
//  Copyright © 2017 kenneth palermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblWeatherDate;
@property (strong, nonatomic) IBOutlet UILabel *lblWeatherTemp;
@property (strong, nonatomic) IBOutlet UILabel *lblWeathertype;

@end
