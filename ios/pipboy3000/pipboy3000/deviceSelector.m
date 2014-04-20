/*
 *  deviceSelector.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "deviceSelector.h"

@interface deviceSelector ()

@end

@implementation deviceSelector
@synthesize m,nDevices,sensorTags;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"Init CoreBle");
        // Custom initialization
        self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.nDevices = [[NSMutableArray alloc]init];
        self.sensorTags = [[NSMutableArray alloc]init];
        self.title = @"Pip Boy 3000";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    self.m.delegate = self;

}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return sensorTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%d_Cell",indexPath.row]];
    CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",p.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",CFUUIDCreateString(nil, p.UUID)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.sensorTags.count > 1 )return [NSString stringWithFormat:@"%d SensorTags Found",self.sensorTags.count];
        else return [NSString stringWithFormat:@"%d SensorTag Found",self.sensorTags.count];
    }
    
    return @"";
}

-(float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 150.0f;
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BLEDevice *d = [[BLEDevice alloc]init];
    
    d.p = p;
    d.manager = self.m;
    d.setupData = [self makeSensorTagConfiguration];
    
    SensorTagApplicationViewController *vC = [[SensorTagApplicationViewController alloc]initWithStyle:UITableViewStyleGrouped andSensorTag:d];
    [self.navigationController pushViewController:vC animated:YES];
    
}




#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}




-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    /* iOS 6.0 bug workaround : connect to device before displaying UUID !
       The reason for this is that the CFUUID .UUID property of CBPeripheral
       here is null the first time an unkown (never connected before in any app)
       peripheral is connected. So therefore we connect to all peripherals we find.
    */
    
    //FIND THE PIP BOY
    if([[peripheral.identifier UUIDString] isEqual:@"603D1E3E-59A0-0185-2573-5DE2E0C3E83D"])
    {
        NSLog(@"Found the pip boy!");
            
        NSLog(@"Found a BLE Device : %@",peripheral);

        peripheral.delegate = self;

        [central connectPeripheral:peripheral options:nil];

        [self.nDevices addObject:peripheral];
        
        BLEDevice *d = [[BLEDevice alloc]init];
        
        d.p = peripheral;
        d.manager = self.m;
        d.setupData = [self makeSensorTagConfiguration];
        
        SensorTagApplicationViewController *vC = [[SensorTagApplicationViewController alloc]initWithStyle:UITableViewStyleGrouped andSensorTag:d];
        
      //  [self presentViewController:vC animated:YES completion:nil];
    
    }


}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}

#pragma  mark - CBPeripheral delegate

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    BOOL replace = NO;
    BOOL found = NO;
    BOOL pipboyFound = NO;
    
    NSLog(@"Services scanned !");
    [self.m cancelPeripheralConnection:peripheral];
    for (CBService *s in peripheral.services) {
        NSLog(@"Service found : %@",s.UUID);
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"]])  {
            NSLog(@"This is a SensorTag !");
            found = YES;
        }
        
    }
    if (found) {
        // Match if we have this device from before
        for (int ii=0; ii < self.sensorTags.count; ii++) {
            CBPeripheral *p = [self.sensorTags objectAtIndex:ii];
            if ([p isEqual:peripheral]) {
                    [self.sensorTags replaceObjectAtIndex:ii withObject:peripheral];
                    replace = YES;
                }
            }
        if (!replace) {
            [self.sensorTags addObject:peripheral];
            [self.tableView reloadData];
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}


#pragma mark - SensorTag configuration

-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    // First we set ambient temperature
    [d setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [d setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [d setValue:@"F000AA00-0451-4000-B000-000000000000"  forKey:@"IR temperature service UUID"];
    [d setValue:@"F000AA01-0451-4000-B000-000000000000"  forKey:@"IR temperature data UUID"];
    [d setValue:@"F000AA02-0451-4000-B000-000000000000"  forKey:@"IR temperature config UUID"];
    // Then we setup the accelerometer
    [d setValue:@"1" forKey:@"Accelerometer active"];
    [d setValue:@"500" forKey:@"Accelerometer period"];
    [d setValue:@"F000AA10-0451-4000-B000-000000000000"  forKey:@"Accelerometer service UUID"];
    [d setValue:@"F000AA11-0451-4000-B000-000000000000"  forKey:@"Accelerometer data UUID"];
    [d setValue:@"F000AA12-0451-4000-B000-000000000000"  forKey:@"Accelerometer config UUID"];
    [d setValue:@"F000AA13-0451-4000-B000-000000000000"  forKey:@"Accelerometer period UUID"];
    
    //Then we setup the rH sensor
    [d setValue:@"1" forKey:@"Humidity active"];
    [d setValue:@"F000AA20-0451-4000-B000-000000000000" forKey:@"Humidity service UUID"];
    [d setValue:@"F000AA21-0451-4000-B000-000000000000" forKey:@"Humidity data UUID"];
    [d setValue:@"F000AA22-0451-4000-B000-000000000000" forKey:@"Humidity config UUID"];
    
    //Then we setup the magnetometer
    [d setValue:@"1" forKey:@"Magnetometer active"];
    [d setValue:@"500" forKey:@"Magnetometer period"];
    [d setValue:@"F000AA30-0451-4000-B000-000000000000" forKey:@"Magnetometer service UUID"];
    [d setValue:@"F000AA31-0451-4000-B000-000000000000" forKey:@"Magnetometer data UUID"];
    [d setValue:@"F000AA32-0451-4000-B000-000000000000" forKey:@"Magnetometer config UUID"];
    [d setValue:@"F000AA33-0451-4000-B000-000000000000" forKey:@"Magnetometer period UUID"];
    
    //Then we setup the barometric sensor
    [d setValue:@"1" forKey:@"Barometer active"];
    [d setValue:@"F000AA40-0451-4000-B000-000000000000" forKey:@"Barometer service UUID"];
    [d setValue:@"F000AA41-0451-4000-B000-000000000000" forKey:@"Barometer data UUID"];
    [d setValue:@"F000AA42-0451-4000-B000-000000000000" forKey:@"Barometer config UUID"];
    [d setValue:@"F000AA43-0451-4000-B000-000000000000" forKey:@"Barometer calibration UUID"];
    
    [d setValue:@"1" forKey:@"Gyroscope active"];
    [d setValue:@"F000AA50-0451-4000-B000-000000000000" forKey:@"Gyroscope service UUID"];
    [d setValue:@"F000AA51-0451-4000-B000-000000000000" forKey:@"Gyroscope data UUID"];
    [d setValue:@"F000AA52-0451-4000-B000-000000000000" forKey:@"Gyroscope config UUID"];

    NSLog(@"%@",d);
    
    return d;
}

@end
