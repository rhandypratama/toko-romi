import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/auth-service.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/screens/auth/login-screen.dart';
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
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  AuthService _auth = AuthService();
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
  
  _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  
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
    var photo = (user != null) ? user?.photo : '';
    var userName = (user != null) ? user?.name : '';
    var userEmail = (user != null) ? user?.email : '';

    return Scaffold(
      key: scaffoldState,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => defaultLoading(),
                            imageUrl: photo,
                            width: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        
                        Container(
                          margin: EdgeInsets.only(left: 40.0),
                          height: 20.0,
                          width: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.amber,
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2.0
                            )
                          ),
                        )
                      ]
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: dynamicText(userName, fontSize: 22)
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                              child: dynamicText(userEmail, fontSize: 16, color: Colors.black45)
                            ),
                          ],
                        ),
                        Container(
                          // color: Colors.amber,
                          width: 80,
                          child: GestureDetector(
                            onTap: () {
                              _auth.signOutGoogle();
                              _showSnackBarMessage("Berhasil keluar dari akun google. Tutup dan buka lagi aplikasi ini untuk memastikan terjadinya perubahan");
                            },
                            child: dynamicText("SIGN OUT", fontSize: 14, color: Colors.red , textAlign: TextAlign.right),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
                
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: dynamicText("Informasi Akun", fontSize: 20, fontWeight: FontWeight.bold)
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.amber[800]),
                title: dynamicText("Pesanan", fontSize: 16),
                trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                onTap: () {
                  _showSnackBarMessage("Fitur ini belum tersedia");
                },
              ),
              
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: dynamicText("Admin Area", fontSize: 20, fontWeight: FontWeight.bold)
              ),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.amber[800]),
                title: dynamicText("Sign In", fontSize: 16),
                trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                onTap: () {
                  navigationManager(context, LoginScreen(), isPushReplaced: false);
                },
              ),

            ],
          ),
        )
      ),
      
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       ClipRRect(
      //         borderRadius: BorderRadius.all(Radius.circular(50)),
      //         child: CachedNetworkImage(
      //           placeholder: (context, url) => defaultLoading(),
      //           imageUrl: photo,
      //           width: 60,
      //           fit: BoxFit.fill,
      //         )
      //       ),
            
      //     ],
      //   ),
      // ),
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
      title: dynamicText("Akun", color: Colors.black87),
      
    );
  }
}