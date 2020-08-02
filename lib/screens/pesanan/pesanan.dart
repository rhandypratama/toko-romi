import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/utils/widget-color.dart';
import 'package:toko_romi/utils/widget-model.dart';

class PesananScreen extends StatefulWidget {
  @override
  _PesananScreenState createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final AppColor appColor = AppColor();
  var f = NumberFormat('#,##0', 'id_ID');

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    final user = Provider.of<User>(context);
    var userId = (user != null) ? user?.uid : '';

    return Scaffold(
      key: scaffoldState,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context, userId),
          ],
        ),
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
          title: dynamicText("Riwayat Pesananmu", fontWeight: FontWeight.w600),
        ),
      ),
      preferredSize: Size.fromHeight(kToolbarHeight),
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
              stream: firestore.collection('orders').where('userId', isEqualTo: uid).orderBy('date', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data.documents.length <= 0) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.documents.length <= 0) {
                  return maintenancePage("", "Riwayat pesananmu kosong");
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
                      // return new Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: strings.map((item) => new Text(item)).toList()
                      // );

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
                                      dynamicText("${task['status']}", fontSize: 12, color: Colors.pink),
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
                          // leading: Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       width: 50.0,
                          //       height: 50.0,
                          //       decoration: BoxDecoration(
                          //         // color: appColor.colorSecondary,
                          //         color: Colors.grey.shade100,
                          //         shape: BoxShape.circle,
                          //       ),
                          //       child: Center(
                          //         child: task['image'] != "" ? CachedNetworkImage(
                          //           placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          //           imageUrl: task['image'],
                          //           fit: BoxFit.fill,
                          //         )
                          //         : Icon(Icons.image)
                          //         ,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // trailing: PopupMenuButton(
                          //   itemBuilder: (BuildContext context) {
                          //     return List<PopupMenuEntry<String>>()
                          //       ..add(PopupMenuItem<String>(
                          //         value: 'edit',
                          //         child: Text('Edit'),
                          //       ))
                          //       ..add(PopupMenuItem<String>(
                          //         value: 'delete',
                          //         child: Text('Hapus'),
                          //       ));
                          //   },
                          //   onSelected: (String value) async {
                          //     if (value == 'edit') {
                          //       bool result = await Navigator.push(
                          //         context,
                          //         MaterialPageRoute(builder: (context) {
                          //           return AddProductScreen(
                          //             isEdit: true,
                          //             documentId: document.documentID,
                          //             name: task['name'],
                          //             description: task['description'],
                          //             category: task['category'],
                          //             image: task['image'],
                          //             isPublish: task['is_publish'],
                          //             price: task['price'],
                          //             unit: task['unit'],
                          //           );
                          //         }),
                          //       );
                          //       if (result != null && result) {
                          //         scaffoldState.currentState.showSnackBar(SnackBar(
                          //           content: Text('Barang berhasil diupdate'),
                          //         ));
                          //         setState(() {});
                          //       }
                          //     } else if (value == 'delete') {

                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             // title: Text('Are You Sure'),
                          //             content: Text('Apakah yakin akan menghapus ${task['name']}?'),
                          //             actions: <Widget>[
                          //               FlatButton(
                          //                 child: Text('TIDAK'),
                          //                 onPressed: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //               ),
                          //               FlatButton(
                          //                 child: Text('HAPUS'),
                          //                 onPressed: () async {
                          //                   if (task['image'] != "") {
                          //                     StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(task['image']);
                          //                     print('hapus gambar ${storageReference.path}');
                          //                     await storageReference.delete();
                          //                   }
                          //                   document.reference.delete();
                          //                   Navigator.pop(context);
                          //                   setState(() {});
                          //                 },
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     }
                          //   },
                          //   child: Icon(Icons.more_vert),
                          // ),
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