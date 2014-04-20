//
//  CommViewController.h
//  pipboy3000
//
//  Created by Colin Loretz on 4/12/14.
//  Copyright (c) 2014 Reno Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *activeButton;

-(IBAction)gotoStats:(id)sender;
-(IBAction)gotoComm:(id)sender;
-(IBAction)gotoMap:(id)sender;

@end
