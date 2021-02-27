import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chrome_launcher/chrome_launcher.dart';

void main() {
  const MethodChannel channel = MethodChannel('chrome_launcher');

  TestWidgetsFlutterBinding.ensureInitialized();

}
