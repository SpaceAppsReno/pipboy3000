//
//  AppDelegate.m
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupObservers
{
    
    self.knobObserver = [[NSNotificationCenter defaultCenter] addObserverForName:PIPKnobNotification object:nil queue:self.operationQueue usingBlock:^(NSNotification *note) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            NSLog(@"The knob changed!");
           
        }];
    }];
    
    self.ledObserver = [[NSNotificationCenter defaultCenter] addObserverForName:PIPLedNotification object:nil queue:self.operationQueue usingBlock:^(NSNotification *note) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSLog(@"Change the LEDS via Pinoccio!");
            
            //Read/write 0172c1b7c9684d019b1c16e74e7db2dc
            //Read only d68a8e6491b811913bcfb2d973fe0ed5
            
        }];
    }];
}

- (void)sendCommand:(NSString*)commandName toScout:(NSString*)scoutId inTroop:(NSString*)troopId withToken:(NSString*)token
{
    //led.blink(0, 255, 255)
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command?token=%@", troopId, scoutId, token]];
    
   // NSString *jsonCommand = @"{\"command\":\"led.blink(0, 255, 255)\"}";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON From Pinoccio!: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.knobObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.ledObserver];
}

@end
