//
//  EnviroViewController.h
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SRWebSocket.h"
#import "Sensors.h"

@interface StatsViewController : UIViewController <CLLocationManagerDelegate, SRWebSocketDelegate>

@property (nonatomic, strong) IBOutlet UIButton *activeButton;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *altitudeLabel;
@property (nonatomic, strong) IBOutlet UILabel *bpmLabel;
@property (nonatomic, strong) IBOutlet UILabel *ambientTempLabel;
@property (nonatomic, strong) IBOutlet UILabel *ambientTempFollowLabel;
@property (nonatomic, strong) IBOutlet UILabel *objectTempLabel;
@property (nonatomic, strong) IBOutlet UILabel *humidityLabel;
@property (nonatomic, strong) IBOutlet UILabel *pressureLabel;
@property (nonatomic, strong) IBOutlet UILabel *radiationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *thermometer;
@property (nonatomic, strong) IBOutlet UIView *tempBar;
@property (nonatomic, strong) IBOutlet UIView *radBar;

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSMutableArray *messages;

- (void)reconnect;
- (void)sendMessageToHQ:(sensorTagValues*)values;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

-(IBAction)gotoStats:(id)sender;
-(IBAction)gotoComm:(id)sender;
-(IBAction)gotoMap:(id)sender;

- (void)updateHeartRate;

@property (nonatomic, strong) id sensorTagObserver;
- (void)setupObservers;

@end
