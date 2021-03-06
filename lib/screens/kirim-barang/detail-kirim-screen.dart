import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/blocs/orderan.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class DetailKirimScreen extends StatefulWidget {
  final String jenisLayanan;
  
  const DetailKirimScreen({
    Key key, 
    @required this.jenisLayanan,
  }) : super(key: key);

  @override
  DetailKirimScreenState createState() => DetailKirimScreenState();
}

class DetailKirimScreenState extends State<DetailKirimScreen> {
  final Color color1 = Color(0xffFA696C);
  final Color color2 = Color(0xffFA8165);
  final Color color3 = Color(0xffFB8964);

  final FocusNode _alamatTujuanFocus = FocusNode();
  final FocusNode _namaPenerimaFocus = FocusNode();
  final FocusNode _noHpPenerimaFocus = FocusNode();
  final FocusNode _namaPengirimFocus = FocusNode();
  final FocusNode _noHpPengirimFocus = FocusNode();
  final FocusNode _barangFocus = FocusNode();
  final alamatTujuanController = TextEditingController();
  final namaPenerimaController = TextEditingController();
  final noHpPenerimaController = TextEditingController();
  final namaPengirimController = TextEditingController();
  final noHpPengirimController = TextEditingController();
  final barangController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String currentCat = "";
  final f = NumberFormat('#,##0', 'id_ID');

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  Position _lastKnownPosition;
  Position _currentPosition;
  String _placemark = '';
  String _currentAddress = '';

  @override
  void initState() {
    super.initState();
    _initLastKnownLocation();
    _initCurrentLocation();
  }
  
