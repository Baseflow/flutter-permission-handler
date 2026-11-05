#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

// The strategy header is private to the plugin. This target reads it through HEADER_SEARCH_PATHS with the
// location macro the example enables, and looks the class up at runtime because the plugin is linked into
// the app, not into this test bundle.
#define PERMISSION_LOCATION 1
#import "LocationPermissionStrategy.h"

static NSString *const UserDefaultsSuiteName = @"LocationPermissionStrategyTests";
static NSString *const AlwaysRequestedKey = @"org.baseflow.permission_handler_apple.permission_requested";

@interface FakeLocationManager : CLLocationManager
@property(nonatomic) CLAuthorizationStatus status;
@property(nonatomic) NSInteger whenInUseRequests;
@property(nonatomic) NSInteger alwaysRequests;
- (void)reportStatus:(CLAuthorizationStatus)status;
@end

@implementation FakeLocationManager {
    __weak id<CLLocationManagerDelegate> _fakeDelegate;
}

- (CLAuthorizationStatus)authorizationStatus {
    return self.status;
}

- (id<CLLocationManagerDelegate>)delegate {
    return _fakeDelegate;
}

- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate {
    _fakeDelegate = delegate;
}

- (void)requestWhenInUseAuthorization {
    self.whenInUseRequests += 1;
}

- (void)requestAlwaysAuthorization {
    self.alwaysRequests += 1;
}

- (void)reportStatus:(CLAuthorizationStatus)status {
    self.status = status;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [_fakeDelegate locationManager:self didChangeAuthorizationStatus:status];
#pragma clang diagnostic pop
}

@end

@interface LocationPermissionStrategyTests : XCTestCase
@end

@implementation LocationPermissionStrategyTests {
    FakeLocationManager *_locationManager;
    NSNotificationCenter *_notificationCenter;
    NSUserDefaults *_userDefaults;
    NSMutableArray<LocationPermissionStrategy *> *_strategies;
    NSMutableArray<NSNumber *> *_results;
}

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    _locationManager = [FakeLocationManager new];
    _notificationCenter = [NSNotificationCenter new];
    _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:UserDefaultsSuiteName];
    [_userDefaults removePersistentDomainForName:UserDefaultsSuiteName];
    _strategies = [NSMutableArray new];
    _results = [NSMutableArray new];
}

- (void)tearDown {
    [_userDefaults removePersistentDomainForName:UserDefaultsSuiteName];
    [super tearDown];
}

- (LocationPermissionStrategy *)strategyWithPromptTimeout:(NSTimeInterval)promptTimeout {
    Class strategyClass = NSClassFromString(@"LocationPermissionStrategy");
    SEL initializer = @selector(initWithLocationManager:notificationCenter:userDefaults:promptTimeout:);
    XCTAssertTrue([strategyClass instancesRespondToSelector:initializer],
                  @"The example app must be built with PERMISSION_LOCATION enabled.");

    LocationPermissionStrategy *strategy = [[strategyClass alloc] initWithLocationManager:_locationManager
                                                                       notificationCenter:_notificationCenter
                                                                             userDefaults:_userDefaults
                                                                            promptTimeout:promptTimeout];
    [_strategies addObject:strategy];
    return strategy;
}

- (void)request:(PermissionGroup)permission from:(LocationPermissionStrategy *)strategy {
    [strategy requestPermission:permission
              completionHandler:^(PermissionStatus status) {
        [self->_results addObject:@(status)];
    }
                   errorHandler:^(NSString *errorCode, NSString *errorDescription) {
        XCTFail(@"%@: %@", errorCode, errorDescription);
    }];
}

- (void)post:(NSNotificationName)name {
    [_notificationCenter postNotificationName:name object:nil];
}

