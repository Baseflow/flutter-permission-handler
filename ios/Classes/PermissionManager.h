//
//  PermissionManager.h
//  permission_handler
//
//  Created by Razvan Lung on 15/02/2019.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AudioVideoPermissionStrategy.h"
#import "ContactPermissionStrategy.h"
#import "EventPermissionStrategy.h"
#import "LocationPermissionStrategy.h"
#import "MediaLibraryPermissionStrategy.h"
#import "PermissionStrategy.h"
#import "PhonePermissionStrategy.h"
#import "PhotoPermissionStrategy.h"
#import "SensorPermissionStrategy.h"
#import "SpeechPermissionStrategy.h"
#import "UnknownPermissionStrategy.h"
#import "PermissionHandlerEnums.h"
#import "Codec.h"

typedef void (^PermissionRequestCompletion)(NSDictionary *permissionRequestResults);

@interface PermissionManager : NSObject

- (instancetype)initWithStrategyInstances;

+ (void)checkPermissionStatus:(enum PermissionGroup)permission result:(FlutterResult)result;

+ (void)checkServiceStatus:(enum PermissionGroup)permission result:(FlutterResult)result;

+ (void)openAppSettings:(FlutterResult)result;

- (void)requestPermissions:(NSArray *)permissions completion:(PermissionRequestCompletion)completion;

@end
