import 'package:flutter/material.dart';
import 'package:sih/HomePage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/Services/locationService.dart';

class SC1 extends StatefulWidget {
  const SC1({super.key});

  @override
  State<SC1> createState() => _SC1State();
}

class _SC1State extends State<SC1> {
  bool isServiceRunning = false;  // Track service status

  Future<void> setData() async {
    String key = 'last_check_in_state';
    String todayKey = DateFormat('dMMMyyyy').format(DateTime.now());
    key += '_$todayKey';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      prefs.setInt(key, 0);
      print("Initial out set done");
    }
    print(prefs.getInt(key) == 0 ? 'Out' : 'In');
  }

  @override
  void initState() {
    super.initState();
    checkServiceStatus(); // Check service status when initializing the screen
  }

  Future<void> initialize() async {
    if(!await Geolocator.isLocationServiceEnabled()){
      await Geolocator.openLocationSettings();
    }

  //  await Geolocator.openLocationSettings();
    await LocationService().initializeService();
    await setData();
    LocationService.StartService();
    await checkServiceStatus();
  }

  Future<void> checkServiceStatus() async {
    bool isRunning = await LocationService.service.isRunning();
    setState(() {
      isServiceRunning = isRunning;
      print("here");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if(!isServiceRunning){
                // Start service only if it is not running
                await initialize();
              }

            },
            child: Center(
              child: Text(isServiceRunning ? 'Service Running' : 'Start Service'),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              LocationService.StopService();
              checkServiceStatus();  // Update status after stopping
            },
            child: Center(
              child: Text('Stop Service'),
            ),
          ),
        ],
      ),
    );
  }
}
