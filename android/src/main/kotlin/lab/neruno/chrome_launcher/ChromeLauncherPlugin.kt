package lab.neruno.chrome_launcher

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.provider.Browser
import android.webkit.URLUtil
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** ChromeLauncherPlugin */
class ChromeLauncherPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activityContext: Context
  private val chromePackage = "com.android.chrome"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "chrome_launcher")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "hasChromeInstalled" -> {
        try {
          val pm: PackageManager = activityContext.packageManager
          val isChromeEnabled = pm.getApplicationInfo(chromePackage, 0).enabled
          result.success(isChromeEnabled)
        } catch (ex: PackageManager.NameNotFoundException) {
          result.success(false)
        } catch (ex: Exception) {
          result.error(ex.javaClass.name, ex.message, null)
        } catch (ex: Error) {
          result.error(ex.javaClass.name, ex.message, null)
        }
      }
      "launchWithChrome" -> {
        val url: String? = call.argument("url")
        if (url == null) {
          result.error("NullPointerException", "URL must not be null", null)
          return
        }
        if (!URLUtil.isValidUrl(url)) {
          result.error("FormatException", "$url is not a valid URL", null)
          return
        }
        try {
          val intent = Intent().apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse(url)
            putExtra(Browser.EXTRA_HEADERS, Bundle())
            `package` = chromePackage
          }
          activityContext.startActivity(intent)
          result.success(null)
        } catch (ex: Throwable) {
          result.error(ex.javaClass.name, ex.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityContext = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {}
}
