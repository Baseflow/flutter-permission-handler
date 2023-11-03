// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.baseflow.permissionhandler;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class PermissionHandlerPigeon {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) 
    {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  protected static ArrayList<Object> wrapError(@NonNull Throwable exception) {
    ArrayList<Object> errorList = new ArrayList<Object>(3);
    if (exception instanceof FlutterError) {
      FlutterError error = (FlutterError) exception;
      errorList.add(error.code);
      errorList.add(error.getMessage());
      errorList.add(error.details);
    } else {
      errorList.add(exception.toString());
      errorList.add(exception.getClass().getSimpleName());
      errorList.add(
        "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    }
    return errorList;
  }

  /**
   * Result of a permission request.
   *
   * Contrary to the Android SDK, we do not make use of a `requestCode`, as
   * permission results are returned as a [Future] instead of through a separate
   * callback.
   *
   * See https://developer.android.com/reference/androidx/core/app/ActivityCompat.OnRequestPermissionsResultCallback.
   *
   * Generated class from Pigeon that represents data sent in messages.
   */
  public static final class PermissionRequestResult {
    private @NonNull List<String> permissions;

    public @NonNull List<String> getPermissions() {
      return permissions;
    }

    public void setPermissions(@NonNull List<String> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"permissions\" is null.");
      }
      this.permissions = setterArg;
    }

    private @NonNull List<Long> grantResults;

    public @NonNull List<Long> getGrantResults() {
      return grantResults;
    }

    public void setGrantResults(@NonNull List<Long> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"grantResults\" is null.");
      }
      this.grantResults = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    PermissionRequestResult() {}

    public static final class Builder {

      private @Nullable List<String> permissions;

      public @NonNull Builder setPermissions(@NonNull List<String> setterArg) {
        this.permissions = setterArg;
        return this;
      }

      private @Nullable List<Long> grantResults;

      public @NonNull Builder setGrantResults(@NonNull List<Long> setterArg) {
        this.grantResults = setterArg;
        return this;
      }

      public @NonNull PermissionRequestResult build() {
        PermissionRequestResult pigeonReturn = new PermissionRequestResult();
        pigeonReturn.setPermissions(permissions);
        pigeonReturn.setGrantResults(grantResults);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(permissions);
      toListResult.add(grantResults);
      return toListResult;
    }

    static @NonNull PermissionRequestResult fromList(@NonNull ArrayList<Object> list) {
      PermissionRequestResult pigeonResult = new PermissionRequestResult();
      Object permissions = list.get(0);
      pigeonResult.setPermissions((List<String>) permissions);
      Object grantResults = list.get(1);
      pigeonResult.setGrantResults((List<Long>) grantResults);
      return pigeonResult;
    }
  }

  /**
   * Result of an activity-for-result request.
   *
   * Contrary to the Android SDK, we do not make use of a `requestCode`, as
   * activity results are returned as a [Future] instead of through a separate
   * callback.
   *
   * See https://developer.android.com/reference/android/app/Activity#onActivityResult(int,%20int,%20android.content.Intent).
   *
   * Generated class from Pigeon that represents data sent in messages.
   */
  public static final class ActivityResultPigeon {
    private @NonNull Long resultCode;

    public @NonNull Long getResultCode() {
      return resultCode;
    }

    public void setResultCode(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"resultCode\" is null.");
      }
      this.resultCode = setterArg;
    }

    private @Nullable String dataInstanceId;

    public @Nullable String getDataInstanceId() {
      return dataInstanceId;
    }

    public void setDataInstanceId(@Nullable String setterArg) {
      this.dataInstanceId = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    ActivityResultPigeon() {}

    public static final class Builder {

      private @Nullable Long resultCode;

      public @NonNull Builder setResultCode(@NonNull Long setterArg) {
        this.resultCode = setterArg;
        return this;
      }

      private @Nullable String dataInstanceId;

      public @NonNull Builder setDataInstanceId(@Nullable String setterArg) {
        this.dataInstanceId = setterArg;
        return this;
      }

      public @NonNull ActivityResultPigeon build() {
        ActivityResultPigeon pigeonReturn = new ActivityResultPigeon();
        pigeonReturn.setResultCode(resultCode);
        pigeonReturn.setDataInstanceId(dataInstanceId);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(resultCode);
      toListResult.add(dataInstanceId);
      return toListResult;
    }

    static @NonNull ActivityResultPigeon fromList(@NonNull ArrayList<Object> list) {
      ActivityResultPigeon pigeonResult = new ActivityResultPigeon();
      Object resultCode = list.get(0);
      pigeonResult.setResultCode((resultCode == null) ? null : ((resultCode instanceof Integer) ? (Integer) resultCode : (Long) resultCode));
      Object dataInstanceId = list.get(1);
      pigeonResult.setDataInstanceId((String) dataInstanceId);
      return pigeonResult;
    }
  }

  public interface Result<T> {
    @SuppressWarnings("UnknownNullness")
    void success(T result);

    void error(@NonNull Throwable error);
  }

  private static class ActivityHostApiCodec extends StandardMessageCodec {
    public static final ActivityHostApiCodec INSTANCE = new ActivityHostApiCodec();

    private ActivityHostApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return ActivityResultPigeon.fromList((ArrayList<Object>) readValue(buffer));
        case (byte) 129:
          return PermissionRequestResult.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof ActivityResultPigeon) {
        stream.write(128);
        writeValue(stream, ((ActivityResultPigeon) value).toList());
      } else if (value instanceof PermissionRequestResult) {
        stream.write(129);
        writeValue(stream, ((PermissionRequestResult) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /**
   * Host API for `Activity`.
   *
   * This class may handle instantiating and adding native object instances that
   * are attached to a Dart instance or handle method calls on the associated
   * native class or an instance of the class.
   *
   * See https://developer.android.com/reference/android/app/Activity.
   *
   * Generated interface from Pigeon that represents a handler of messages from Flutter.
   */
  public interface ActivityHostApi {
    /**
     * Gets whether the application should show UI with rationale before requesting a permission.
     *
     * See https://developer.android.com/reference/android/app/Activity#shouldShowRequestPermissionRationale(java.lang.String).
     */
    @NonNull 
    Boolean shouldShowRequestPermissionRationale(@NonNull String instanceId, @NonNull String permission);
    /**
     * Determine whether the application has been granted a particular permission.
     *
     * See https://developer.android.com/reference/android/app/Activity#checkSelfPermission(java.lang.String).
     */
    @NonNull 
    Long checkSelfPermission(@NonNull String instanceId, @NonNull String permission);
    /**
     * Requests permissions to be granted to this application.
     *
     * Contrary to the Android SDK, we do not make use of a `requestCode`, as
     * permission results are returned as a [Future] instead of through a
     * separate callback.
     *
     * See
     * https://developer.android.com/reference/android/app/Activity#requestPermissions(java.lang.String[],%20int)
     * and
     * https://developer.android.com/reference/android/app/Activity#onRequestPermissionsResult(int,%20java.lang.String[],%20int[]).
     */
    void requestPermissions(@NonNull String instanceId, @NonNull List<String> permissions, @NonNull Result<PermissionRequestResult> result);
    /**
     * Launch a new activity.
     *
     * See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
     */
    void startActivity(@NonNull String instanceId, @NonNull String intentInstanceId);
    /**
     * Returns the name of this application's package.
     *
     * See https://developer.android.com/reference/android/content/Context#getPackageName().
     */
    @NonNull 
    String getPackageName(@NonNull String instanceId);
    /**
     * Start an activity for which the application would like a result when it finished.
     *
     * Contrary to the Android SDK, we do not make use of a `requestCode`, as
     * activity results are returned as a [Future].
     *
     * See https://developer.android.com/reference/android/app/Activity#startActivityForResult(android.content.Intent,%20int).
     */
    void startActivityForResult(@NonNull String instanceId, @NonNull String intentInstanceId, @NonNull Result<ActivityResultPigeon> result);

    /** The codec used by ActivityHostApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return ActivityHostApiCodec.INSTANCE;
    }
    /**Sets up an instance of `ActivityHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable ActivityHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.shouldShowRequestPermissionRationale", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String permissionArg = (String) args.get(1);
                try {
                  Boolean output = api.shouldShowRequestPermissionRationale(instanceIdArg, permissionArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.checkSelfPermission", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String permissionArg = (String) args.get(1);
                try {
                  Long output = api.checkSelfPermission(instanceIdArg, permissionArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.requestPermissions", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                List<String> permissionsArg = (List<String>) args.get(1);
                Result<PermissionRequestResult> resultCallback =
                    new Result<PermissionRequestResult>() {
                      public void success(PermissionRequestResult result) {
                        wrapped.add(0, result);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.requestPermissions(instanceIdArg, permissionsArg, resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivity", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String intentInstanceIdArg = (String) args.get(1);
                try {
                  api.startActivity(instanceIdArg, intentInstanceIdArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.getPackageName", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                try {
                  String output = api.getPackageName(instanceIdArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityHostApi.startActivityForResult", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String intentInstanceIdArg = (String) args.get(1);
                Result<ActivityResultPigeon> resultCallback =
                    new Result<ActivityResultPigeon>() {
                      public void success(ActivityResultPigeon result) {
                        wrapped.add(0, result);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.startActivityForResult(instanceIdArg, intentInstanceIdArg, resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /**
   * Flutter API for `Activity`.
   *
   * This class may handle instantiating and adding Dart instances that are
   * attached to a native instance or receiving callback methods from an
   * overridden native class.
   *
   * See https://developer.android.com/reference/android/app/Activity.
   *
   * Generated class from Pigeon that represents Flutter messages that can be called from Java.
   */
  public static class ActivityFlutterApi {
    private final @NonNull BinaryMessenger binaryMessenger;

    public ActivityFlutterApi(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */ 
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by ActivityFlutterApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /** Create a new Dart instance and add it to the `InstanceManager`. */
    public void create(@NonNull String instanceIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityFlutterApi.create", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(instanceIdArg)),
          channelReply -> callback.reply(null));
    }
    /** Dispose of the Dart instance and remove it from the `InstanceManager`. */
    public void dispose(@NonNull String instanceIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ActivityFlutterApi.dispose", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(instanceIdArg)),
          channelReply -> callback.reply(null));
    }
  }
  /**
   * Host API for `Context`.
   *
   * This class may handle instantiating and adding native object instances that
   * are attached to a Dart instance or handle method calls on the associated
   * native class or an instance of the class.
   *
   * See https://developer.android.com/reference/android/content/Context.
   *
   * Generated interface from Pigeon that represents a handler of messages from Flutter.
   */
  public interface ContextHostApi {
    /**
     * Determine whether the application has been granted a particular permission.
     *
     * See https://developer.android.com/reference/android/content/Context#checkSelfPermission(java.lang.String).
     */
    @NonNull 
    Long checkSelfPermission(@NonNull String instanceId, @NonNull String permission);
    /**
     * Launch a new activity.
     *
     * See https://developer.android.com/reference/android/content/Context#startActivity(android.content.Intent).
     */
    void startActivity(@NonNull String instanceId, @NonNull String intentInstanceId);
    /**
     * Returns the name of this application's package.
     *
     * See https://developer.android.com/reference/android/content/Context#getPackageName().
     */
    @NonNull 
    String getPackageName(@NonNull String instanceId);

    /** The codec used by ContextHostApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**Sets up an instance of `ContextHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable ContextHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ContextHostApi.checkSelfPermission", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String permissionArg = (String) args.get(1);
                try {
                  Long output = api.checkSelfPermission(instanceIdArg, permissionArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ContextHostApi.startActivity", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String intentInstanceIdArg = (String) args.get(1);
                try {
                  api.startActivity(instanceIdArg, intentInstanceIdArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ContextHostApi.getPackageName", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                try {
                  String output = api.getPackageName(instanceIdArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /**
   * Flutter API for `Context`.
   *
   * This class may handle instantiating and adding Dart instances that are
   * attached to a native instance or receiving callback methods from an
   * overridden native class.
   *
   * See https://developer.android.com/reference/android/content/Context.
   *
   * Generated class from Pigeon that represents Flutter messages that can be called from Java.
   */
  public static class ContextFlutterApi {
    private final @NonNull BinaryMessenger binaryMessenger;

    public ContextFlutterApi(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */ 
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by ContextFlutterApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /** Create a new Dart instance and add it to the `InstanceManager`. */
    public void create(@NonNull String instanceIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ContextFlutterApi.create", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(instanceIdArg)),
          channelReply -> callback.reply(null));
    }
    /** Dispose of the Dart instance and remove it from the `InstanceManager`. */
    public void dispose(@NonNull String instanceIdArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.permission_handler_android.ContextFlutterApi.dispose", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(instanceIdArg)),
          channelReply -> callback.reply(null));
    }
  }
  /**
   * Host API for `Uri`.
   *
   * This class may handle instantiating and adding native object instances that
   * are attached to a Dart instance or handle method calls on the associated
   * native class or an instance of the class.
   *
   * See https://developer.android.com/reference/android/net/Uri.
   *
   * Generated interface from Pigeon that represents a handler of messages from Flutter.
   */
  public interface UriHostApi {
    /**
     * Creates a Uri which parses the given encoded URI string.
     *
     * Returns the instance ID of the created Uri.
     *
     * See https://developer.android.com/reference/android/net/Uri#parse(java.lang.String).
     */
    void parse(@NonNull String instanceId, @NonNull String uriString);
    /**
     * Returns the encoded string representation of this URI.
     *
     * Example: "http://google.com/".
     *
     * Method name is [toStringAsync] as opposed to [toString], as [toString]
     * cannot be overridden with return type [Future].
     *
     * See https://developer.android.com/reference/android/net/Uri#toString().
     */
    @NonNull 
    String toStringAsync(@NonNull String instanceId);

    /** The codec used by UriHostApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**Sets up an instance of `UriHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable UriHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.UriHostApi.parse", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String uriStringArg = (String) args.get(1);
                try {
                  api.parse(instanceIdArg, uriStringArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.UriHostApi.toStringAsync", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                try {
                  String output = api.toStringAsync(instanceIdArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /**
   * Host API for `Intent`.
   *
   * This class may handle instantiating and adding native object instances that
   * are attached to a Dart instance or handle method calls on the associated
   * native class or an instance of the class.
   *
   * See https://developer.android.com/reference/android/content/Intent.
   *
   * Generated interface from Pigeon that represents a handler of messages from Flutter.
   */
  public interface IntentHostApi {
    /**
     * Creates an empty intent.
     *
     * See https://developer.android.com/reference/android/content/Intent#Intent().
     */
    void create(@NonNull String instanceId);
    /**
     * Set the general action to be performed.
     *
     * See https://developer.android.com/reference/android/content/Intent#setAction(java.lang.String).
     */
    void setAction(@NonNull String instanceId, @NonNull String action);
    /**
     * Set the data this intent is operating on.
     *
     * See https://developer.android.com/reference/android/content/Intent#setData(android.net.Uri).
     */
    void setData(@NonNull String instanceId, @NonNull String uriInstanceId);
    /**
     * Add a new category to the intent.
     *
     * Categories provide additional detail about the action the intent performs.
     * When resolving an intent, only activities that provide all of the
     * requested categories will be used.
     *
     * See https://developer.android.com/reference/android/content/Intent#addCategory(java.lang.String).
     */
    void addCategory(@NonNull String instanceId, @NonNull String category);
    /**
     * Add additional flags to the intent (or with existing flags value).
     *
     * See https://developer.android.com/reference/android/content/Intent#addFlags(int).
     */
    void addFlags(@NonNull String instanceId, @NonNull Long flags);

    /** The codec used by IntentHostApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**Sets up an instance of `IntentHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable IntentHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.IntentHostApi.create", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                try {
                  api.create(instanceIdArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.IntentHostApi.setAction", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String actionArg = (String) args.get(1);
                try {
                  api.setAction(instanceIdArg, actionArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.IntentHostApi.setData", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String uriInstanceIdArg = (String) args.get(1);
                try {
                  api.setData(instanceIdArg, uriInstanceIdArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.IntentHostApi.addCategory", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                String categoryArg = (String) args.get(1);
                try {
                  api.addCategory(instanceIdArg, categoryArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.permission_handler_android.IntentHostApi.addFlags", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String instanceIdArg = (String) args.get(0);
                Number flagsArg = (Number) args.get(1);
                try {
                  api.addFlags(instanceIdArg, (flagsArg == null) ? null : flagsArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
}
