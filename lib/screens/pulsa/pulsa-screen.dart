import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_romi/screens/admin/admin-dashboard.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class PulsaScreen extends StatefulWidget {
  @override
  _PulsaScreenState createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final userController = TextEditingController();
  final nominalController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    userController.dispose();
    nominalController.dispose();
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
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: dynamicText("Pulsa & Paket Data", color: Colors.black),
      
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: noHpField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: nominalField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 30.0),
                    child: tips()
                  ),

                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Divider(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(bottom: 10, top: 5, left: kDefaultPaddin, right: kDefaultPaddin),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: defaultButton(
                            context, 
                            "beli pulsa sekarang", 
                            onPress: () async {
                              try {
                                print(userController.text);
                                if (userController.text == "") {
                                  _showSnackBarMessage("Nomor handphone wajib diisi");
                                } else if (currentCat == "") {
                                  _showSnackBarMessage("Pilih nominal yang tersedia");
                                } else {
                                  var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                    nomorAdmin,
                                    'PULSA $currentCat | ${userController.text}'
                                  );
                                }
                                
                              } catch (e) {
                                print(e.toString());
                              }
                            } 
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
            
                    
        ],
      ),
    );
  }

  Widget noHpField() {
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
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Nomor Handphone",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 08123456789"
      ),
      style: TextStyle(fontSize: 28),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget nominalField() {
    return DropdownButtonFormField(
      isDense: false,
      itemHeight: 50,
      hint: dynamicText("Pilih nominal yang tersedia", fontSize: 20),
      items: ['5.000', '10.000', '25.000', '50.000', '100.000', '200.000', '500.000', '1.000.000'].map((String x) {
        return DropdownMenuItem<String>(
          value: x,
          child: dynamicText("$x", fontSize: 24)
        );
      }).toList(),
      onChanged: (newCat) {
        setState(() {
          currentCat = newCat;
        });
      },
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
        labelText: "Nominal",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),
      style: TextStyle(fontSize: 28),
      
    );
      
  }

  Widget tips() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200], width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.info, color: Colors.black54,),
              SizedBox(width: 4,),
              dynamicText("Informasi", fontWeight: FontWeight.bold),
            ],
          ),
          
          SizedBox(height: 20,),
          dynamicText("Pastikan nomor handphone sudah benar", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi pembelian pulsa bisa dilakukan kapan saja (24 Jam)", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Semua bukti pembayaran akan dikirim ke WhatsApp kalian", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Apabila terjadi gangguan kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Untuk pembelian paket data internet masih belum tersedia", fontSize: 13, fontWeight: FontWeight.bold),

        ],
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
      onPressed: () {
        if (userController.text == "admin") {
          if (passwordController.text == "123456") {
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