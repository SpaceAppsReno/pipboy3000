/*
 *  deviceCellTemplate.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "deviceCellTemplate.h"

@implementation deviceCellTemplate

@synthesize deviceName,deviceInfo,deviceIcon;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        // Initialization code
        self.deviceName = [[UILabel alloc] init];
        self.deviceName.textAlignment = NSTextAlignmentLeft;
        self.deviceName.font = [UIFont boldSystemFontOfSize:14];
        
        self.deviceInfo = [[UILabel alloc] init];
        self.deviceInfo.textAlignment = NSTextAlignmentLeft;
        self.deviceInfo.font = [UIFont boldSystemFontOfSize:8];
        
        self.deviceIcon = [[UIImageView alloc] init];
        [self.deviceIcon setAutoresizingMask:UIViewAutoresizingNone];
        self.deviceIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.deviceName];
        [self.contentView addSubview:self.deviceInfo];
        [self.contentView addSubview:self.deviceIcon];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect fr;
    
    fr = CGRectMake(boundsX + 10, 2, 45, 45);
    self.deviceIcon.frame = fr;
    
    fr = CGRectMake(boundsX + 70, 5, self.contentView.bounds.size.width - 100, 25);
    self.deviceName.frame = fr;
    
    fr = CGRectMake(boundsX + 70, 30,self.contentView.bounds.size.width - 100, 15);
    self.deviceInfo.frame = fr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation serviceWithoutPeriodCellTemplate

@synthesize serviceName;
@synthesize serviceOnOffButton;
@synthesize height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height = 50;
        self.serviceName = [[UILabel alloc] init];
        self.serviceName.textAlignment = NSTextAlignmentLeft;
        self.serviceName.font = [UIFont boldSystemFontOfSize:17];
        self.serviceName.backgroundColor = [UIColor clearColor];
        
        self.serviceOnOffButton = [[UISwitch alloc] init];
        self.serviceOnOffButton.enabled = YES;
        self.serviceOnOffButton.hidden = NO;
        
        [self.contentView addSubview:self.serviceOnOffButton];
        [self.contentView addSubview:self.serviceName];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect fr;
    
    if (contentRect.size.width < WIDTH_CHECKER) {
        self.serviceName.font = [UIFont boldSystemFontOfSize:12];
        fr = CGRectMake(boundsX + 10, 10, 300, 30);
        self.serviceName.frame = fr;
    }
    else {
        self.serviceName.font = [UIFont boldSystemFontOfSize:17];
        fr = CGRectMake(boundsX + 10, 10, 300, 30);
        self.serviceName.frame = fr;
    }
    fr = CGRectMake(boundsX + contentRect.size.width - 90, 10, 100, 30);
    self.serviceOnOffButton.frame = fr;
    
}

@end

@implementation serviceWithPeriodCellTemplate

@synthesize serviceName;
@synthesize serviceOnOffButton;
@synthesize servicePeriodSlider;
@synthesize servicePeriodMax;
@synthesize servicePeriodMin;
@synthesize servicePeriodCur;
@synthesize height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height = 100;
        self.serviceName = [[UILabel alloc] init];
        self.serviceName.textAlignment = NSTextAlignmentLeft;
        self.serviceName.font = [UIFont boldSystemFontOfSize:17];
        self.serviceName.backgroundColor = [UIColor clearColor];

        self.serviceOnOffButton = [[UISwitch alloc] init];
        self.serviceOnOffButton.enabled = YES;
        self.serviceOnOffButton.hidden = NO;
        
        self.servicePeriodSlider = [[UISlider alloc] init];
        self.servicePeriodSlider.enabled = YES;
        self.servicePeriodSlider.hidden = NO;
        [self.servicePeriodSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
        
        self.servicePeriodMax = [[UILabel alloc] init];
        self.servicePeriodMax.textAlignment = NSTextAlignmentLeft;
        self.servicePeriodMax.font = [UIFont systemFontOfSize:16];
        self.servicePeriodMax.backgroundColor = [UIColor clearColor];

        self.servicePeriodMin = [[UILabel alloc] init];
        self.servicePeriodMin.textAlignment = NSTextAlignmentLeft;
        self.servicePeriodMin.font = [UIFont systemFontOfSize:16];
        self.servicePeriodMin.backgroundColor = [UIColor clearColor];
        
        self.servicePeriodCur = [[UILabel alloc] init];
        self.servicePeriodCur.textAlignment = NSTextAlignmentLeft;
        self.servicePeriodCur.font = [UIFont systemFontOfSize:16];
        self.servicePeriodCur.backgroundColor = [UIColor clearColor];
        
        
        [self.contentView addSubview:self.serviceOnOffButton];
        [self.contentView addSubview:self.serviceName];
        [self.contentView addSubview:self.servicePeriodSlider];
        [self.contentView addSubview:self.servicePeriodMax];
        [self.contentView addSubview:self.servicePeriodMin];
        [self.contentView addSubview:self.servicePeriodCur];
        
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect fr;
    NSLog(@"Frame : %f,%f,%f,%f ",contentRect.origin.x,contentRect.origin.y,contentRect.size.width,contentRect.size.height);
    if (self.contentView.bounds.size.width < WIDTH_CHECKER) self.height = 100;
    else self.height = 50;
    
    if (contentRect.size.width < WIDTH_CHECKER) {
        fr = CGRectMake(boundsX + 10, 10, 300, 30);
        self.serviceName.frame = fr;
        
        fr = CGRectMake(boundsX + contentRect.size.width - 90, 10, 100, 30);
        self.serviceOnOffButton.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 80, 63, 160, 30);
        self.servicePeriodSlider.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 130, 63, 160, 30);
        self.servicePeriodMin.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) + 90, 63, 160, 30);
        self.servicePeriodMax.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 30, 40, 160, 30);
        self.servicePeriodCur.frame = fr;
    }
    else {
        fr = CGRectMake(boundsX + 10, 10, 300, 30);
        self.serviceName.frame = fr;
        
        fr = CGRectMake(boundsX + contentRect.size.width - 90, 10, 100, 30);
        self.serviceOnOffButton.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 80, 3, 160, 30);
        self.servicePeriodSlider.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 130, 3, 160, 30);
        self.servicePeriodMin.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) + 90, 3, 160, 30);
        self.servicePeriodMax.frame = fr;
        
        fr = CGRectMake(boundsX + (contentRect.size.width / 2) - 30, 25, 160, 30);
        self.servicePeriodCur.frame = fr;
    }
    
}

-(IBAction)updateSliderValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.servicePeriodCur.text = [NSString stringWithFormat: @"%0.0fms",[slider value]];
}

@end

@implementation temperatureCellTemplate

@synthesize temperature,temperatureIcon,temperatureLabel,temperatureGraph,temperatureGraphHolder,height;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = 150;
        
        // Initialization code
        self.temperatureLabel = [[UILabel alloc] init];
        self.temperatureLabel.textAlignment = NSTextAlignmentLeft;
        self.temperatureLabel.font = [UIFont boldSystemFontOfSize:17];
        self.temperatureLabel.backgroundColor = [UIColor clearColor];
        
        self.temperature = [[UILabel alloc] init];
        self.temperature.textAlignment = NSTextAlignmentRight;
        self.temperature.font = [UIFont boldSystemFontOfSize:18];
        self.temperature.textColor = [UIColor blackColor];
        self.temperature.backgroundColor = [UIColor clearColor];
        
        self.temperatureIcon = [[UIImageView alloc] init];
        self.temperatureIcon.image = [UIImage imageNamed:@"temperature.png"];
        [self.temperatureIcon setAutoresizingMask:UIViewAutoresizingNone];
        self.temperatureIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.temperatureGraph = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 0, 100, 8)];
        self.temperatureGraph.progress = 1.0f;
        self.temperatureGraph.transform = CGAffineTransformRotate(self.temperatureGraph.transform, -M_PI/2.0);
        self.temperatureGraph.progressTintColor = [UIColor blueColor];
        self.temperatureGraphHolder = [[UIView alloc] init];
        [self.temperatureGraphHolder addSubview:self.temperatureGraph];
        
        [self.contentView addSubview:self.temperatureLabel];
        [self.contentView addSubview:self.temperature];
        [self.contentView addSubview:self.temperatureIcon];
        [self.contentView addSubview:self.temperatureGraphHolder];

        
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect fr;
  
    if (contentRect.size.width < WIDTH_CHECKER) {
        fr = CGRectMake(boundsX + 5, 25, 70, 100);
        self.temperatureIcon.frame = fr;
        
        fr = CGRectMake(boundsX, 5, self.contentView.bounds.size.width, 25);
        self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
        self.temperatureLabel.frame = fr;
        
        fr = CGRectMake(boundsX + self.contentView.bounds.size.width - 5, 61,-100, 25);
        self.temperature.frame = fr;
        
        fr = CGRectMake((contentRect.origin.x + (contentRect.size.width / 2 ) - 75), 80,95,50);
        self.temperatureGraphHolder.frame = fr;
    }
    else {
        fr = CGRectMake(boundsX + 5, 25, 70, 100);
        self.temperatureIcon.frame = fr;
        
        fr = CGRectMake(boundsX + 80, 60, self.contentView.bounds.size.width - 100, 25);
        self.temperatureLabel.frame = fr;
        
        fr = CGRectMake(boundsX + self.contentView.bounds.size.width - 5, 61,-100, 25);
        self.temperature.frame = fr;
        
        fr = CGRectMake(boundsX + self.contentView.bounds.size.width - 250, 75,100,50);
        self.temperatureGraphHolder.frame = fr;
    }
}


@end

@implementation accelerometerCellTemplate

@synthesize accLabel,accIcon,accValueX,accValueY,accValueZ,accGraphX,accGraphY,accGraphZ,accGraphHolder,accCalibrateButton,height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = 250;
        
        // Initialization code
        self.accLabel = [[UILabel alloc] init];
        self.accLabel.textAlignment = NSTextAlignmentLeft;
        self.accLabel.font = [UIFont boldSystemFontOfSize:17];
        self.accLabel.backgroundColor = [UIColor clearColor];
        
        self.accIcon = [[UIImageView alloc] init];
        self.accIcon.image = [UIImage imageNamed:@"accelerometer.png"];
        [self.accIcon setAutoresizingMask:UIViewAutoresizingNone];
        self.accIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.accValueX = [[UILabel alloc] init];
        self.accValueX.textAlignment = NSTextAlignmentRight;
        self.accValueX.font = [UIFont boldSystemFontOfSize:17];
        self.accValueX.backgroundColor = [UIColor clearColor];
        
        self.accValueY = [[UILabel alloc] init];
        self.accValueY.textAlignment = NSTextAlignmentRight;
        self.accValueY.font = [UIFont boldSystemFontOfSize:17];
        self.accValueY.backgroundColor = [UIColor clearColor];
        
        self.accValueZ = [[UILabel alloc] init];
        self.accValueZ.textAlignment = NSTextAlignmentRight;
        self.accValueZ.font = [UIFont boldSystemFontOfSize:17];
        self.accValueZ.backgroundColor = [UIColor clearColor];
        
        self.accGraphX = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 8)];
        self.accGraphX.progress = 1.0f;
        self.accGraphX.transform = CGAffineTransformRotate(self.accGraphX.transform, -M_PI/2.0);
        self.accGraphX.progressTintColor = [UIColor blueColor];

        self.accGraphY = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 0, 100, 8)];
        self.accGraphY.progress = 1.0f;
        self.accGraphY.transform = CGAffineTransformRotate(self.accGraphY.transform, -M_PI/2.0);
        self.accGraphY.progressTintColor = [UIColor greenColor];
        
        self.accGraphZ = [[UIProgressView alloc] initWithFrame:CGRectMake(60, 0, 100, 8)];
        self.accGraphZ.progress = 1.0f;
        self.accGraphZ.transform = CGAffineTransformRotate(self.accGraphZ.transform, -M_PI/2.0);
        self.accGraphZ.progressTintColor = [UIColor redColor];
        
        self.accGraphHolder = [[UIView alloc] init];
        [self.accGraphHolder addSubview:self.accGraphX];
        [self.accGraphHolder addSubview:self.accGraphY];
        [self.accGraphHolder addSubview:self.accGraphZ];
        UILabel *legendX = [[UILabel alloc] initWithFrame:CGRectMake(45, 60, 15, 15)];
        legendX.text = @"X";
        legendX.backgroundColor = [UIColor clearColor];
        [self.accGraphHolder addSubview:legendX];
        UILabel *legendY = [[UILabel alloc] initWithFrame:CGRectMake(75, 60, 15, 15)];
        legendY.text = @"Y";
        legendY.backgroundColor = [UIColor clearColor];
        [self.accGraphHolder addSubview:legendY];
        UILabel *legendZ = [[UILabel alloc] initWithFrame:CGRectMake(105, 60, 15, 15)];
        legendZ.text = @"Z";
        legendZ.backgroundColor = [UIColor clearColor];
        [self.accGraphHolder addSubview:legendZ];
        
        
        self.accCalibrateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.accCalibrateButton setTitle:@"Calibrate" forState:UIControlStateNormal];
        
        
        
        [self.contentView addSubview:self.accLabel];
        [self.contentView addSubview:self.accIcon];
        [self.contentView addSubview:self.accValueX];
        [self.contentView addSubview:self.accValueY];
        [self.contentView addSubview:self.accValueZ];
        [self.contentView addSubview:self.accGraphHolder];
        [self.contentView addSubview:self.accCalibrateButton];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGRect fr;

    if (self.contentView.bounds.size.width < WIDTH_CHECKER) self.height = 220;
    else self.height = 150;
    
    if (contentRect.size.width < WIDTH_CHECKER) {
    
        fr = CGRectMake(contentRect.origin.x + 5, 55, 70, 100);
        self.accIcon.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x, 5, self.contentView.bounds.size.width, 25);
        self.accLabel.textAlignment = NSTextAlignmentCenter;
        self.accLabel.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + self.contentView.bounds.size.width - 5, 61, -100, 25);
        self.accValueX.frame = fr;
        fr.origin.y += 35;
        self.accValueY.frame = fr;
        fr.origin.y += 35;
        self.accValueZ.frame = fr;
        
        fr = CGRectMake((contentRect.origin.x + (contentRect.size.width / 2 ) - 75), 85,95,50);
        self.accGraphHolder.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + (self.contentView.bounds.size.width / 2) - 65,170,150,35);
        self.accCalibrateButton.frame = fr;

    }
    else {
        fr = CGRectMake(contentRect.origin.x + 5, 25, 70, 100);
        self.accIcon.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + 80, 60, self.contentView.bounds.size.width - 100, 25);
        self.accLabel.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + self.contentView.bounds.size.width - 5, 21, -100, 25);
        self.accValueX.frame = fr;
        fr.origin.y += 40;
        self.accValueY.frame = fr;
        fr.origin.y += 40;
        self.accValueZ.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + self.contentView.bounds.size.width - 250, 60,100,50);
        self.accGraphHolder.frame = fr;
        
        fr = CGRectMake(contentRect.origin.x + self.contentView.bounds.size.width - 400,65,150,35);
        self.accCalibrateButton.frame = fr;
        
    }
    
}

@end


