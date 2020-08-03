import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_romi/screens/admin/home.dart';
import 'package:toko_romi/utils/widget-model.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  // var cat = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: Image.asset('assets/images/user-lock.png', height: 2,),
        
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      
      ),
      body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // _buildHeader(),
                SizedBox(height: 20.0),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: OverflowBox(
                    maxWidth: 500,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text("Authentication", style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(width: 30),
                        Text("Authentication", style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 10.0),
                // PopupMenuButton<String>(
                //   // onSelected: _menuAppBarAction,
                //   itemBuilder: (BuildContext context) {
                //     return ['m', 'd'].map((String val) {
                //             return PopupMenuItem<String>(
                //               value: val,
                //               child: dynamicText(val),
                //             );
                //           }).toList();
                        
                //   },
                // ),
                // // DropdownMenuItem(child: null)
                // DropdownButtonFormField(
                //   // hint: dynamicText("Pilih kategori barang"),
                //   // value: null,
                //   items: ['m', 'd'].map((String val) {
                //     return DropdownMenuItem<String>(
                //       value: val,
                //       child: dynamicText("$val")
                //     );
                //   }).toList(), 
                //   onChanged: (newVal) {
                //     setState(() {
                //       cat = newVal;
                //     });
                //   } ,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0.0),
                  child: emailField()
                  
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0.0),
                  child: passwordField()
                  
                ),
                SizedBox(height: 50.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: submitButton()
                  
                ),
              ],
            ),
          ),
        ),
    );
  }

  Container _buildHeader() {
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: -100,
            top: -150,
            child: Container(
              width: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  // colors: [color1, color2]
                  colors: [Colors.yellow, Colors.amber]
                ),
                boxShadow: [
                  BoxShadow(
                    // color: color2,
                    color: Colors.amber,
                    offset: Offset(4.0,4.0),
                    blurRadius: 20.0
                  )
                ]
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: userController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, _emailFocus, _passwordFocus);
      },
      // style: textFieldStyle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Username",
        // prefixIcon: Material(
        //   child: Icon(
        //     Icons.person,
        //     color: Colors.grey,
        //   ),
        // ),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      focusNode: _passwordFocus,
      obscureText: true,
      onFieldSubmitted: (value) {
        _passwordFocus.unfocus();
      },
      decoration: InputDecoration(
        labelText: "Password",
        // prefixIcon: Material(
        //   child: Icon(
        //     Icons.lock,
        //     color: Colors.grey,
        //   ),
        // ),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),
      
    );
      
  }

  Widget submitButton() {
    return RaisedButton(
      padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
      color: Colors.yellow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0)
        )
      ),
      onPressed: () async {
        var username = await getPreferences('username', kType: 'string');
        var password = await getPreferences('password', kType: 'string');
        if (userController.text == username) {
          if (passwordController.text == password) {
            Navigator.pop(context);
            navigationManager(context, AdminScreen(), isPushReplaced: false);
          } else {
            _showSnackBarMessage("Password tidak valid");
            // print("Password tidak valid");
          }
        } else {
          _showSnackBarMessage("Username tidak valid");
          // print("Username tidak valid");
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Masuk".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          SizedBox(width: 10.0),
          Icon(
            Icons.arrow_forward,
            size: 24.0,
          )
        ],
      ),
    );
  } 
   
}