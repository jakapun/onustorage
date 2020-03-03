import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // LineSDK.instance.setup("1653459898").then((_) {
  LineSDK.instance.setup("1653459898").then((_) {
    print("LineSDK Prepared");
  });
  runApp(App());
}
