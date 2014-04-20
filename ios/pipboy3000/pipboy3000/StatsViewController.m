//
//  EnviroViewController.m
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import "StatsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "deviceSelector.h"
#import "AppDelegate.h"
#import "Sensors.h"
#import "AFHTTPRequestOperation.h"


@interface TCMessage : NSObject

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, readonly)  BOOL fromMe;

@end

@interface StatsViewController ()

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.activeButton layer] setBorderWidth:2.0f];
    [[self.activeButton layer] setBorderColor:[UIColor colorWithRed:0.000 green:1.000 blue:0.020 alpha:1.].CGColor];
    
    [self setupObservers];
    
    //LOCATION
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    self.currentLocation = [self.locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [self.currentLocation coordinate];
    
    float latitude=coordinate.latitude;
    float longitude=coordinate.longitude;
    
    NSString* formattedLat = [NSString stringWithFormat:@"%.02f", latitude];
    NSString* formattedLng = [NSString stringWithFormat:@"%.02f", longitude];
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@ °N, %@ °W", formattedLat, formattedLng];
    
    [self reconnect];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    /*self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;*/
}


- (void)reconnect
{
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.1.89:3000"]]];
    self.webSocket.delegate = self;
    
    NSLog(@"Connecting to socket");
    [self.webSocket open];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    float latitude=coordinate.latitude;
    float longitude=coordinate.longitude;
    
    double altitude = [newLocation altitude];
    
    NSString* formattedLat = [NSString stringWithFormat:@"%.02f", latitude];
    NSString* formattedLng = [NSString stringWithFormat:@"%.02f", longitude];
    NSString* formattedAlt = [NSString stringWithFormat:@"%.0f", altitude];
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@ °N, %@ °W", formattedLat, formattedLng];
    
    self.altitudeLabel.text = [NSString stringWithFormat:@"%@ m", formattedAlt];
    
    [self updateHeartRate];
    [self updateRadiation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotoStats:(id)sender
{
    [self.tabBarController setSelectedIndex:0];
}

-(IBAction)gotoComm:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction)gotoMap:(id)sender
{
    [self.tabBarController setSelectedIndex:2];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)updateHeartRate
{
    int lowerBound = 70;
    int upperBound = 80;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    self.bpmLabel.text = [NSString stringWithFormat:@"%d bpm", rndValue];
}

- (void)updateRadiation
{
    /*
     
    ADD IN PINOCCIO API KEY IF USING PINOCCIO. PINOCCIO DISABLED FOR PUBLIC RELEASE TO GITHUB. Radiation being simulated using random number generator instead.
     
    NSURL *URL = [NSURL URLWithString:@"https://api.pinocc.io/v1/2/3/command/print+g?token=<INSERT API KEY HERE>"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON From Pinoccio!: %@", responseObject);
        
        id response = [responseObject objectForKey:@"data"];
        
        int radValue = (int)[response objectForKey:@"reply"];
        
        self.radiationLabel.text = [NSString stringWithFormat:@"%d", radValue];
        //[self.radBar setBounds:CGRectMake(123, 267, newWidth, self.radBar.bounds.size.height)];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
     */

    
    float randomNum = ((float)rand() / RAND_MAX) * 2;

    self.radiationLabel.text = [NSString stringWithFormat:@"%f mGy", randomNum];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* Observers */

- (void)setupObservers
{
    
    self.sensorTagObserver = [[NSNotificationCenter defaultCenter] addObserverForName:PIPsensorNotification object:nil queue:self.operationQueue usingBlock:^(NSNotification *note) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //Update the screen here
            
            NSDictionary *sensorValues = [note.userInfo objectForKey:@"sensorData"];
            
            NSLog(@"Data from sensors is : %@", sensorValues);
            
            sensorTagValues *vals = (sensorTagValues *)sensorValues;
            
            [self.thermometer setImage:[UIImage imageNamed:@"temperature_bulb"]];
            
            float atm = vals.press / 1013.25;
            
            NSString* fAmbientT = [NSString stringWithFormat:@"%.02f", vals.tAmb];
            NSString* fObjectT = [NSString stringWithFormat:@"%.02f", vals.tIR * 1.5];
            NSString* fHumidity = [NSString stringWithFormat:@"%.02f", vals.humidity];
            NSString* fPressure = [NSString stringWithFormat:@"%.02f", atm];
            
            float barHeight = (vals.tIR * 1.5) * 1.27;
            float ogOffset = self.tempBar.bounds.origin.y;
            float newOffset = ogOffset + (127-barHeight);
            
            NSLog(@"Height %f, Width: %f, X %f, Y %f", self.tempBar.bounds.size.height, self.tempBar.bounds.size.width, self.tempBar.bounds.origin.x, self.tempBar.bounds.origin.y);
            
            [self.tempBar setBounds:CGRectMake(self.tempBar.bounds.origin.x, newOffset, self.tempBar.bounds.size.width, barHeight)];
            [self.tempBar setAlpha:1];
            
            [self.ambientTempFollowLabel setBounds:CGRectMake(self.ambientTempFollowLabel.bounds.origin.x, newOffset, self.ambientTempFollowLabel.bounds.size.width, self.ambientTempFollowLabel.bounds.size.height)];
            [self.ambientTempFollowLabel setText:[NSString stringWithFormat:@"%@ C°", fObjectT]];
           
            self.ambientTempLabel.text = [NSString stringWithFormat:@"Ambient: %@ C°", fAmbientT];
            self.objectTempLabel.text = [NSString stringWithFormat:@"Object: %@ C°", fObjectT];
            self.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@%% rH", fHumidity];
            self.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %@ atm", fPressure];
            
            
            [self sendMessageToHQ:vals];
        }];
    }];
}

- (void)sendMessageToHQ:(sensorTagValues*)values
{
    NSDate *tstamp = [NSDate date];
   
    NSString *jsonMsg = [NSString stringWithFormat:@"{\"rad\":%d, \"location\":[%f,%f], \"altitude\":%f, \"temperature\":%f, \"object_temp\":%f,  \"humidity\":%f,  \"pressure\":%f, \"timestamp\":%f, \"heartrate\":%d}",
                         2,
                         self.currentLocation.coordinate.latitude,
                         self.currentLocation.coordinate.longitude,
                         self.currentLocation.altitude,
                         values.tAmb,
                         values.tIR * 1.5,
                         values.humidity,
                         values.press,
                         [tstamp timeIntervalSince1970],
                         70
                    ];
    
    if(self.webSocket){
        [self.webSocket send:jsonMsg];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.sensorTagObserver];
}


#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    [self.webSocket send:@"{}"];

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.webSocket = nil;
}


@end
