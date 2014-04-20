//
//  MapViewController.m
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    
    //MAPBOX
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"renocollective.hnpahpii"];
    self.mapboxView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, 568, 320) andTilesource:tileSource];
    [self.mapTargetView addSubview:self.mapboxView];
    
    [self.mapboxView setShowsUserLocation:YES];
    [self.mapboxView setUserInteractionEnabled:YES];
    [self.mapboxView setUserTrackingMode:RMUserTrackingModeFollow];
    
    [[self.activeButton layer] setBorderWidth:2.0f];
    [[self.activeButton layer] setBorderColor:[UIColor colorWithRed:0.000 green:1.000 blue:0.020 alpha:1.].CGColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
