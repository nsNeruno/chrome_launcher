import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:chrome_launcher/chrome_launcher.dart';

void main() {
  runApp(ChromeLauncherExampleApp());
}

class ChromeLauncherExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      color: Colors.blue,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Chrome Launcher Example",),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: "URL",
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0,),
                child: ElevatedButton(
                  onPressed: _launchWithChrome,
                  child: Text("Launch with Chrome",),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  final TextEditingController _urlController = TextEditingController();

  void _launchWithChrome() {
    final chromeLauncher = ChromeLauncher();
    chromeLauncher.hasChromeInstalled().then((hasChromeInstalled,) {
      if (!hasChromeInstalled) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Unable to proceed",),
            content: Text("Your device doesn't have Chrome installed/enabled",),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context,).pop(),
                child: Text("Close",),
              ),
            ],
          ),
        );
        return;
      }
      final data = _urlController.text;

      chromeLauncher.isChromeDefaultBrowser().then((isDefaultBrowser) {
        debugPrint("isDefaultBrowser: $isDefaultBrowser",);
      },).catchError((e) {
        debugPrint("isDefaultBrowser: $e",);
      },);

      chromeLauncher.launchWithChrome(data,).catchError((e) {
        debugPrint(e.toString(),);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Failed to launch with Chrome",),
            content: Text(e.toString(),),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context,).pop(),
                child: Text("Close",),
              ),
            ],
          ),
        );
      },);
    },);
  }
}