import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toko_romi/screens/auth/login-screen.dart';
import 'package:toko_romi/screens/cart/cart.dart';
import 'package:toko_romi/screens/home/components/body.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  Position _lastKnownPosition;
  Position _currentPosition;
  
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
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // leading: Image.asset('assets/images/user-lock.png', height: 2,),
      
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/password.svg"),
      //   onPressed: () {},
      // ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/password.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {
            navigationManager(context, LoginScreen(), isPushReplaced: false);
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {
            navigationManager(context, CartScreen(), isPushReplaced: false);
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}