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

class RentalScreen extends StatefulWidget {
  @override
  RentalScreenState createState() => RentalScreenState();
}

class RentalScreenState extends State<RentalScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _asalFocus = FocusNode();
  final FocusNode _tujuanFocus = FocusNode();
  final FocusNode _jmlPenumpangFocus = FocusNode();
  final asalController = TextEditingController();
  final tujuanController = TextEditingController();
  final jmlPenumpangController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";
  final f = NumberFormat('#,##0', 'id_ID');
  DateTime pickedDate;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  void dispose(){
    super.dispose();
    asalController.dispose();
    tujuanController.dispose();
    jmlPenumpangController.dispose();
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
        title: dynamicText("Rental Mobil / Sewa Kendaraan", color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        dynamicText(
                          "Tanggal Berangkat",
                          fontSize: 20
                        ),
                        dynamicText(
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        dynamicText(
                          "Jam Berangkat",
                          fontSize: 20
                        ),
                        dynamicText(
                          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ],
                    ),
                    
                    trailing: Icon(Icons.keyboard_arrow_down),
                    onTap: _pickTime,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: asalField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: tujuanField()
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                    child: jmlPenumpangField()
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
                            "sewa kendaraan sekarang", 
                            onPress: () async {
                              try {
                                // print("${pickedDate.day}-${pickedDate.month}-${pickedDate.year}");
                                // print("${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}");
                                if (asalController.text == "") {
                                  _showSnackBarMessage("Alamat penjemputan wajib diisi");
                                } else if (tujuanController.text == "") {
                                  _showSnackBarMessage("Kota tujuan wajib diisi");
                                } else if (jmlPenumpangController.text == "") {
                                  _showSnackBarMessage("Jumlah penumpang wajib diisi");
                                } else {
                                  var save = await Orderan().saveOrderanJasa(userId, "RENTAL MOBIL TANGGAL : ${pickedDate.day}-${pickedDate.month}-${pickedDate.year} | JAM ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} | ${jmlPenumpangController.text} Orang | ASAL : ${asalController.text} | TUJUAN : ${tujuanController.text}");
                                  if (save.documentID != null) {
                                    var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                    FlutterOpenWhatsapp.sendSingleMessage(
                                      nomorAdmin,
                                      "RENTAL MOBIL TANGGAL : ${pickedDate.day}-${pickedDate.month}-${pickedDate.year} | JAM ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} | ${jmlPenumpangController.text} Orang | ASAL : ${asalController.text} | TUJUAN : ${tujuanController.text}"
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

  Widget asalField() {
    return TextFormField(
      controller: asalController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _asalFocus,
      onFieldSubmitted: (term) {
        // fieldFocusChange(context, _asalFocus, _tujuanFocus);
        _asalFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Alamat Penjemputan",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : Rumah Pak Slamet Jl. Guntar No. 45 Desa Wringinagung"
      ),
      style: TextStyle(fontSize: 24),
    ); 
  }

  Widget tujuanField() {
    return TextFormField(
      controller: tujuanController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _tujuanFocus,
      onFieldSubmitted: (term) {
        // fieldFocusChange(context, _tujuanFocus, _jmlPenumpangFocus);
        _tujuanFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Kota Tujuan",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : Surabaya"
      ),
      style: TextStyle(fontSize: 24),
    ); 
  }

  Widget jmlPenumpangField() {
    return TextFormField(
      controller: jmlPenumpangController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _jmlPenumpangFocus,
      onFieldSubmitted: (term) {
        _jmlPenumpangFocus.unfocus();
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Jumlah Penumpang",
        labelStyle: TextStyle(fontSize: 20.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : 6"
      ),
      style: TextStyle(fontSize: 24),
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
          dynamicText("Untuk sewa kendaraan minimal 2 hari sebelum berangkat harus sudah pesan", fontSize: 13, fontWeight: FontWeight.bold),
          SizedBox(height: 10,),
          dynamicText("Pastikan alamat tujuan, kota tujuan, dan jumlah penumpang sudah benar", fontSize: 14),
          SizedBox(height: 10,),
          dynamicText("Tunggu sampai tim kami memberikan informasi harga sewa mobil ke kalian melalui WhatsApp", fontSize: 13, fontWeight: FontWeight.bold),
          SizedBox(height: 10,),
          dynamicText("Apabila kendaraan sudah siap, kami akan langsung memberikan informasi ke kalian melalui WhatsApp", fontSize: 14), 
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: pickedDate,
    );

    if(date != null)
      setState(() {
        pickedDate = date;
      });

  }
  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time
    );

    if(t != null)
      setState(() {
        time = t;
      });

  }
   
}