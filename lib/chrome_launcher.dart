
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class ChromeLauncher {

  ChromeLauncher._();

  static ChromeLauncher _instance;

  factory ChromeLauncher() {
    _instance ??= ChromeLauncher._();
    return _instance;
  }

  static const MethodChannel _channel =
      const MethodChannel('chrome_launcher');

  Future<bool> hasChromeInstalled() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod<bool>("hasChromeInstalled",);
    }
    return false;
  }

  Future<bool> isChromeDefaultBrowser() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod<bool>("isChromeDefaultBrowser",);
    }
    return false;
  }

  Future<void> launchWithChrome(String url,) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod(
        "launchWithChrome", { "url": url, },
      );
    }
  }
}