- (void)waitForResults:(NSUInteger)count {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"@count == %lu", (unsigned long)count];
    [self expectationForPredicate:predicate evaluatedWithObject:_results handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testAlwaysUpgradeReturnsGrantedWhenTheUserPicksAlways {
    _locationManager.status = kCLAuthorizationStatusAuthorizedWhenInUse;
    LocationPermissionStrategy *strategy = [self strategyWithPromptTimeout:60];

    [self request:PermissionGroupLocationAlways from:strategy];
    [_locationManager reportStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [self post:UIApplicationWillResignActiveNotification];
    XCTAssertEqualObjects(_results, @[]);

    [_locationManager reportStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self post:UIApplicationDidBecomeActiveNotification];

    XCTAssertEqual(_locationManager.alwaysRequests, 1);
    XCTAssertEqualObjects(_results, @[ @(PermissionStatusGranted) ]);
}

- (void)testAlwaysUpgradeReturnsPermanentlyDeniedWhenTheUserKeepsWhileUsing {
    _locationManager.status = kCLAuthorizationStatusAuthorizedWhenInUse;
    LocationPermissionStrategy *strategy = [self strategyWithPromptTimeout:60];

    [self request:PermissionGroupLocationAlways from:strategy];
    [_locationManager reportStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [self post:UIApplicationWillResignActiveNotification];
    XCTAssertEqualObjects(_results, @[]);

    [self post:UIApplicationDidBecomeActiveNotification];

    XCTAssertEqualObjects(_results, @[ @(PermissionStatusPermanentlyDenied) ]);
    XCTAssertTrue([_userDefaults boolForKey:AlwaysRequestedKey]);
}

- (void)testAlwaysRequestWithoutAPromptReturnsDeniedAfterThePromptTimeout {
    _locationManager.status = kCLAuthorizationStatusAuthorizedWhenInUse;
    LocationPermissionStrategy *strategy = [self strategyWithPromptTimeout:0.1];

    [self request:PermissionGroupLocationAlways from:strategy];
    [_locationManager reportStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [self waitForResults:1];

    XCTAssertEqualObjects(_results, @[ @(PermissionStatusDenied) ]);
    XCTAssertFalse([_userDefaults boolForKey:AlwaysRequestedKey]);
}

- (void)testAlwaysRequestAsksAgainAfterARequestWithoutAPrompt {
    _locationManager.status = kCLAuthorizationStatusAuthorizedWhenInUse;
    [self request:PermissionGroupLocationAlways from:[self strategyWithPromptTimeout:0.1]];
    [self waitForResults:1];

    [self request:PermissionGroupLocationAlways from:[self strategyWithPromptTimeout:60]];

    XCTAssertEqual(_locationManager.alwaysRequests, 2);
    XCTAssertEqualObjects(_results, @[ @(PermissionStatusDenied) ]);
}

- (void)testAlwaysRequestReturnsPermanentlyDeniedWithoutAskingOnceThePromptWasShown {
    _locationManager.status = kCLAuthorizationStatusAuthorizedWhenInUse;
    [_userDefaults setBool:YES forKey:AlwaysRequestedKey];

    [self request:PermissionGroupLocationAlways from:[self strategyWithPromptTimeout:60]];

    XCTAssertEqual(_locationManager.alwaysRequests, 0);
    XCTAssertEqualObjects(_results, @[ @(PermissionStatusPermanentlyDenied) ]);
}

- (void)testWhenInUseRequestReturnsGrantedWhenTheUserAllows {
    _locationManager.status = kCLAuthorizationStatusNotDetermined;
    LocationPermissionStrategy *strategy = [self strategyWithPromptTimeout:60];

    [self request:PermissionGroupLocationWhenInUse from:strategy];
    [_locationManager reportStatus:kCLAuthorizationStatusNotDetermined];
    [self post:UIApplicationWillResignActiveNotification];
    XCTAssertEqualObjects(_results, @[]);

    [_locationManager reportStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [self post:UIApplicationDidBecomeActiveNotification];

    XCTAssertEqual(_locationManager.whenInUseRequests, 1);
    XCTAssertEqualObjects(_results, @[ @(PermissionStatusGranted) ]);
}

- (void)testWhenInUseRequestReturnsDeniedWhenThePromptIsDismissedWithoutAChoice {
    _locationManager.status = kCLAuthorizationStatusNotDetermined;
    LocationPermissionStrategy *strategy = [self strategyWithPromptTimeout:0.1];

    [self request:PermissionGroupLocationWhenInUse from:strategy];
    [self post:UIApplicationWillResignActiveNotification];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    XCTAssertEqualObjects(_results, @[]);

    [self post:UIApplicationDidBecomeActiveNotification];

    XCTAssertEqualObjects(_results, @[ @(PermissionStatusDenied) ]);
}

@end
