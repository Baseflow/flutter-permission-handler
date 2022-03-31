## 9.0.4

* Add flag inside `UserDefaults` to save whether locationAlways has already been requested and prevent further requests, which would be left unanswered by the system.

## 9.0.3

* Ensures a request for `locationAlways` permission returns a result unblocking the permission request and preventing the `ERROR_ALREADY_REQUESTING_PERMISSIONS` error for subsequent permission request.

## 9.0.2

* Moves Apple implementation into its own package.
