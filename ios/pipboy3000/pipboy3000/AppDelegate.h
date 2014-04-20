//
//  AppDelegate.h
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PIPsensorNotification @"PipboySensorNotification"
#define PIPKnobNotification @"PipboyKnobNotification"
#define PIPLedNotification @"PipboyLedNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) id knobObserver;
@property (nonatomic, strong) id ledObserver;
- (void)setupPinoccioObservers;

@end
