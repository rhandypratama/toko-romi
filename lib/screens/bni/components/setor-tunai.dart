import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/orderan.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class SetorTunai extends StatefulWidget {
  @override
  _SetorTunaiState createState() => _SetorTunaiState();
}

class _SetorTunaiState extends State<SetorTunai> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _nominalFocus = FocusNode();
  final FocusNode _rekeningFocus = FocusNode();
  final rekeningController = TextEditingController();
  final nominalController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";
  var f = NumberFormat('#,##0', 'id_ID');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    rekeningController.dispose();
    nominalController.dispose();
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
                    child: noRekeningField()
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
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
                            "setor tunai sekarang", 
                            onPress: () async {
                              try {
                                
                                if (rekeningController.text == "") {
                                  _showSnackBarMessage("Nomor rekening wajib diisi");
                                } else if (nominalController.text == "") {
                                  _showSnackBarMessage("Nominal penyetoran wajib diisi");
                                } else {
                                  var save = await Orderan().saveOrderanJasa(userId, 'SETOR TUNAI BNI NO. REK : ${rekeningController.text} | NOMINAL : ${f.format(int.parse(nominalController.text))}');
                                  if (save.documentID != null) {
                                    var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                    FlutterOpenWhatsapp.sendSingleMessage(
                                      nomorAdmin,
                                      'SETOR TUNAI BNI NO. REK : ${rekeningController.text} | NOMINAL : ${f.format(int.parse(nominalController.text))}'
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

  Widget noRekeningField() {
    return TextFormField(
      controller: rekeningController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _rekeningFocus,
      onFieldSubmitted: (term) {
        fieldFocusChange(context, _rekeningFocus, _nominalFocus);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "No. Rekening",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 56703073751"
      ),
      style: TextStyle(fontSize: 28),
    );
      
  }

  Widget nominalField() {
    return TextFormField(
      controller: nominalController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _nominalFocus,
      onFieldSubmitted: (term) {
        _nominalFocus.unfocus();
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Nominal",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 1500000 (tanpa titik / koma / spasi)"
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
          dynamicText("Pastikan rekening dan jumlah setoran kalian sudah benar", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi setor tunai BNI bisa dilakukan kapan saja (24 Jam)", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Semua bukti pembayaran akan dikirim ke WhatsApp kalian", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Apabila terjadi gangguan kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14),
          
        ],
      ),
    );
  }
   
}