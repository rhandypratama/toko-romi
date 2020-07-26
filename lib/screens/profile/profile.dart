import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/auth-service.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/splash.dart';
import 'package:toko_romi/utils/widget-model.dart';

class ProfileScreen extends StatefulWidget {
  // final GoogleSignIn googleSignIn;
  // final FirebaseUser user;

  // const ProfileScreen({
  //   Key key, 
  //   this.googleSignIn,
  //   this.user,
  // }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  // GoogleSignIn googleSignIn;
  // FirebaseUser user;

  // handle() {
  //   SignIn().handleSignIn().then((value) {
  //     print(value);
  //     setState(() async {
  //       user = value;
  //     });
  //     return value;  
  //   });
  //   // if (mounted) return;
  //   // setState(() async {
  //   //   user = a;
  //   // });
  // }

  
  @override
  void initState() {
    super.initState();
    // handle();
    // print(user);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (mounted) print(user);
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //       print('NOWWWWW');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var photo = (user != null) ? user.photo : '';
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                placeholder: (context, url) => defaultLoading(),
                imageUrl: photo,
                width: 60,
                fit: BoxFit.fill,
              )
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: OutlineButton(
            //     // color: Colors.redAccent,
            //     splashColor: Colors.grey,
            //     onPressed: () {
            //       AuthService().signOutGoogle();
            //       navigationManager(context, SplashScreen(), isPushReplaced: true);
            //     },
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(40),
                  
            //     ),
            //     highlightElevation: 0,
            //     borderSide: BorderSide(color: Colors.red),
            //     child: Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           Image(image: AssetImage("assets/images/google-logo.png"), height: 35.0),
            //           Padding(
            //             padding: const EdgeInsets.only(left: 10),
            //             child: Text(
            //               'Keluar dari Akun Google',
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 color: Colors.grey,
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: dynamicText("Profil", color: Colors.black87),
      
    );
  }
}