  @override
  void dispose(){
    super.dispose();
    alamatTujuanController.dispose();
    namaPenerimaController.dispose();
    noHpPenerimaController.dispose();
    namaPengirimController.dispose();
    noHpPengirimController.dispose();
    barangController.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }
  
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      if (p != null && p.isNotEmpty) {
        Placemark place = p[0];
        setState(() {
          _currentAddress = '${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      position = await geolocator.getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }
    if (!mounted) return;
    setState(() {
      _lastKnownPosition = position;
    });
  }

  _initCurrentLocation() {
    geolocator..getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {  
      if (mounted) {
        setState(() => _currentPosition = position);
        print('lat : ${_currentPosition.latitude}');
        print('long : ${_currentPosition.longitude}');
        _getAddressFromLatLng();
      }
    }).catchError((e) {
      print(e.toString());
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var userId = (user != null) ? user?.uid : '';
    
    return 
      FutureBuilder<GeolocationStatus>(
      future: Geolocator().checkGeolocationPermissionStatus(),
      builder:
        (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == GeolocationStatus.denied) {
          return noDeviceLocation(
            context, 
            "Kirim Barang", 
            "Lokasimu tidak ditemukan", 
            "Beberapa fitur di aplikasi ini membutuhkan akses lokasi, mohon untuk izinkan akses atau aktifkan di pengaturan smartphone kalian"
          );
        }
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                dynamicText("Kirim Barang (${widget.jenisLayanan})", fontWeight: FontWeight.w600),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Image.asset('assets/gifs/tenor.gif', height: 20,),
                    SizedBox(width: 4),  
                    Expanded(child: dynamicText(_currentAddress, fontSize: 12, color: Colors.black45)),
                  ],
                ),

              ],
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
                        padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, top: 10.0, bottom: 0),
                        child: dynamicText("Tujuan", fontSize: 18, fontWeight: FontWeight.w600)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300], width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              
                              Padding(
                                padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, top: 0.0),
                                child: alamatTujuanField()
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                                child: namaPenerimaField()
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, bottom: 20.0),
                                child: noHpPenerimaField()
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, top: 10.0, bottom: 0),
                        child: dynamicText("Pengirim", fontSize: 18, fontWeight: FontWeight.w600)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300], width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 0.0),
                                child: namaPengirimField()
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, bottom: 20.0),
                                child: noHpPengirimField()
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, top: 10.0, bottom: 0),
                        child: dynamicText("Detail Barang", fontSize: 18, fontWeight: FontWeight.w600)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300], width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: kDefaultPaddin, right: kDefaultPaddin, bottom: 20.0),
                                child: barangField()
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin, vertical: 30.0),
                      //   child: tips()
                      // ),

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
                                "kirim barang sekarang", 
                                onPress: () async {
                                  try {
                                    if (alamatTujuanController.text == "") {
                                      _showSnackBarMessage("Alamat tujuan wajib diisi");
                                    } else if (namaPenerimaController.text == "") {
                                      _showSnackBarMessage("Nama penerima wajib diisi");
                                    } else if (noHpPenerimaController.text == "") {
                                      _showSnackBarMessage("No. handphone penerima wajib diisi");
                                    } else if (namaPengirimController.text == "") {
                                      _showSnackBarMessage("Nama pengirim wajib diisi");
                                    } else if (noHpPengirimController.text == "") {
                                      _showSnackBarMessage("No. handphone pengirim wajib diisi");
                                    } else {
                                      // print('KIRIM BARANG (${widget.jenisLayanan}) | NAMA PENERIMA : ${namaPenerimaController.text} | HP PENERIMA : ${noHpPenerimaController.text} | ALAMAT TUJUAN : ${alamatTujuanController.text} | NAMA PENGIRIM : ${namaPengirimController.text} | HP PENGIRIM : ${noHpPengirimController.text} | BARANG : ${barangController.text} | POS : https://maps.google.com?q=${_currentPosition.latitude},${_currentPosition.longitude}');
                                      var save = await Orderan().saveOrderanJasa(userId, 'KIRIM BARANG (${widget.jenisLayanan}) | NAMA PENERIMA : ${namaPenerimaController.text} | HP PENERIMA : ${noHpPenerimaController.text} | ALAMAT TUJUAN : ${alamatTujuanController.text} | NAMA PENGIRIM : ${namaPengirimController.text} | HP PENGIRIM : ${noHpPengirimController.text} | BARANG : ${barangController.text} | POS : https://maps.google.com?q=${_currentPosition.latitude},${_currentPosition.longitude}');
                                      if (save.documentID != null) {
                                        var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                        FlutterOpenWhatsapp.sendSingleMessage(
                                          nomorAdmin,
                                          'KIRIM BARANG (${widget.jenisLayanan}) | NAMA PENERIMA : ${namaPenerimaController.text} | HP PENERIMA : ${noHpPenerimaController.text} | ALAMAT TUJUAN : ${alamatTujuanController.text} | NAMA PENGIRIM : ${namaPengirimController.text} | HP PENGIRIM : ${noHpPengirimController.text} | BARANG : ${barangController.text} | POS : https://maps.google.com?q=${_currentPosition.latitude},${_currentPosition.longitude}'
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
    );
  }

  Widget namaPenerimaField() {
    return TextFormField(
      controller: namaPenerimaController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _namaPenerimaFocus,
      onFieldSubmitted: (term) {
        _namaPenerimaFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Penerima",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
      style: TextStyle(fontSize: 20),
    );
  }

  Widget namaPengirimField() {
    return TextFormField(
      controller: namaPengirimController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _namaPengirimFocus,
      onFieldSubmitted: (term) {
        _namaPengirimFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Pengirim",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
      style: TextStyle(fontSize: 20),
    );   
  }

  Widget barangField() {
    return TextFormField(
      controller: barangController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _barangFocus,
      onFieldSubmitted: (term) {
        _barangFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Jenis barang",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : Dokumen surat berharga / meja kursi, dll"
      ),
      style: TextStyle(fontSize: 20),
    );   
  }

  Widget noHpPenerimaField() {
    return TextFormField(
      controller: noHpPenerimaController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _noHpPenerimaFocus,
      onFieldSubmitted: (term) {
        _noHpPenerimaFocus.unfocus();
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "No. Handphone Penerima",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : 081234567890"
      ),
      style: TextStyle(fontSize: 20),
    );
  }

  Widget noHpPengirimField() {
    return TextFormField(
      controller: noHpPengirimController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _noHpPengirimFocus,
      onFieldSubmitted: (term) {
        _noHpPengirimFocus.unfocus();
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "No. Handphone Pengirim",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        helperText: "Contoh : 081234567890"
      ),
      style: TextStyle(fontSize: 20),
    );
  }

  Widget alamatTujuanField() {
    return TextFormField(
      controller: alamatTujuanController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      focusNode: _alamatTujuanFocus,
      onFieldSubmitted: (term) {
        _alamatTujuanFocus.unfocus();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Alamat Lengkap",
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        // helperText: ""
      ),
      style: TextStyle(fontSize: 20),
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
          dynamicText("Pastikan bank, nomor rekening, nama penerima, dan nominal transfer sudah benar", fontSize: 14),
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