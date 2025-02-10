//
//  LocationAccuracyHandler.h
//  Pods
//
//  Created by Pierre Monier on 09/02/2025.
//

#ifndef LocationAccuracyHandler_h
#define LocationAccuracyHandler_h
#import "PermissionHandlerEnums.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

@interface LocationAccuracyHandler : NSObject

- (LocationAccuracy) getLocationAccuracy;
- (void) requestTemporaryFullAccuracyWithResult:(FlutterResult _Nonnull)result purposeKey:(NSString * _Nullable)purposeKey;

@end

#endif /* LocationAccuracyHandler_h */
