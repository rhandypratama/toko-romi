import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toko_romi/screens/home/homescreen.dart';
import 'package:toko_romi/utils/widget-model.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<String> getSettings() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
      .collection('settings')
      .document('v95naiHwl0OSEdNwSYOk')
      .get();
    // if (querySnapshot.exists &&
    //     querySnapshot.data.containsKey('favorites') &&
    //     querySnapshot.data['favorites'] is List) {
    //   // Create a new List<String> from List<dynamic>
    //   return List<String>.from(querySnapshot.data['favorites']);
    // }
    if (querySnapshot.exists) {
      await savePreferences('username',stringValue: querySnapshot.data['username']);
      await savePreferences('password',stringValue: querySnapshot.data['password']);
      await savePreferences('admin-utama',stringValue: querySnapshot.data['adminUtama']);
      await savePreferences('admin-test',stringValue: querySnapshot.data['adminTest']);
      await savePreferences('admin-makanan',stringValue: querySnapshot.data['adminMakanan']);
      print("data setting berhasil disimpan");
    } else {
      print("data setting masih kosong");
    }
    var uuid = Uuid();
    var v4 = uuid.v4();
    await savePreferences('orderId', stringValue: v4);
  }
  
  @override
  void initState() {
    super.initState();
    getSettings();
  }

  Timer timer;
  _SplashScreenState() {
    timer = new Timer(const Duration(seconds: 4), () async {
      navigationManager(context, HomeScreen(), isPushReplaced: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(100.0),
              //   border: Border.all(
              //     color: Colors.black12,
              //     style: BorderStyle.solid,
              //     width: 6.0,
              //   ),
              //   // image: DecorationImage(
              //   //   image: AssetImage("assets/images/logo/logo.png"),
              //   //   fit: BoxFit.cover,
              //   // ),
              // ),
              padding: EdgeInsets.all(0),
              child: Image.asset('assets/images/toko.png'),
            ),
            Container(
              padding: EdgeInsets.all(1),
              width: MediaQuery.of(context).size.width,
              child: dynamicText("Toko Romi", 
                color: Colors.black38, 
                textAlign: TextAlign.center, 
                fontSize: 26
              )
            ),
            Container(
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              child: dynamicText("Belanja semakin lebih mudah", 
                color: Colors.black38, 
                textAlign: TextAlign.center, 
                fontSize: 12
              )
            ),
          ],
        ),
      ),
    );
  }
}
