//
//  PFMapViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 7/31/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

#import "PFRatreeSamosornApi.h"

@protocol PFMapViewControllerDelegate <NSObject>

- (void) PFMapViewControllerBack;

@end

@interface PFMapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) IBOutlet PFMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *name;

@end
