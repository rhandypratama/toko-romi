import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/orderan.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class TarikScreen extends StatefulWidget {
  @override
  TarikScreenState createState() => TarikScreenState();
}

class TarikScreenState extends State<TarikScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final namaPenerimaController = TextEditingController();
  final nominalController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";
  final f = NumberFormat('#,##0', 'id_ID');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    namaPenerimaController.dispose();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: dynamicText("Tarik Tunai", color: Colors.black),
      
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                  //   child: bankField()
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                  //   child: noHpField()
                  // ),
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
                            "tarik tunai sekarang", 
                            onPress: () async {
                              try {
                                if (nominalController.text == "") {
                                  _showSnackBarMessage("Nominal penarikan wajib diisi");
                                } else {
                                  // print(f.format(int.parse(nominalController.text)));
                                  // print("${f.format(int.parse(nominalController.text))}");
                                  var save = await Orderan().saveOrderanJasa(userId, 'TARIK TUNAI ${f.format(int.parse(nominalController.text))}');
                                  if (save.documentID != null) {
                                    var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                    FlutterOpenWhatsapp.sendSingleMessage(
                                      nomorAdmin,
                                      'TARIK TUNAI ${f.format(int.parse(nominalController.text))}'
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
      controller: namaPenerimaController,
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
        labelText: "Nama Penerima",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),
      style: TextStyle(fontSize: 28),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget nominalField() {
    return TextFormField(
      controller: nominalController,
      autocorrect: false,
      // cursorColor: SwatchColor.kLightBlueGreen,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _passwordFocus,
      onFieldSubmitted: (term) {
        _passwordFocus.unfocus();
      },
      // style: textFieldStyle,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Nominal Penarikan",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 1400000 (tanpa titik / koma)"
      ),
      style: TextStyle(fontSize: 28),
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget bankField() {
    return DropdownButtonFormField(
      isDense: false,
      itemHeight: 50,
      hint: dynamicText("Pilih bank tujuan yang tersedia", fontSize: 20),
      items: ['BCA', 'BRI', 'BNI', 'BTN', 'BUKOPIN', 'CIMB NIAGA', 'DANAMON', 'MANDIRI', 'MEGA', 'PERMATA'].map((String x) {
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
          dynamicText("Pastikan nominal penarikan sudah benar", fontSize: 14),
          SizedBox(height: 20,),
          dynamicText("Untuk transaksi tarik tunai hanya melayani Bank BUMN (BRI, BNI, BTN, MANDIRI)", fontSize: 13, fontWeight: FontWeight.bold),
          SizedBox(height: 10,),
          dynamicText("Persiapkan kartu ATM kalian, agar tim kami bisa proses dengan segera", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi di atas jam operasional akan diproses ke-esokan harinya", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Semua bukti transaksi akan dikirim ke WhatsApp kalian", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Apabila terjadi gangguan kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14),
          
        ],
      ),
    );
  }
   
}