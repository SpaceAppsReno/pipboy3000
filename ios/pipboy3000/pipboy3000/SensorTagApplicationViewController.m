/*
 *  SensorTagApplicationViewController.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "SensorTagApplicationViewController.h"
#import "AppDelegate.h"

@interface SensorTagApplicationViewController ()

@end

@implementation SensorTagApplicationViewController

@synthesize d;
@synthesize ambientTemp;
@synthesize sensorsEnabled;

-(id) initWithStyle:(UITableViewStyle)style andSensorTag:(BLEDevice *)andSensorTag {
    
    self = [super initWithStyle:style];
    if (self) {
        self.d = andSensorTag;    
        if (!self.ambientTemp){
            self.ambientTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Ambient temperature"];
            self.ambientTemp.temperatureIcon.image = [UIImage imageNamed:@"temperature.png"];
            self.ambientTemp.temperatureLabel.text = @"Ambient Temperature";
            self.ambientTemp.temperature.text = @"-.-°C";
        }
        if (!self.irTemp) {
            self.irTemp = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IR temperature"];
            self.irTemp.temperatureIcon.image = [UIImage imageNamed:@"objecttemperature.png"];
            self.irTemp.temperatureLabel.text = @"Object Temperature";
            self.irTemp.temperature.text = @"-.-°C";
        }
        if (!self.acc) {
            self.acc = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accelerometer"];
            self.acc.accLabel.text = @"Accelerometer";
            self.acc.accValueX.text = @"-";
            self.acc.accValueY.text = @"-";
            self.acc.accValueZ.text = @"-";
            self.acc.accCalibrateButton.hidden = YES;
        }
        if (!self.rH) {
            self.rH = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Relative humidity"];
            self.rH.temperatureIcon.image = [UIImage imageNamed:@"relativehumidity.png"];
            self.rH.temperatureLabel.text = @"Relative humidity";
            self.rH.temperature.text = @"-%rH";
        }
        if (!self.mag) {
            self.mag = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Magnetometer"];
            self.mag.accLabel.text = @"Magnetometer";
            self.mag.accIcon.image = [UIImage imageNamed:@"magnetometer.png"];
            self.mag.accValueX.text = @"-";
            self.mag.accValueY.text = @"-";
            self.mag.accValueZ.text = @"-";
            [self.mag.accCalibrateButton addTarget:self action:@selector(handleCalibrateMag) forControlEvents:UIControlEventTouchUpInside];
            self.magSensor = [[sensorMAG3110 alloc] init];
        }
        if (!self.baro) {
            self.baro = [[temperatureCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Barometer"];
            self.baro.temperatureLabel.text = @"Barometer";
            self.baro.temperatureIcon.image = [UIImage imageNamed:@"barometer.png"];
            self.baro.temperature.text = @"1000mBar";
        }
        if (!self.gyro) {
            self.gyro = [[accelerometerCellTemplate alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Gyroscope"];
            self.gyro.accLabel.text = @"Gyroscope";
            self.gyro.accIcon.image = [UIImage imageNamed:@"gyroscope.png"];
            self.gyro.accValueX.text = @"-";
            self.gyro.accValueY.text = @"-";
            self.gyro.accValueZ.text = @"-";
            [self.gyro.accCalibrateButton addTarget:self action:@selector(handleCalibrateGyro) forControlEvents:UIControlEventTouchUpInside];
            self.gyroSensor = [[sensorIMU3000 alloc] init];
        
        }
        

    }
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(alphaFader:) userInfo:nil repeats:YES];
    
    self.currentVal = [[sensorTagValues alloc]init];
    self.vals = [[NSMutableArray alloc]init];
    
    self.logInterval = 1.0; //1000 ms
    
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:self.logInterval target:self selector:@selector(logValues:) userInfo:nil repeats:YES];
    
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    if (!self.d.p.isConnected) {
        self.d.manager.delegate = self;
        [self.d.manager connectPeripheral:self.d.p options:nil];
    }
    else {
        self.d.p.delegate = self;
        [self configureSensorTag];
        self.title = @"TI BLE Sensor Tag application";
    }

    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {

}


-(void)viewWillDisappear:(BOOL)animated {
    [self deconfigureSensorTag];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    UIBarButtonItem *mailer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendMail:)];
    
    [self.navigationItem setRightBarButtonItem:mailer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = [self.sensorsEnabled objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"Ambient temperature"]) return self.ambientTemp.height;
    if ([cellType isEqualToString:@"IR temperature"]) return self.irTemp.height;
    if ([cellType isEqualToString:@"Accelerometer"]) return self.acc.height;
    if ([cellType isEqualToString:@"Humidity"]) return self.rH.height;
    if ([cellType isEqualToString:@"Magnetometer"]) return self.mag.height;
    if ([cellType isEqualToString:@"Barometer"]) return self.baro.height;
    if ([cellType isEqualToString:@"Gyroscope"]) return self.gyro.height;
    
    return 50;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Sensors";
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sensorsEnabled.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = [self.sensorsEnabled objectAtIndex:indexPath.row];
    
    if ([cellType isEqualToString:@"Ambient temperature"]) {
        
        return self.ambientTemp;
    }
    else if ([cellType isEqualToString:@"IR temperature"]) {
        return self.irTemp;
    }
    else if ([cellType isEqualToString:@"Accelerometer"]) {
        return self.acc;
    }
    else if ([cellType isEqualToString:@"Humidity"]) {
        return self.rH;
    }
    else if ([cellType isEqualToString:@"Barometer"]) {
        return self.baro;
    }
    else if ([cellType isEqualToString:@"Gyroscope"]) {
        return self.gyro;
    }
    else if ([cellType isEqualToString:@"Magnetometer"]) {
        return self.mag;
    }
    
    // Something has gone wrong, because we should never get here, return empty cell
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Unkown Cell"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
    }
    
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer period UUID"]];
        NSInteger period = [[self.d.setupData valueForKey:@"Accelerometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Accelerometer"];
    }
    
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Humidity"];
    }
    
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Issue calibration to the device 
        uint8_t data = 0x02;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer calibration UUID"]];
        [BLEUtility readCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID];
        [self.sensorsEnabled addObject:@"Barometer"];
    }
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x07;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Gyroscope"];
    }
    
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer period UUID"]];
        NSInteger period = [[self.d.setupData valueForKey:@"Magnetometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Magnetometer"];
    }
    
}

-(void) deconfigureSensorTag {
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Disable sensor
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
        
    }
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}



#pragma mark - CBCentralManager delegate function 

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"..");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]]) {
        [self configureSensorTag];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"Starting to discover services and characteristics");
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateValueForCharacteristic = %@",characteristic.UUID);
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]]]) {
        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
        float tObj = [sensorTMP006 calcTObj:characteristic.value];
        
        self.ambientTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tAmb];
        self.ambientTemp.temperature.textColor = [UIColor blackColor];
        self.ambientTemp.temperatureGraph.progress = (tAmb / 100.0) + 0.5;
        self.irTemp.temperature.text = [NSString stringWithFormat:@"%.1f°C",tObj];
        self.irTemp.temperatureGraph.progress = (tObj / 1000.0) + 0.5;
        self.irTemp.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.tAmb = tAmb;
        self.currentVal.tIR = tObj;
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]]]) {
        float x = [sensorKXTJ9 calcXValue:characteristic.value];
        float y = [sensorKXTJ9 calcYValue:characteristic.value];
        float z = [sensorKXTJ9 calcZValue:characteristic.value];
        
        self.acc.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fG",x];
        self.acc.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fG",y];
        self.acc.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fG",z];
        
        self.acc.accValueX.textColor = [UIColor blackColor];
        self.acc.accValueY.textColor = [UIColor blackColor];
        self.acc.accValueZ.textColor = [UIColor blackColor];
        
        self.acc.accGraphX.progress = (x / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphY.progress = (y / [sensorKXTJ9 getRange]) + 0.5;
        self.acc.accGraphZ.progress = (z / [sensorKXTJ9 getRange]) + 0.5;
        
        self.currentVal.accX = x;
        self.currentVal.accY = y;
        self.currentVal.accZ = z;
        
        NSLog(@"%f %f %f", x, y, z);
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Humidity data UUID"]]]) {

        float rHVal = [sensorSHT21 calcPress:characteristic.value];
        self.rH.temperature.text = [NSString stringWithFormat:@"%0.1f%%rH",rHVal];
        self.rH.temperatureGraph.progress = (rHVal / 100);
        self.rH.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.humidity = rHVal;
        
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Magnetometer data UUID"]]]) {
        
        float x = [self.magSensor calcXValue:characteristic.value];
        float y = [self.magSensor calcYValue:characteristic.value];
        float z = [self.magSensor calcZValue:characteristic.value];
        
        self.mag.accValueX.text = [NSString stringWithFormat:@"X: % 0.1fuT",x];
        self.mag.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1fuT",y];
        self.mag.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1fuT",z];
       
        self.mag.accValueX.textColor = [UIColor blackColor];
        self.mag.accValueY.textColor = [UIColor blackColor];
        self.mag.accValueZ.textColor = [UIColor blackColor];
        
        self.mag.accGraphX.progress = (x / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphY.progress = (y / [sensorMAG3110 getRange]) + 0.5;
        self.mag.accGraphZ.progress = (z / [sensorMAG3110 getRange]) + 0.5;
        
        self.currentVal.magX = x;
        self.currentVal.magY = y;
        self.currentVal.magZ = z;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer calibration UUID"]]]) {
        
        self.baroSensor = [[sensorC953A alloc] initWithCalibrationData:characteristic.value];
        
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer config UUID"]];
        //Issue normal operation to the device
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Barometer data UUID"]]]) {
        int pressure = [self.baroSensor calcPressure:characteristic.value];
        self.baro.temperature.text = [NSString stringWithFormat:@"%d mBar",pressure];
        self.baro.temperatureGraph.progress = ((float)((float)pressure - (float)800) / (float)400);
        self.baro.temperature.textColor = [UIColor blackColor];
        
        self.currentVal.press = pressure;
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]]]) {
        
        float x = [self.gyroSensor calcXValue:characteristic.value];
        float y = [self.gyroSensor calcYValue:characteristic.value];
        float z = [self.gyroSensor calcZValue:characteristic.value];
        
        self.gyro.accValueX.text = [NSString stringWithFormat:@"X: % 0.1f°/S",x];
        self.gyro.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1f°/S",y];
        self.gyro.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1f°/S",z];
        
        self.gyro.accValueX.textColor = [UIColor blackColor];
        self.gyro.accValueY.textColor = [UIColor blackColor];
        self.gyro.accValueZ.textColor = [UIColor blackColor];
        
        self.gyro.accGraphX.progress = (x / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphY.progress = (y / [sensorIMU3000 getRange]) + 0.5;
        self.gyro.accGraphZ.progress = (z / [sensorIMU3000 getRange]) + 0.5;
        
        self.currentVal.gyroX = x;
        self.currentVal.gyroY = y;
        self.currentVal.gyroZ = z;
    }
    
    NSDictionary *infoDictionary = @{@"sensorData" : self.currentVal};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PIPsensorNotification object:self userInfo:infoDictionary];
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}



- (IBAction) handleCalibrateMag {
    NSLog(@"Calibrate magnetometer pressed !");
    [self.magSensor calibrate];
}
- (IBAction) handleCalibrateGyro {
    NSLog(@"Calibrate gyroscope pressed ! ");
    [self.gyroSensor calibrate];
}

-(void) alphaFader:(NSTimer *)timer {
    CGFloat w,a;
    if (self.ambientTemp) {
        [self.ambientTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.ambientTemp.temperature.textColor = [self.ambientTemp.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.irTemp) {
        [self.irTemp.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.irTemp.temperature.textColor = [self.irTemp.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.acc) {
        [self.acc.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueX.textColor = [self.acc.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueY.textColor = [self.acc.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.acc.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.acc.accValueZ.textColor = [self.acc.accValueZ.textColor colorWithAlphaComponent:a];
    }
    if (self.rH) {
        [self.rH.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.rH.temperature.textColor = [self.rH.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.mag) {
        [self.mag.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueX.textColor = [self.mag.accValueX.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueY.textColor = [self.mag.accValueY.textColor colorWithAlphaComponent:a];
        
        [self.mag.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.mag.accValueZ.textColor = [self.mag.accValueZ.textColor colorWithAlphaComponent:a];
    }
    if (self.baro) {
        [self.baro.temperature.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.baro.temperature.textColor = [self.baro.temperature.textColor colorWithAlphaComponent:a];
    }
    if (self.gyro) {
        [self.gyro.accValueX.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueX.textColor = [self.gyro.accValueX.textColor colorWithAlphaComponent:a];
    
        [self.gyro.accValueY.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueY.textColor = [self.gyro.accValueY.textColor colorWithAlphaComponent:a];
    
        [self.gyro.accValueZ.textColor getWhite:&w alpha:&a];
        if (a > MIN_ALPHA_FADE) a -= ALPHA_FADE_STEP;
        self.gyro.accValueZ.textColor = [self.gyro.accValueZ.textColor colorWithAlphaComponent:a];
    }
}


-(void) logValues:(NSTimer *)timer {
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterMediumStyle];
    self.currentVal.timeStamp = date;
    sensorTagValues *newVal = [[sensorTagValues alloc]init];
    newVal.tAmb = self.currentVal.tAmb;
    newVal.tIR = self.currentVal.tIR;
    newVal.accX = self.currentVal.accX;
    newVal.accY = self.currentVal.accY;
    newVal.accZ = self.currentVal.accZ;
    newVal.gyroX = self.currentVal.gyroX;
    newVal.gyroY = self.currentVal.gyroY;
    newVal.gyroZ = self.currentVal.gyroZ;
    newVal.magX = self.currentVal.magX;
    newVal.magY = self.currentVal.magY;
    newVal.magZ = self.currentVal.magZ;
    newVal.press = self.currentVal.press;
    newVal.humidity = self.currentVal.humidity;
    newVal.timeStamp = date;
    
    [self.vals addObject:newVal];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"Finished with result : %u error : %@",result,error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sendMail:(id)sender {
    NSLog(@"Mail button pressed");
    NSMutableString *sensorData = [[NSMutableString alloc] init];
    [sensorData appendString:@"Timestamp,Ambient Temperature,IR Temperature,Accelerometer X-Axis,Accelerometer Y-Axis,Accelerometer Z-Axis,Barometric Pressure,Relative Humidity,Gyroscope X,Gyroscope Y,Gyroscope Z,Magnetometer X, Magnetometer Y, Magnetometer Z\n"];
    for (int ii=0; ii < self.vals.count; ii++) {
        sensorTagValues *s = [self.vals objectAtIndex:ii];
        [sensorData appendFormat:@"%@,%0.1f,%0.1f,%0.2f,%0.2f,%0.2f,%0.0f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f,%0.1f\n",s.timeStamp,s.tAmb,s.tIR,s.accX,s.accY,s.accZ,s.press,s.humidity,s.gyroX,s.gyroY,s.gyroZ,s.magX,s.magY,s.magZ];
    }
    
    MFMailComposeViewController *mFMCVC = [[MFMailComposeViewController alloc]init];
    if (mFMCVC) {
        if ([MFMailComposeViewController canSendMail]) {
            mFMCVC.mailComposeDelegate = self;
            [mFMCVC setSubject:@"Data from BLE Sensor"];
            [mFMCVC setMessageBody:@"Data from sensor" isHTML:NO];
            [self presentViewController:mFMCVC animated:YES completion:nil];
            
            [mFMCVC addAttachmentData:[sensorData dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/csv" fileName:@"Log.csv"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mail error" message:@"Device has not been set up to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}
@end
