//
//  PEActivityCalendarViewController.h
//  ราตรีสโมสร
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "TKCalendarMonthTableViewController.h"
#import "TapkuLibrary.h"
#import "NSDate+Helper.h"
#import "AFNetworking.h"
#import "monthCell.h"

#import "PFActivityDetailViewController.h"

@protocol PFActivityCalendarViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFActivityCalendarViewController:(id)sender didRowSelect:(NSDictionary *)dict;

@end

@interface PFActivityCalendarViewController : TKCalendarMonthTableViewController

@property (assign, nonatomic) id delegate;
@property (nonatomic, strong) NSMutableArray *dataArray1;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *actArray;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableDictionary *stuDictionary;
@property (nonatomic, strong) NSMutableDictionary *actDictionary;
@property (nonatomic, strong) NSDictionary *obj;
@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *dateEnd;
@property (nonatomic, strong) NSMutableArray *allDataArray;

@property NSUserDefaults *calendarOffline;

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
