import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/widget-color.dart';
import 'package:toko_romi/utils/widget-model.dart';

class DaftarPesananScreen extends StatefulWidget {
  @override
  _DaftarPesananScreenState createState() => _DaftarPesananScreenState();
}

class _DaftarPesananScreenState extends State<DaftarPesananScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final AppColor appColor = AppColor();
  var f = NumberFormat('#,##0', 'id_ID');

  void showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
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
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildWidgetListTodo(widthScreen, heightScreen, context, userId),
          ],
        ),
      ),
      
    );
  }

  Container _buildWidgetListTodo(double widthScreen, double heightScreen, BuildContext context, String uid) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // stream: firestore.collection('orders').where('userId', isEqualTo: uid).orderBy('date', descending: true).snapshots(),
              stream: firestore.collection('orders').orderBy('date', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.documents.length <= 0) {
                  return maintenancePage("", "Tidak ada data pemesanan");
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    Map<String, dynamic> task = document.data;

                    var dateNew = DateTime.parse(task['date'].toDate().toString());
                    final DateFormat formatter = DateFormat('dd/MM/yyyy | hh:mm');
                    final formatted = formatter.format(dateNew);

                    dynamic getTextWidgets(List<String> strings) {
                      List<Widget> list = new List<Widget>();
                      for(var io = 0; io < task['service']['detail'].length; io++){
                          list.add(dynamicText("${task['service']['detail'][io]['product']} | qty : ${task['service']['detail'][io]['qty']} | Total : ${f.format(task['service']['detail'][io]['total'])}", fontSize: 12, color: Colors.white));
                      }
                      return new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: list
                      );
                    }
                    
                    return Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 10),
                        child: ListTile(
                          
                          title: dynamicText('#${snapshot.data.documents[index].documentID}', fontWeight: FontWeight.w600, fontSize: 12),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Column(
                              children: <Widget>[
                                // Row(
                                //   children: <Widget>[
                                //     dynamicText("Jenis : ", fontSize: 12),
                                //     dynamicText("${task['service']['type'].toString().toUpperCase()}", fontSize: 12),
                                //   ],
                                // ),
                                Row(
                                  children: <Widget>[
                                    dynamicText("Tanggal Order : ", fontSize: 12),
                                    dynamicText("$formatted", fontSize: 12),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      dynamicText("Status : ", fontSize: 12),
                                      (task['status'] == 'menunggu proses') ?
                                        dynamicText("${task['status'].toString().toUpperCase()}", fontSize: 12, color: Colors.pink, fontWeight: FontWeight.w600)
                                      :
                                        dynamicText("${task['status'].toString().toUpperCase()}", fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.w600)
                                    ],
                                  ),
                                ),
                                (task['service']['type'] == 'jasa') ?
                                  Container(
                                    width: widthScreen,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: dynamicText("${task['service']['detail'][0]['product']}", fontSize: 12, color: Colors.white),
                                  )
                                :
                                  Container(
                                    width: widthScreen,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[800],
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: getTextWidgets([]),
                                  )
                                
                                
                                // Row(
                                //   children: <Widget>[
                                //     dynamicText("Satuan : ", fontSize: 14),
                                //     dynamicText("${task['unit'].toString().toUpperCase()}", fontSize: 14),
                                //   ],
                                // ),
                                
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return List<PopupMenuEntry<String>>()
                                ..add(PopupMenuItem<String>(
                                  value: 'menunggu',
                                  child: Text('Status : Menunggu'),
                                ))
                                ..add(PopupMenuItem<String>(
                                  value: 'selesai',
                                  child: Text('Status : Selesai'),
                                ))
                                ..add(PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ));
                            },
                            onSelected: (String value) async {
                              if (value == 'menunggu') {
                                DocumentReference documentTask = firestore.document('orders/${document.documentID}');
                                firestore.runTransaction((transaction) async {
                                  DocumentSnapshot dt = await transaction.get(documentTask);
                                  if (dt.exists) {
                                    await transaction.update(
                                      documentTask,
                                      <String, dynamic>{
                                        'status': 'menunggu proses'
                                      },
                                    );
                                    showSnackBarMessage("Status pesanan berhasil diedit");
                                    // Navigator.pop(context, true);
                                  }
                                });
                              } else if (value == 'selesai') {
                                DocumentReference documentTask = firestore.document('orders/${document.documentID}');
                                firestore.runTransaction((transaction) async {
                                  DocumentSnapshot dt = await transaction.get(documentTask);
                                  if (dt.exists) {
                                    await transaction.update(
                                      documentTask,
                                      <String, dynamic>{
                                        'status': 'selesai'
                                      },
                                    );
                                    showSnackBarMessage("Status pesanan berhasil diedit");
                                    // Navigator.pop(context, true);
                                  }
                                });
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('Apakah yakin akan menghapus pesanan ini ?'),
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
                                            document.reference.delete().then((value) {
                                              Navigator.pop(context);
                                              showSnackBarMessage("Pesanan berhasil dihapus");
                                            });
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}