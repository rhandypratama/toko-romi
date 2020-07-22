import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class KirimBarangScreen extends StatefulWidget {
  @override
  KirimBarangScreenState createState() => KirimBarangScreenState();
}

class KirimBarangScreenState extends State<KirimBarangScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _keluhanFocus = FocusNode();
  final keluhanController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";
  final f = NumberFormat('#,##0', 'id_ID');
  var barangs = [
    'Antar Langsung',
    'Via Kurir Ekspedisi',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    keluhanController.dispose();
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
        title: dynamicText("Kirim Barang", color: Colors.black),
      
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 10.0),
                    child: dynamicText("Mau kirim barang kemana?", fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: dynamicText("Sekarang ada fitur pengeiriman barang di dalam kota dan luar kota loh!", fontSize: 16)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: jenisField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 10.0),
                    child: defaultButton(
                      context, 
                      "lanjutkan", 
                      onPress: () async {
                        
                      } 
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 30.0),
                    child: tips()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 10.0),
                    child: dynamicText("Atau mau kirim barang dengan mobil bak?", fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: dynamicText("Tenang, kita juga menyediakan pengiriman dengan mobil bak", fontSize: 16)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Image.asset('assets/images/packs/pickup-car.png'),
                        title: dynamicText("PICKUP BAK", fontSize: 20, fontWeight: FontWeight.bold),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            dynamicText("Ukuran : 200x130x120"),
                            dynamicText("Berat Maks : 1000 kg"),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   color: Colors.white,
          //   child: Column(
          //     children: <Widget>[
          //       Divider(),
          //       Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Container(
          //           color: Colors.white,
          //           padding: const EdgeInsets.only(bottom: 10, top: 5, left: kDefaultPaddin, right: kDefaultPaddin),
          //           child: Row(
          //             children: <Widget>[
          //               Expanded(
          //                 child: defaultButton(
          //                   context, 
          //                   "lanjutkan", 
          //                   onPress: () async {
                              
          //                   } 
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
            
                    
        ],
      ),
    );
  }

  Widget keluhanField() {
    return TextFormField(
      controller: keluhanController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _keluhanFocus,
      onFieldSubmitted: (term) {
        _keluhanFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Keluhan",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : Layar mati total"
      ),
      style: TextStyle(fontSize: 24),
      
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget jenisField() {
    return DropdownButtonFormField(
      isDense: false,
      itemHeight: 50,
      hint: dynamicText("Pilih jenis layanan", fontSize: 20),
      items: barangs.map((String x) {
        return DropdownMenuItem<String>(
          value: x,
          child: dynamicText("$x", fontSize: 20)
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
          dynamicText("Transaksi di atas jam operasional akan diproses ke-esokan harinya", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Jasa kurir ekspedisi yang tersedia adalah TIKI, JNE, dan KALOG", fontSize: 13, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
   
}