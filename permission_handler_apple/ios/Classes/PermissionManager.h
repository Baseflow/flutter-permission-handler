//
//  PermissionManager.h
//  permission_handler
//
//  Created by Razvan Lung on 15/02/2019.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "strategies/AudioVideoPermissionStrategy.h"
#import "strategies/AppTrackingTransparencyPermissionStrategy.h"
#import "strategies/BluetoothPermissionStrategy.h"
#import "strategies/ContactPermissionStrategy.h"
#import "strategies/EventPermissionStrategy.h"
#import "strategies/LocationPermissionStrategy.h"
#import "strategies/MediaLibraryPermissionStrategy.h"
#import "strategies/PermissionStrategy.h"
#import "strategies/PhonePermissionStrategy.h"
#import "strategies/PhotoPermissionStrategy.h"
#import "strategies/SensorPermissionStrategy.h"
#import "strategies/SpeechPermissionStrategy.h"
#import "strategies/StoragePermissionStrategy.h"
#import "strategies/UnknownPermissionStrategy.h"
#import "strategies/NotificationPermissionStrategy.h"
#import "strategies/CriticalAlertsPermissionStrategy.h"
#import "PermissionHandlerEnums.h"
#import "util/Codec.h"

typedef void (^PermissionRequestCompletion)(NSDictionary *permissionRequestResults);

@interface PermissionManager : NSObject

- (instancetype)initWithStrategyInstances;
- (void)requestPermissions:(NSArray *)permissions completion:(PermissionRequestCompletion)completion;

+ (void)checkPermissionStatus:(enum PermissionGroup)permission result:(FlutterResult)result;
+ (void)checkServiceStatus:(enum PermissionGroup)permission result:(FlutterResult)result;
+ (void)openAppSettings:(FlutterResult)result;

@end
