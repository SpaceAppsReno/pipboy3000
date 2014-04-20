/*
 *  bleDevice.h
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


/// Class which describes a Bluetooth Smart Device
@interface BLEDevice : NSObject

/// Pointer to CoreBluetooth peripheral
@property (strong,nonatomic) CBPeripheral *p;
/// Pointer to CoreBluetooth manager that found this peripheral
@property (strong,nonatomic) CBCentralManager *manager;
/// Pointer to dictionary with device setup data
@property NSMutableDictionary *setupData;

@end

