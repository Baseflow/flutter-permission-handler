package com.baseflow.permissionhandler

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [33])
class PermissionManagerTest {

    private fun managerAfterARuntimeRequest(packageManager: PackageManager): PermissionManager {
        val activity = mock(Activity::class.java)
        `when`(activity.packageManager).thenReturn(packageManager)
        val manager = PermissionManager(mock(Context::class.java))
        manager.setActivity(activity)
        PermissionManager::class.java.getDeclaredField("requestResults").apply {
            isAccessible = true
            set(manager, HashMap<Int, Int>())
        }
        return manager
    }

    @Test
    fun `an install packages result is not handled when the permission is not declared`() {
        val packageManager = mock(PackageManager::class.java)
        `when`(packageManager.canRequestPackageInstalls()).thenThrow(
            SecurityException("Need to declare android.permission.REQUEST_INSTALL_PACKAGES to call this api")
        )
        val manager = managerAfterARuntimeRequest(packageManager)

        val handled = manager.onActivityResult(
            PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES,
            Activity.RESULT_OK,
            null,
        )

        assertFalse(handled)
    }

    @Test
    fun `an install packages result is handled when the permission is declared`() {
        val packageManager = mock(PackageManager::class.java)
        `when`(packageManager.canRequestPackageInstalls()).thenReturn(true)
        val manager = managerAfterARuntimeRequest(packageManager)

        val handled = manager.onActivityResult(
            PermissionConstants.PERMISSION_CODE_REQUEST_INSTALL_PACKAGES,
            Activity.RESULT_OK,
            null,
        )

        assertTrue(handled)
    }
}
