//
//  MapViewController.h
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <RMMapViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *activeButton;
@property (nonatomic, strong) IBOutlet UIView *mapTargetView;
@property (nonatomic, strong) RMMapView *mapboxView;

-(IBAction)gotoStats:(id)sender;
-(IBAction)gotoComm:(id)sender;
-(IBAction)gotoMap:(id)sender;

@end
