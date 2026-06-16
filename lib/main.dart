import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/ble_controller.dart';
import 'controllers/fall_notification_server.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://eobhtecnbppzufmpzwkh.supabase.co",
    publishableKey: "sb_publishable_glhc8LOZyUSp0kREyHm7gQ_82eq7AFN",
  );
  // Initialize BLE controller
  Get.put(BleController());

  // Initialize fall notification service
  await FallNotificationService().initialize();

  // Check if user is visiting for the first time
  final pref = await SharedPreferences.getInstance();
  bool isFirstTime = pref.getBool('isFirstTime') ?? true;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vigil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(isFirstTime: isFirstTime),
    );
  }
}
