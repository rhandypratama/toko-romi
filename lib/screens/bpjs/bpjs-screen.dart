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

class BpjsScreen extends StatefulWidget {
  @override
  BpjsScreenState createState() => BpjsScreenState();
}

class BpjsScreenState extends State<BpjsScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _vaFocus = FocusNode();
  final noVaController = TextEditingController();
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
    noVaController.dispose();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          // decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey[100],
          //     offset: Offset(0, 2.0),
          //     blurRadius: 6.0,
          //   )
          // ]),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset("assets/icons/back.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: dynamicText("BPJS Kesehatan", fontWeight: FontWeight.w600),
          
          ),
        ),
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
                    child: noVaField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: bulanField()
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
                            "bayar bpjs sekarang", 
                            onPress: () async {
                              try {
                                if (noVaController.text == "") {
                                  _showSnackBarMessage("No VA Keluarga wajib diisi");
                                } else if (currentCat == "") {
                                  _showSnackBarMessage("Pilih bulan yang tersedia");
                                } else {
                                  // print('BPJS ${noVaController.text} | $currentCat');
                                  var save = await Orderan().saveOrderanJasa(userId, 'BPJS NO. VA : ${noVaController.text} | $currentCat');
                                  if (save.documentID != null) {
                                    var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                    FlutterOpenWhatsapp.sendSingleMessage(
                                      nomorAdmin,
                                      'BPJS NO. VA : ${noVaController.text} | $currentCat'
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

  Widget noVaField() {
    return TextFormField(
      controller: noVaController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _vaFocus,
      onFieldSubmitted: (term) {
        _vaFocus.unfocus();
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "No. VA Keluarga",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        helperText: "Contoh : 0001234567890"
      ),
      style: TextStyle(fontSize: 24),
      
      // decoration: textInputDecoration(Icons.person, "Email", snapshot, hintText: "Email"),
    );
      
  }

  Widget bulanField() {
    return DropdownButtonFormField(
      isDense: false,
      itemHeight: 50,
      hint: dynamicText("Pilih bulan", fontSize: 20),
      items: ['1 Bulan', '2 Bulan', '3 Bulan', '4 Bulan', '5 Bulan', '6 Bulan', '7 Bulan', '8 Bulan', '9 Bulan', '10 Bulan', '11 Bulan', '12 Bulan'].map((String x) {
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
          dynamicText("Pastikan nomor VA keluarga sudah benar", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Transaksi di atas jam operasional akan diproses ke-esokan harinya", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Semua bukti pembayaran akan dikirim ke WhatsApp kalian", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Apabila terjadi gangguan kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14),
          
        ],
      ),
    );
  }
   
}