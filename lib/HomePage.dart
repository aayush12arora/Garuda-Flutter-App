

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/Services/locationService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Future<void> setData() async {
// 0- out
// 1- in

    String key = 'last_check_in_state';
    String todayKey = DateFormat('dMMMyyyy').format(DateTime.now());
    key+= '_$todayKey';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)){
      int lastCheckInState = prefs.getInt(key) ?? 0;

    }
    else{
      prefs.setInt(key, 0);
      print("inital out set done");
    }
    print(prefs.getInt(key) ==0?'Out':'In');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Geolocator.openLocationSettings();
    LocationService().initializeService();

    setData();
LocationService.StartService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: LocationService.insideNotifier,
          builder: (context, insideCount, child) {
            return Text(
              'Inside Count: $insideCount',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
