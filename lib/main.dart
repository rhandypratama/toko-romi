import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/auth-service.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/screens/onboard/onboard.dart';
// import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/service-preference.dart';
import 'package:toko_romi/utils/splash.dart';

PrefService appService = new PrefService();
Future<bool> isOnBoard() async {
  final bool _result = await appService.onBoard();
  return _result;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await isOnBoard().then((onValue) {
    print('isOnBoard = $onValue');
  });
  // BuildContext context;
  runApp(StreamProvider<User>.value(
    value: AuthService().user,
    child: new MaterialApp(
    debugShowCheckedModeBanner: false,
    // theme: ThemeData(
    //   textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
    //   visualDensity: VisualDensity.adaptivePlatformDensity,
    // ),
    home: (await isOnBoard()) ? new SplashScreen() : new OnboardScreen(),
    ),
  ));
}

// void main() { 
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
//     runApp(new MyApp());
//   });
//   // runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // theme: themeData,
//       // navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
//       home: SplashScreen(),
//     );
//   }
// }