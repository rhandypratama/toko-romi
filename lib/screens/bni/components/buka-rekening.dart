import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class BukaRekening extends StatefulWidget {
  @override
  _BukaRekeningState createState() => _BukaRekeningState();
}

class _BukaRekeningState extends State<BukaRekening> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _ibuFocus = FocusNode();
  final FocusNode _noHpFocus = FocusNode();
  final noHpController = TextEditingController();
  final ibuController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    noHpController.dispose();
    ibuController.dispose();
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
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: ibuField()
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
                            "buka rekening sekarang", 
                            onPress: () async {
                              try {
                                
                                if (noHpController.text == "") {
                                  _showSnackBarMessage("Nomor handphone calon nasabah wajib diisi");
                                } else if (ibuController.text == "") {
                                  _showSnackBarMessage("Nama ibu kandung wajib diisi");
                                } else {
                                  var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                    nomorAdmin,
                                    'BUKA REKENING BNI ${noHpController.text} | ${ibuController.text}'
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
      controller: noHpController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _noHpFocus,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, _noHpFocus, _ibuFocus);
      },
      // style: textFieldStyle,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "No. Handphone Calon Nasabah",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 08123456789"
      ),
      style: TextStyle(fontSize: 28),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget ibuField() {
    return TextFormField(
      controller: ibuController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _ibuFocus,
      onFieldSubmitted: (term) {
        _ibuFocus.unfocus();
      },
      // style: textFieldStyle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Ibu Kandung",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        // helperText: "Contoh : 08123456789"
      ),
      style: TextStyle(fontSize: 28),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
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
          dynamicText("Minimal setoran awal untuk buka rekening baru BNI Laku Pandai adalah Rp25.000", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Siapkan foto KTP dan Foto diri sebagai persyaratan buka rekening baru", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi buka rekening baru bisa dilakukan kapan saja (24 Jam)", fontSize: 14),
          
        ],
      ),
    );
  }
   
}