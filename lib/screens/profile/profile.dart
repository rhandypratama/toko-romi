import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/auth-service.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/screens/auth/login-screen.dart';
import 'package:toko_romi/screens/pesanan/pesanan.dart';
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        // padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // color: Colors.yellow,
              padding: EdgeInsets.only(top: 20, bottom: 8, left: 20, right: 10),
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
                            child: dynamicText(userEmail, fontSize: 14, color: Colors.black45)
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       _auth.signOutGoogle();
                          //       _showSnackBarMessage("Berhasil keluar dari akun google. Tutup dan buka lagi aplikasi ini untuk memastikan terjadinya perubahan");
                          //     },
                          //     child: dynamicText("SIGN OUT", fontSize: 12, color: Colors.red , textAlign: TextAlign.right),
                          //   ),
                          // ),
                        ],
                      ),
                      // Container(
                      //   // color: Colors.amber,
                      //   width: 80,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       _auth.signOutGoogle();
                      //       _showSnackBarMessage("Berhasil keluar dari akun google. Tutup dan buka lagi aplikasi ini untuk memastikan terjadinya perubahan");
                      //     },
                      //     child: dynamicText("SIGN OUT", fontSize: 14, color: Colors.red , textAlign: TextAlign.right),
                      //   )
                      // ),
                    ],
                  ),
                ],
              ),
              
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: dynamicText("Informasi Akun", fontWeight: FontWeight.w600, fontSize: 18)
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              dense: true,
              // leading: Icon(Icons.shopping_cart, color: Colors.amber[800], size: 20,),
              title: Row(
                children: <Widget>[
                  Icon(Icons.list, color: Colors.amber[800], size: 18,),
                  SizedBox(width: 10,),
                  dynamicText("Pesananmu", fontSize: 16),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                navigationManager(context, PesananScreen(), isPushReplaced: false);
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: dynamicText("Informasi Lainnya", fontWeight: FontWeight.w600, fontSize: 18)
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              dense: true,
              title: Row(
                children: <Widget>[
                  Icon(Icons.help_outline, color: Colors.amber[800], size: 18,),
                  SizedBox(width: 10,),
                  dynamicText("Bantuan", fontSize: 16),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                _showSnackBarMessage("Fitur ini belum tersedia");
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              dense: true,
              title: Row(
                children: <Widget>[
                  Icon(Icons.account_balance, color: Colors.amber[800], size: 18,),
                  SizedBox(width: 10,),
                  dynamicText("Tentang Agen Romi", fontSize: 16),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                _showSnackBarMessage("Fitur ini belum tersedia");
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              dense: true,
              title: Row(
                children: <Widget>[
                  Icon(Icons.star_border, color: Colors.amber[800], size: 18,),
                  SizedBox(width: 10,),
                  dynamicText("Beri Rating", fontSize: 16),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16,),
              onTap: () {
                _showSnackBarMessage("Fitur ini belum tersedia");
              },
            ),
            Divider(),
            Container(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                dense: true,
                title: Row(
                  children: <Widget>[
                    Icon(Icons.lock_outline, color: Colors.amber[800], size: 18,),
                    SizedBox(width: 10,),
                    dynamicText("Admin Area", fontSize: 16),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16,),
                onTap: () {
                  navigationManager(context, LoginScreen(), isPushReplaced: false);
                },
              ),
            ),

          ],
        ),
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

  buildAppBar() {
    return PreferredSize(
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
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/back.svg", color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: dynamicText("Profil", fontWeight: FontWeight.w600),
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight),
    );
  }
}