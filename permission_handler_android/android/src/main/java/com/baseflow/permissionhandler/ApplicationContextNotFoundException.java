package com.baseflow.permissionhandler;

import android.content.Context;

/**
 * This exception is thrown when a call requires the application's {@link Context}, but none is available.
 */

public class ApplicationContextNotFoundException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    public ApplicationContextNotFoundException() {}

    public ApplicationContextNotFoundException(String name) {
        super(name);
    }
}
