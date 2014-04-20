/*
 *  deviceCellTemplate.h
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import <UIKit/UIKit.h>

#define IPHONE_LANDSCAPE_WIDTH 548.0
#define IPHONE_PORTRAIT_WIDTH 300.0
#define IPAD_LANDSCAPE_WIDTH 934.0
#define IPAD_PORTRAIT_WIDTH 678.0
#define WIDTH_CHECKER (IPHONE_LANDSCAPE_WIDTH + 1.0)

@interface deviceCellTemplate : UITableViewCell {
    UILabel *deviceName;
    UILabel *deviceInfo;
    UIImageView *deviceIcon;
}

@property (nonatomic,retain) UILabel *deviceName;
@property (nonatomic,retain) UILabel *deviceInfo;
@property (nonatomic,retain) UIImageView *deviceIcon;

@end


@interface serviceWithoutPeriodCellTemplate : UITableViewCell {
    UILabel *serviceName;
    UISwitch *serviceOnOffButton;
    int height;
}

@property (nonatomic,retain) UILabel *serviceName;
@property (nonatomic,retain) UISwitch *serviceOnOffButton;
@property int height;

@end

@interface serviceWithPeriodCellTemplate : UITableViewCell {
    UILabel *serviceName;
    UISwitch *serviceOnOffButton;
    UISlider *servicePeriodSlider;
    UILabel *servicePeriodMax;
    UILabel *servicePeriodMin;
    UILabel *servicePeriodCur;
    int height;
}

@property (nonatomic,retain) UILabel *serviceName;
@property (nonatomic,retain) UISwitch *serviceOnOffButton;
@property (nonatomic,retain) UISlider *servicePeriodSlider;
@property (nonatomic,retain) UILabel *servicePeriodMax;
@property (nonatomic,retain) UILabel *servicePeriodMin;
@property (nonatomic,retain) UILabel *servicePeriodCur;
@property int height;

-(IBAction)updateSliderValue:(id)sender;

@end



@interface temperatureCellTemplate : UITableViewCell {
    UILabel *temperatureLabel;
    UIImageView *temperatureIcon;
    UILabel *temperature;
    UIProgressView *temperatureGraph;
    int height;
    UIView *temperatureGraphHolder;
}

@property (nonatomic,retain) UILabel *temperatureLabel;
@property (nonatomic,retain) UIImageView *temperatureIcon;
@property (nonatomic,retain) UILabel *temperature;
@property (nonatomic,retain) UIProgressView *temperatureGraph;
@property (nonatomic,retain)UIView *temperatureGraphHolder;

@property int height;
@end

@interface accelerometerCellTemplate : UITableViewCell {
    UILabel *accLabel;
    UIImageView *accIcon;
    UILabel *accValueX;
    UILabel *accValueY;
    UILabel *accValueZ;
    UIProgressView *accGraphX;
    UIProgressView *accGraphY;
    UIProgressView *accGraphZ;
    UIView *accGraphHolder;
    UIButton *accCalibrateButton;
    int height;
    
}

@property (nonatomic,retain) UILabel *accLabel;
@property (nonatomic,retain) UIImageView *accIcon;
@property (nonatomic,retain) UILabel *accValueX;
@property (nonatomic,retain) UILabel *accValueY;
@property (nonatomic,retain) UILabel *accValueZ;
@property (nonatomic,retain) UIProgressView *accGraphX;
@property (nonatomic,retain) UIProgressView *accGraphY;
@property (nonatomic,retain) UIProgressView *accGraphZ;
@property (nonatomic,retain) UIView *accGraphHolder;
@property (nonatomic,retain) UIButton *accCalibrateButton;
@property int height;

@end

