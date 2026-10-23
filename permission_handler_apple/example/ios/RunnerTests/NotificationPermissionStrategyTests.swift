import Flutter
import XCTest
import permission_handler_apple

/// The notification status is delivered by
/// `-[UNUserNotificationCenter getNotificationSettingsWithCompletionHandler:]`.
/// Method calls arrive on the main thread; waiting there for that completion
/// handler blocks the UI, and when the handler is scheduled on the main queue
/// (seen on iOS 27) the wait never ends. These tests call the plugin the way
/// the Flutter engine does — on the main thread.
final class NotificationPermissionStrategyTests: XCTestCase {
  // `Permission.notification`, as encoded by permission_handler_platform_interface.
  private let notification = 17

  // `PermissionStatus.denied`, see PermissionHandlerEnums.h.
  private let denied = 0

  func testCheckNotificationStatusDoesNotWaitOnTheMainThread() {
    XCTAssertTrue(Thread.isMainThread)
    // The status check goes through `+[PermissionManager checkPermissionStatus:result:]`,
    // which needs no manager instance.
    let plugin = PermissionHandlerPlugin()
    let answered = expectation(description: "notification permission status")
    var handleReturned = false

    plugin.handle(FlutterMethodCall(methodName: "checkPermissionStatus", arguments: notification)) { result in
      XCTAssertTrue(
        handleReturned,
        "the status was resolved before handleMethodCall returned, i.e. the main thread waited for it")
      XCTAssertTrue(Thread.isMainThread, "the result must be delivered on the main thread")
      // A fresh install has not been asked yet: notDetermined is reported as
      // `denied`, as before.
      XCTAssertEqual(result as? Int, self.denied)
      answered.fulfill()
    }
    handleReturned = true

    wait(for: [answered], timeout: 10)
  }
}
