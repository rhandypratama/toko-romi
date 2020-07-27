import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/orderan.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class TagihanListrik extends StatefulWidget {
  @override
  _TagihanListrikState createState() => _TagihanListrikState();
}

class _TagihanListrikState extends State<TagihanListrik> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final meterTagihanController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    meterTagihanController.dispose();
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var userId = (user != null) ? user?.uid : '';
    
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
                            "bayar listrik sekarang", 
                            onPress: () async {
                              try {
                                
                                if (meterTagihanController.text == "") {
                                  _showSnackBarMessage("Nomor meter / ID pelanggan wajib diisi");
                                } else {
                                  // print('tagihan ${meterTagihanController.text}');
                                  var save = await Orderan().saveOrderanJasa(userId, 'TAGIHAN LISTRIK ${meterTagihanController.text}');
                                  if (save.documentID != null) {
                                    var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                    FlutterOpenWhatsapp.sendSingleMessage(
                                      nomorAdmin,
                                      'TAGIHAN LISTRIK ${meterTagihanController.text}'
                                    );
                                  }
                                  
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
      controller: meterTagihanController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, _emailFocus, _passwordFocus);
      },
      // style: textFieldStyle,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "No. Meter / ID Pelanggan",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 56703073751"
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
          dynamicText("Pastikan nomor meter / id pelanggan kalian sudah benar", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi bayar listrik bisa dilakukan kapan saja (24 Jam)", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Semua bukti pembayaran akan dikirim ke WhatsApp kalian", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Apabila terjadi gangguan kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14),
          
        ],
      ),
    );
  }
   
}