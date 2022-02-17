package com.baseflow.permissionhandler;

@FunctionalInterface
interface ErrorCallback {
    void onError(String errorCode, String errorDescription);
}
