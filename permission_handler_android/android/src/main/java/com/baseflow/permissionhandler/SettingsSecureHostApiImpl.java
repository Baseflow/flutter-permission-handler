package com.baseflow.permissionhandler;

import android.content.ContentResolver;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baseflow.instancemanager.InstanceManager;
import com.baseflow.permissionhandler.PermissionHandlerPigeon.SettingsSecureHostApi;

import java.util.UUID;

/**
 * Host API implementation for `Settings.Secure`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class SettingsSecureHostApiImpl implements SettingsSecureHostApi {
    private final InstanceManager instanceManager;

    /**
     * Constructs an {@link SettingsSecureHostApiImpl}.
     *
     * @param instanceManager maintains instances stored to communicate with attached Dart objects
     */
    public SettingsSecureHostApiImpl(
        @NonNull InstanceManager instanceManager
    ) {
        this.instanceManager = instanceManager;
    }

    @Override
    public Long getInt(@NonNull String contentResolverInstanceId, @NonNull String name) {
        final UUID contentResolverUuid = UUID.fromString(contentResolverInstanceId);
        final ContentResolver contentResolver = instanceManager.getInstance(contentResolverUuid);

        try {
            return (long) Settings.Secure.getInt(contentResolver, name);
        } catch (Settings.SettingNotFoundException e) {
            return null;
        }
    }

    @NonNull
    @Override
    public Long getIntWithDefault(@NonNull String contentResolverInstanceId, @NonNull String name, @NonNull Long defaultValue) {
        final UUID contentResolverUuid = UUID.fromString(contentResolverInstanceId);
        final ContentResolver contentResolver = instanceManager.getInstance(contentResolverUuid);

        return (long) Settings.Secure.getInt(contentResolver, name, defaultValue.intValue());
    }

    @Nullable
    @Override
    public String getString(@NonNull String contentResolverInstanceId, @NonNull String name) {
        final UUID contentResolverUuid = UUID.fromString(contentResolverInstanceId);
        final ContentResolver contentResolver = instanceManager.getInstance(contentResolverUuid);

        return Settings.Secure.getString(contentResolver, name);
    }
}
