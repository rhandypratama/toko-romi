import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toko_romi/screens/details/detail-screen.dart';
import 'package:toko_romi/screens/sembako/sembako-screen.dart';
import 'package:toko_romi/utils/widget-model.dart';

class SembakoBaru extends StatefulWidget {
  @override
  SembakoBaruState createState() => SembakoBaruState();
}

class SembakoBaruState extends State<SembakoBaru> {
  final Firestore firestore = Firestore.instance;
  final f = NumberFormat('#,##0', 'id_ID');
   
  // Future<String> getSettings() async {
  //   DocumentSnapshot querySnapshot = await Firestore.instance
  //     .collection('settings')
  //     .document('v95naiHwl0OSEdNwSYOk')
  //     .get();
  //   // if (querySnapshot.exists &&
  //   //     querySnapshot.data.containsKey('favorites') &&
  //   //     querySnapshot.data['favorites'] is List) {
  //   //   // Create a new List<String> from List<dynamic>
  //   //   return List<String>.from(querySnapshot.data['favorites']);
  //   // }
  //   if (querySnapshot.exists) {
  //     await savePreferences('username',stringValue: querySnapshot.data['username']);
  //     await savePreferences('password',stringValue: querySnapshot.data['password']);
  //     await savePreferences('admin-utama',stringValue: querySnapshot.data['adminUtama']);
  //     await savePreferences('admin-test',stringValue: querySnapshot.data['adminTest']);
  //     await savePreferences('admin-makanan',stringValue: querySnapshot.data['adminMakanan']);
  //     print("data setting berhasil disimpan");
  //   } else {
  //     print("data setting masih kosong");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 300,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dynamicText("Paling laris dari sembako", fontWeight: FontWeight.bold),
                GestureDetector(
                  onTap: () {
                    navigationManager(context, SembakoScreen(), isPushReplaced: false);
                  },
                  child: dynamicText("Lihat Semua", color: Colors.yellow[900], fontSize: 14),
                ),

              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3.2,
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('products')
                .where("category", isEqualTo: "Sembako")
                .orderBy('name')
                .limit(4)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int i) {
                    var documentId = snapshot.data.documents[i].data['documentId'];
                    var name = snapshot.data.documents[i].data['name'];
                    var category = snapshot.data.documents[i].data['category'];
                    var description = snapshot.data.documents[i].data['description'];
                    var image = snapshot.data.documents[i].data['image'];
                    var isPublish = snapshot.data.documents[i].data['is_publish'];
                    var price = snapshot.data.documents[i].data['price'];
                    var unit = snapshot.data.documents[i].data['unit'];
                    return _tipsCard(
                      "$documentId",
                      "$name",
                      "$category",
                      "$description",
                      "$image",
                      isPublish,
                      price,
                      "$unit",
                    );
                  }
                );
              }  
            ),
          ),

        ],
      ),
    );
  }

  Widget _tipsCard(
    String ducumentId, 
    String name,
    String category, 
    String description, 
    String image,
    bool isPublish,
    int price,
    String unit) {
    return InkWell(
      onTap: () {
        navigationManager(
          context,
          DetailScreen(
            documentId: ducumentId ?? "",
            category: category ?? "",
            name: name ?? "",
            description: description ?? "",
            price: price ?? 0,
            unit: unit ?? "",
            image: image,
            isPublish: isPublish ?? true,
          ),
        );
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.only(left: 0.0, right: 10.0, bottom: 14.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0)
            ]
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        imageUrl: image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4.0,
                right: 4.0,
                child: Container(
                  child: Image.asset('assets/images/sale1.png', width: 30,)
                    
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dynamicText(name,
                          fontSize: 14.0,
                          // fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2
                        ),
                        Row(
                          children: <Widget>[
                            dynamicText("Rp", fontSize: 12, color: Colors.pink),
                            dynamicText("${f.format(price)}", fontSize: 16, color: Colors.pink, fontWeight: FontWeight.bold),
                            
                          ],
                        )
                      ],
                    ),
                    
                  ),
                ),
              ),
            ],
          )),
    );
  }

}