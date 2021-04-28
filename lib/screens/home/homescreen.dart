//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:toko_romi/blocs/auth-service.dart';
//import 'package:toko_romi/screens/auth/login-screen.dart';
//import 'package:toko_romi/screens/cart/cart.dart';
import 'package:toko_romi/screens/home/components/body.dart';
import 'package:toko_romi/screens/profile/profile.dart';
import 'package:toko_romi/utils/constant.dart';
//import 'package:toko_romi/utils/splash.dart';
import 'package:toko_romi/utils/widget-model.dart';

class HomeScreen extends StatefulWidget {
  // final FirebaseUser user;

  // const HomeScreen({
  //   Key key, 
  //   this.user,
  // }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  Position _lastKnownPosition;
  Position _currentPosition;
  String uName = "";
  
  @override
  void initState() {
    super.initState();
    _initLastKnownLocation();
    _initCurrentLocation();

  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      position = await geolocator.getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }
    if (!mounted) return;
    setState(() {
      _lastKnownPosition = position;
    });
  }

  _initCurrentLocation() {
    geolocator..getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {  
      if (mounted) {
        setState(() => _currentPosition = position);
      }
    }).catchError((e) {
      print('Error initCurrentLocation ${e.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      appBar: PreferredSize(
        child: Container(
          // decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey[100],
          //     offset: Offset(0, 2.0),
          //     blurRadius: 6.0,
          //   )
          // ]),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: SvgPicture.asset("assets/icons/user.svg", height: 30,),
                onPressed: () {
                  navigationManager(context, ProfileScreen(
                    // googleSignIn: googleSignIn,
                    // user: widget.user,
                  ), isPushReplaced: false);
                },
              ),
              SizedBox(width: kDefaultPaddin / 2)
            ],
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // leading: Image.asset('assets/images/user-lock.png', width: 20,),
      
      // leading: Row(
      //   children: <Widget>[
      //     IconButton(
      //       icon: SvgPicture.asset("assets/icons/user.svg", height: 30,),
      //       onPressed: () {
      //         navigationManager(context, ProfileScreen(
      //           // googleSignIn: googleSignIn,
      //           // user: widget.user,
      //         ), isPushReplaced: false);
      //       },
      //     ),
          
      //   ],
      // ), 
      // title: GestureDetector(
      //   onTap: () {
      //     SignIn().signOutGoogle();
      //     navigationManager(context, SplashScreen(), isPushReplaced: true);
      //   },
      //   child: dynamicText(uName, color: Colors.black87),
        
      // ),
      actions: <Widget>[
        // IconButton(
        //   icon: SvgPicture.asset(
        //     "assets/icons/password.svg",
        //     // By default our  icon color is white
        //     color: kTextColor,
        //   ),
        //   onPressed: () {
        //     navigationManager(context, LoginScreen(), isPushReplaced: false);
        //   },
        // ),
        // IconButton(
        //   icon: SvgPicture.asset(
        //     "assets/icons/shop.svg",
        //     // By default our  icon color is white
        //     // color: kTextColor,
        //   ),
        //   onPressed: () {
        //     navigationManager(context, CartScreen(), isPushReplaced: false);
        //   },
        // ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/user.svg", height: 30,),
          onPressed: () {
            navigationManager(context, ProfileScreen(
              // googleSignIn: googleSignIn,
              // user: widget.user,
            ), isPushReplaced: false);
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}