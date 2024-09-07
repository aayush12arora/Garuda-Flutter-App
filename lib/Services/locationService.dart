
import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/Services/markattendance.dart';
import 'package:sih/Services/notification_Service.dart'; // Add this for ValueNotifier

class LocationService {
  static int insideCount = 0;
  static bool startService = false;
  static bool checkIn = false;
  static bool checkOut = false;
  // static var buildingLat = 28.523490;
  // static var buildingLong = 77.570993;
static var buildingLat = 28.52374;
  static var buildingLong = 77.57348;
  // ValueNotifier to listen to changes in insideCount
  static final ValueNotifier<int> insideNotifier = ValueNotifier<int>(insideCount);

  static final service = FlutterBackgroundService();

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: false),
      iosConfiguration: IosConfiguration(),
    );
  }

  static void StartService() async {
    startService= true;
    await Permission.location.request();
    final isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
      NotificationService().showNotification(title: "Service Started", body: "Service Started Successfully");

    }
  }

  static void StopService() async {

    final isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke('stop');
      setData(0);
      NotificationService().showNotification(title: "Service Stopped", body: "Service Stopped Successfully");
    }
  }

  @pragma('vm:entry-point')
 static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    service.on("stop").listen((event) {
      service.stopSelf();

    });


    Timer.periodic(const Duration(seconds: 20), (timer) async {




        Position position = await getLocation();
        double distanceBW = await Geolocator.distanceBetween(
            position.latitude, position.longitude, buildingLat, buildingLong);
        print(distanceBW);

        var  lastState = await getLastState() ;
       print('last state $lastState' );
        if (distanceBW < 150&&lastState==0) {
            print(" out in");
            checkIn= true;
            await   AttendanceApi().manualCheckIn(employeeId: 4, officeId: 1, timestamp: DateTime.now());
            NotificationService().showNotification(body: "You are inside the building",title: "Check IN Successfull");

            // update  in database with time stamp
            // if(lastState==0
           await setData(1);

        }else if(distanceBW>150&&lastState==1){

            // last state was in and now went out
            print(" in out");
            checkOut= true;
            await   AttendanceApi().manualCheckOut(employeeId: 4, officeId: 1, timestamp: DateTime.now());
            NotificationService().showNotification(body: "CheckOut",title: "Check out Successfull");

            await setData(0);
            // update  in database with time stamp


        }else if(lastState==0&&distanceBW>150) {
          // last state was out and now also out
          print(" out  out");
          await setData(0);
          // update  in database with time stamp
        }else if(lastState==1&&distanceBW<150){
          // last state was in and now also in
          print(" in in");
          await setData(1);
          // update  in database with time stamp
        }
    });
  }



  static Future<void> setData(int state) async {
// 0- out
// 1- in

    String key = 'last_check_in_state';
    String todayKey = DateFormat('dMMMyyyy').format(DateTime.now());
    key+= '_$todayKey';
    SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setInt(key, state);

  }



 static Future<int?> getLastState() async {
      String key = 'last_check_in_state';

      // Format the date to append to the key
      String todayKey = DateFormat('dMMMyyyy').format(DateTime.now());
      key += '_$todayKey';

      // Get the instance of SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if the key exists, if not, return a default value (0 in this case)
      if (prefs.containsKey(key)) {
        // If the key exists, return the stored value
       int val = prefs.getInt(key) ?? 0;
        return val;
      } else {
        // If the key doesn't exist, set and return the default value
        prefs.setInt(key, 0);
        return 0;
      }
    }

 static Future<Position> getLocation() async {
   bool enab = await Geolocator.isLocationServiceEnabled();
   if(!enab) {

     await Geolocator.openLocationSettings();
   }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
