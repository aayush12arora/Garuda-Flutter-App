import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sih/Sc1.dart';

import 'Navigator/bottomNavigation.dart';
import 'Services/notification_Service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> requestPermissions() async {
    bool reqSuc = false;
    List<Permission> permissions = [
      Permission.location,
      Permission.notification
    ];

    for (Permission permission in permissions) {
      if (await permission.isGranted) {
        if (kDebugMode) {
          print("Permission: $permission already granted");
        }
        reqSuc = true;
        continue;
      } else if (await permission.isDenied) {
        PermissionStatus permissionsStatus = await permission.request();
        if (permissionsStatus.isGranted) {
          if (kDebugMode) {
            print("Permission: $permission already granted");
          }
          reqSuc = true;
        } else if (permissionsStatus.isPermanentlyDenied) {
          if (kDebugMode) {
            print("Permission: $permission is permanently denied");
          }
          reqSuc = false;
        }
      }
    }
    if (reqSuc == false) {
      openAppSettings();
    }
  }
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestPermissions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primaryColor: Color(0xff912C2E),
            hintColor: Color(0xff912C2E),
          ),
          title: 'SIH',
          home: BottomNavigation(1),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

