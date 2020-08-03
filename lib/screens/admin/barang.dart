import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toko_romi/screens/admin/add-product.dart';
import 'package:toko_romi/utils/widget-color.dart';
import 'package:toko_romi/utils/widget-model.dart';

class BarangScreen extends StatefulWidget {
  @override
  _BarangScreenState createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final AppColor appColor = AppColor();
  var f = NumberFormat('#,##0', 'id_ID');

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      // backgroundColor: appColor.colorPrimary,
      // appBar: buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(isEdit: false)));
          if (result != null && result) {
            scaffoldState.currentState.showSnackBar(SnackBar(
              content: Text('Barang berhasil dibuat'),
            ));
            setState(() {});
          }
        },
        backgroundColor: appColor.colorTertiary,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: dynamicText("Daftar Barang", color: Colors.black),
    );
  }

  Container _buildWidgetListTodo(double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('products').orderBy('name').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    Map<String, dynamic> task = document.data;
                    
                    return Card(
                      elevation: 1,
                      child: ListTile(
                        
                        title: Text(task['name']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dynamicText("Harga : ", fontSize: 12),
                                dynamicText(
                                  "${f.format(task['price'])} ( ${task['unit'].toString().toUpperCase()} )",
                                  fontSize: 12
                                ),
                              ],
                            ),
                          ],
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
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: task['image'] != "" ? 
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    imageUrl: task['image'],
                                    fit: BoxFit.fill,
                                    width: 60,
                                  )
                                )
                                : Icon(Icons.image)
                                ,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return List<PopupMenuEntry<String>>()
                              ..add(PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Hapus'),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return AddProductScreen(
                                    isEdit: true,
                                    documentId: document.documentID,
                                    name: task['name'],
                                    description: task['description'],
                                    category: task['category'],
                                    image: task['image'],
                                    isPublish: task['is_publish'],
                                    price: task['price'],
                                    unit: task['unit'],
                                  );
                                }),
                              );
                              if (result != null && result) {
                                scaffoldState.currentState.showSnackBar(SnackBar(
                                  content: Text('Barang berhasil diupdate'),
                                ));
                                setState(() {});
                              }
                            } else if (value == 'delete') {

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
                                        onPressed: () async {
                                          if (task['image'] != "") {
                                            StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(task['image']);
                                            print('hapus gambar ${storageReference.path}');
                                            await storageReference.delete();
                                          }
                                          document.reference.delete();
                                          Navigator.pop(context);
                                          setState(() {});
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
        ],
      ),
    );
  }
}