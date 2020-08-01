import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-background.dart';
import 'package:toko_romi/utils/widget-color.dart';
import 'package:toko_romi/utils/widget-model.dart';

var grandTotal = 0;
bool cartKosong = true;
var orderId;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final AppColor appColor = AppColor();
  var f = NumberFormat('#,##0', 'id_ID');
  String order = "";
  int subTotal = 0;
  int grandTotal = 0;
  var arrPesanan = [];
  // String orderId3 = "";

  
  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  _getOrderId() async {
    // var newOrderId = await getPreferences('orderId');
    var newOrderId = await getPreferences('orderId', kType: "string");
    setState(() {
      orderId = newOrderId;
    });
    // print(newOrderId);
    return newOrderId;
  }

  @override
  void initState() {
    super.initState();
    _getOrderId();
    
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    final user = Provider.of<User>(context);
    var userId = (user != null) ? user?.uid : '';

    return Scaffold(
      key: scaffoldState,
      // backgroundColor: appColor.colorPrimary,
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context, userId),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () async {
      //   },
      //   backgroundColor: appColor.colorTertiary,
      // ),
    );
  }

  Container _buildWidgetListTodo(double widthScreen, double heightScreen, BuildContext context, String uid) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          //   child: Text(
          //     'Keranjang belanjamu',
          //     style: Theme.of(context).textTheme.title,
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('carts')
                // .where('orderId', isEqualTo: orderId)
                .where('userId', isEqualTo: uid)
                .orderBy('orderDate')
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  // print(orderId);
                  // return Center(child: CircularProgressIndicator());
                  return maintenancePage("", "Barang belanjamu masih kosong");
                }
                
                if (snapshot.data.documents.length <= 0) {
                  return maintenancePage("", "Barang belanjamu masih kosong");
                } else {
                  // for(var dt in snapshot.data.documents) {
                  //   var nama = dt.data['name']; 
                  //   var jumlah = dt.data['qty'].toString(); 
                  //   var harga = dt.data['price']; 
                  //   subTotal = (dt.data['qty'] * dt.data['price']); 
                  //   grandTotal += (dt.data['qty'] * dt.data['price']); 
                  //   order += nama + " # " + jumlah + " # " + f.format(harga) + " = " + f.format(subTotal) + "\n";
                  //   // print(order);
                  // }
                }
                // return dynamicText(order + "\n----------------------------------\nTOTAL " + f.format(grandTotal));
                
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    Map<String, dynamic> task = document.data;
                    // String strDate = task['date'];
                    var f = NumberFormat('#,##0', 'id_ID');
                    var subTotal = task['qty'] * task['price'];
                    // var subTotal1 = subTotal;
                    // // subTotal1 += task['qty'] * task['price'];
                    // // var sum = 0;
                    // // sum += subTotal;
                    // // var e = [];
                    // // e.add(subTotal);
                    // // var sum = e.reduce((a, b) => a + b);
                    // print(subTotal);

                    // subTotal1 += subTotal;
                    // // if (mounted) {
                    // //   setState(() {
                    // //     grandTotal = ss;
                    // //   });
                    // // }

                    return Card(
                      child: ListTile(
                        title: Text(task['name']),
                        subtitle: Text(
                          "${task['qty']} x ${f.format(task['price'])} = ${f.format(subTotal)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                // color: appColor.colorSecondary,
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: task['image'] != "" ? 
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => defaultLoading(),
                                    imageUrl: task['image'],
                                    width: 60,
                                    fit: BoxFit.fill,
                                  ),
                                )
                                // CachedNetworkImage(
                                //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                //   imageUrl: task['image'],
                                //   fit: BoxFit.fill,
                                // )
                                : Icon(Icons.image)
                                ,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            // Text(
                            //   strDate.split(' ')[1],
                            //   style: TextStyle(fontSize: 12.0),
                            // ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return List<PopupMenuEntry<String>>()
                              // ..add(PopupMenuItem<String>(
                              //   value: 'edit',
                              //   child: Text('Edit'),
                              // ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Hapus'),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // title: Text('Are You Sure'),
                                    content: Text('Apakah yakin akan menghapus ${task['name']}?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('TIDAK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('HAPUS'),
                                        onPressed: () {
                                          document.reference.delete();
                                          Navigator.pop(context);
                                          // setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('carts')
                // .where('orderId', isEqualTo: orderId)
                .where('userId', isEqualTo: uid)
                .orderBy('orderDate')
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Divider(),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(bottom: 10, top: 5, left: kDefaultPaddin, right: kDefaultPaddin),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 0),
                                  child: dynamicText("Total Rp", color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: kDefaultPaddin),
                                  child: dynamicText("0", color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: defaultButton(
                                      context, 
                                      "pesan sekarang",
                                      onPress: () {

                                      }
                                    )
                                    
                                    // FlatButton(
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(8)),
                                    //   color: Colors.pink,
                                    //   onPressed: () {
                                    //     try {
                                    //       // defaultAlert(context, () async {
                                    //       //   Navigator.pop(context);
                                    //       //   await FlutterOpenWhatsapp.sendSingleMessage(
                                    //       //     adminNumber, 
                                    //       //     '''$order\n----------------------------------\nTOTAL ${f.format(grandTotal)}'''  
                                    //       //   );
                                    //       // });
                                    //       // _showSnackBarMessage("Data barang belanjamu masih kosong");
                                    //       print('123');
                                    //     } catch (e) {
                                    //       print(e.toString());
                                    //     }
                                    //   },
                                    //   child: Text(
                                    //     "Pesan Sekarang".toUpperCase(),
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                  // return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.data.documents.length <= 0) {
                  // return maintenancePage("", "Data barang belanjamu masih kosong");
                  grandTotal = 0;
                } else {
                  grandTotal = 0;
                  arrPesanan = [];
                  for(var dt in snapshot.data.documents) {
                    var nama = dt.data['name']; 
                    var jumlah = dt.data['qty'].toString(); 
                    var harga = dt.data['price']; 
                    subTotal = (dt.data['qty'] * dt.data['price']); 
                    grandTotal += (dt.data['qty'] * dt.data['price']); 
                    order += nama + " | " + jumlah + " | " + f.format(harga) + " = " + f.format(subTotal) + "\n";
                    // print(order);
                    var obj = [{
                      'product': nama,
                      'qty': dt.data['qty'],
                      'total': (dt.data['qty'] * dt.data['price']),
                    }];
                    arrPesanan.addAll(obj);

                  }
                  print(arrPesanan);
                }
                
                return Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      offset: Offset(0, -2.0),
                      blurRadius: 6.0,
                    )
                  ]),
                  child: Column(
                  children: <Widget>[
                    // Divider(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(bottom: 10, top: 10, left: kDefaultPaddin, right: kDefaultPaddin),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: kDefaultPaddin),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    dynamicText("Total", color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 14),
                                    dynamicText("Rp${f.format(grandTotal)}", color: Colors.pink, fontWeight: FontWeight.w600, fontSize: 22),
                                  ],
                                ),
                              ),
                              
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: defaultButton(
                                    context, 
                                    "pesan sekarang",
                                    onPress: () async {
                                      if (snapshot.data.documents.length <= 0) {
                                        _showSnackBarMessage("Barang belanjamu masih kosong");
                                      } else {
                                        defaultAlert(context, () async {
                                          CollectionReference orderan = firestore.collection('orders');
                                          DocumentReference result = await orderan.add(<String, dynamic>{
                                            'date': DateTime.now(),
                                            'userId': uid,
                                            'status': 'menunggu proses',
                                            'location': {
                                              'lat': '',
                                              'long': ''
                                            },
                                            'service': {
                                              'type': 'barang',
                                              'detail': arrPesanan
                                            },
                                          });
                                          if (result.documentID != null) {
                                            try {
                                              var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                              Navigator.pop(context);
                                              await FlutterOpenWhatsapp.sendSingleMessage(
                                                nomorAdmin, 
                                                '''$order\n----------------------------------\nTOTAL ${f.format(grandTotal)}'''  
                                              );
                                            } catch (e) {
                                              _showSnackBarMessage(e.toString());
                                            }
                                          }
                                        });
                                      }
                                    }
                                  ),
                                  // FlatButton(
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(8)),
                                  //   color: Colors.pink,
                                  //   onPressed: () async {
                                  //     try {
                                  //       // await FlutterOpenWhatsapp.sendSingleMessage(
                                  //       //   adminNumber, 
                                  //       //   '''$order\n----------------------------------\nTOTAL ${f.format(grandTotal)}'''  
                                  //       // );
                                  //       if (snapshot.data.documents.length <= 0) {
                                  //         _showSnackBarMessage("Data barang belanjamu masih kosong");
                                  //       } else {
                                  //         defaultAlert(context, () async {
                                  //           Navigator.pop(context);
                                  //           await FlutterOpenWhatsapp.sendSingleMessage(
                                  //             adminNumber, 
                                  //             '''$order\n----------------------------------\nTOTAL ${f.format(grandTotal)}'''  
                                  //           );
                                  //         });
                                  //       }
                                  //       // print(order + "\n----------------------------------\nTOTAL " + f.format(grandTotal));
                                  //     } catch (e) {
                                  //       print(e.toString());
                                  //     }
                                  //   },
                                  //   child: Text(
                                  //     "Pesan Sekarang".toUpperCase(),
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
              ),
                );
              }
            
          ),
        ],
      ),
    );
  }

  buildAppBar() {
    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            offset: Offset(0, 2.0),
            blurRadius: 6.0,
          )
        ]),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/back.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: dynamicText("Keranjang Belanja", fontWeight: FontWeight.w600),
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight),
    );
  }

}