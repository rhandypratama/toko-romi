import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_romi/screens/home/components/carousel-text.dart';
// import 'package:toko_romi/screens/home/components/carousel.dart';
import 'package:toko_romi/screens/home/components/categories.dart';
import 'package:toko_romi/screens/home/components/makanan-baru.dart';
import 'package:toko_romi/screens/home/components/sembako-baru.dart';
import 'package:toko_romi/utils/widget-model.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Firestore firestore = Firestore.instance;
  final f = NumberFormat('#,##0', 'id_ID');
  // String asd;

  // getPromo() async {
  //   var c = await getPreferences("promos", kType: "String");
  //   // if (!mounted) {
  //   setState(() {
  //     asd = c; 
  //   });
  //   print('asdasdasdasd $asd');
  //   // }
  // }

  // Future<List> getPromo() async {
  //   DocumentSnapshot querySnapshot = await Firestore.instance
  //     .collection('settings')
  //     .document('v95naiHwl0OSEdNwSYOk')
  //     .get();
  //   // if (querySnapshot.exists &&
  //   //     querySnapshot.data.containsKey('favorites') &&
  //   //     querySnapshot.data['favorites'] is List) {
  //   //   // Create a new List<String> from List<dynamic>
  //   // }
  //   if (querySnapshot.exists) {
  //     return List<String>.from(querySnapshot.data['promo']);
  //     // print("=== DATA SETTING MASIH KOSONG ===");
  //   } else {
  //     print("=== DATA PROMO KOSONG ===");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getPromo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 14, right: 14, bottom: 0, top: 10),
            //   child: Text(
            //     "Agen Romi",
            //     style: Theme.of(context)
            //         .textTheme
            //         .headline5
            //         .copyWith(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 0, top: 0),
              child: Row(
                children: <Widget>[
                  dynamicText("Super Promo", fontWeight: FontWeight.w600),
                  SizedBox(width: 5,),
                  Icon(Icons.stars, size: 18, color: Colors.amber,)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 0),
              child: CarouselText()
            ),
            Categories(),
            SembakoBaru(),
            MakananBaru(),
            // Expanded(
            //   child: Padding(
            //     // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //     padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
            //     child: StreamBuilder<QuerySnapshot>(
            //       stream: firestore.collection('products').orderBy('name').snapshots(),
            //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //         if (!snapshot.hasData) {
            //           return Center(child: CircularProgressIndicator());
            //         }
                  
            //         return GridView.builder(
            //           // itemCount: products.length,
            //           itemCount: snapshot.data.documents.length,
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 2,
            //             mainAxisSpacing: 12,
            //             crossAxisSpacing: 12,
            //             // childAspectRatio: 0.75,
            //             childAspectRatio: 0.8,
            //           ),
            //           // itemBuilder: (context, index) => ItemCard(
            //           //       product: products[index],
            //           //       press: () => Navigator.push(
            //           //           context,
            //           //           MaterialPageRoute(
            //           //             builder: (context) => DetailsScreen(
            //           //               product: products[index],
            //           //             ),
            //           //           )),
            //           // )
            //           itemBuilder: (BuildContext context, int index) {
            //             DocumentSnapshot document = snapshot.data.documents[index];
            //             Map<String, dynamic> task = document.data;
            //             // print(document.documentID);

            //             return InkWell(
            //               onTap: () {
            //                 navigationManager(
            //                   context,
            //                   DetailScreen(
            //                     documentId: document.documentID ?? "",
            //                     category: task['category'] ?? "",
            //                     name: task['name'] ?? "",
            //                     description: task['description'] ?? "",
            //                     price: task['price'] ?? 0,
            //                     unit: task['unit'] ?? "",
            //                     image: task['image'],
            //                     isPublish: task['is_publish'] ?? true,
            //                   ),
            //                 );
            //               },
            //               child: Container(
            //                   // width: MediaQuery.of(context).size.width / 1.2,
            //                   width: MediaQuery.of(context).size.width,
            //                   margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: 4),
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(8.0),
            //                       boxShadow: [
            //                         BoxShadow(
            //                             color: Colors.black12,
            //                             blurRadius: 3.0)
            //                       ]),
            //                   child: Stack(
            //                     alignment: Alignment.topCenter,
            //                     children: <Widget>[
            //                       Container(
            //                         child: Stack(
            //                           children: <Widget>[
            //                             ClipRRect(
            //                               borderRadius: BorderRadius.only(
            //                                 topLeft: Radius.circular(8.0),
            //                                 topRight: Radius.circular(8.0),
            //                                 bottomRight: Radius.circular(8.0),
            //                                 bottomLeft: Radius.circular(8.0),
            //                               ),
            //                               child: CachedNetworkImage(
            //                                 placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            //                                 imageUrl: (task['image'] == "") ? defaultImage : task['image'],
            //                                 fit: BoxFit.fill,
            //                               ),
                                            
            //                               // Image(
            //                               //   height: MediaQuery.of(context).size.height / 2.2,
            //                               //   // width: MediaQuery.of(context).size.width / 1.2,
            //                               //   width: MediaQuery.of(context).size.width,
            //                               //   image: AssetImage(img),
            //                               //   fit: BoxFit.cover,
            //                               // ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Positioned(
            //                         left: 0.0,
            //                         bottom: 0.0,
            //                         child: Container(
            //                           height: 50,
            //                           // width: MediaQuery.of(context).size.width / 1.1,
            //                           width: MediaQuery.of(context).size.width,
            //                           padding: EdgeInsets.symmetric(horizontal: 14),
            //                           decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.only(
            //                               bottomRight: Radius.circular(8.0),
            //                               bottomLeft: Radius.circular(8.0),
            //                             ),
            //                             color: Colors.white
            //                           ),
            //                           child: Column(
            //                             crossAxisAlignment: CrossAxisAlignment.start,
            //                             // mainAxisAlignment: MainAxisAlignment.start,
            //                             children: <Widget>[
            //                               Container(
            //                                 width: MediaQuery.of(context).size.width / 2.5,
            //                                 margin: const EdgeInsets.only(top: 10),
            //                                 child: dynamicText(task['name'],
            //                                   fontSize: 12.0,
            //                                   // fontWeight: FontWeight.bold,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   // maxLines: 2
            //                                 ),
            //                               ),
            //                               Padding(
            //                                 padding: const EdgeInsets.only(top: 0, bottom: 0),
            //                                 child: Row(
            //                                   children: <Widget>[
            //                                     dynamicText("Rp", fontSize: 12, color: Colors.pink),
            //                                     dynamicText("${f.format(task['price'])}", fontSize: 14, color: Colors.pink, fontWeight: FontWeight.bold),
            //                                     // SizedBox(width: 4),
            //                                     // dynamicText("Rp", fontSize: 12, color: Colors.black45),
            //                                     // dynamicText("${task['price']}", fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
            //                                   ],
            //                                 )
                                            
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   )),
            //             );


            //             // Size size = MediaQuery.of(context).size;
            //             // return Container(
            //             //   margin: EdgeInsets.only(
            //             //     // left: kDefaultPaddin,
            //             //     top: kDefaultPaddin / 2,
            //             //     // bottom: kDefaultPaddin * 2.5,
            //             //   ),
            //             //   width: size.width * 0.4,
            //             //   child: Column(
            //             //     children: <Widget>[
            //             //       Container(
            //             //         decoration: BoxDecoration(
            //             //           color: Colors.black,
            //             //           borderRadius: BorderRadius.only(
            //             //             topLeft: Radius.circular(10),
            //             //             topRight: Radius.circular(10),
            //             //           ),
                                  
            //             //           boxShadow: [
            //             //             BoxShadow(
            //             //               offset: Offset(0, 1),
            //             //               color: kPrimaryColor.withOpacity(0.23),
            //             //             ),
            //             //           ],
            //             //         ),
            //             //         child: CachedNetworkImage(
            //             //           placeholder: (context, url) => CircularProgressIndicator(),
            //             //           imageUrl: task['image'],
            //             //           fit: BoxFit.fill,
            //             //         ),
            //             //       ),
            //             //       GestureDetector(
            //             //         onTap: (){},
            //             //         child: Container(
            //             //           padding: EdgeInsets.all(kDefaultPaddin / 2),
            //             //           decoration: BoxDecoration(
            //             //             color: Colors.white,
            //             //             borderRadius: BorderRadius.only(
            //             //               bottomLeft: Radius.circular(10),
            //             //               bottomRight: Radius.circular(10),
            //             //             ),
            //             //             boxShadow: [
            //             //               BoxShadow(
            //             //                 // offset: Offset(0, 1),
            //             //                 blurRadius: 2,
            //             //                 // color: kPrimaryColor.withOpacity(0.23),
            //             //               ),
            //             //             ],
            //             //           ),
            //             //           child: Row(
            //             //             children: <Widget>[
            //             //               RichText(
            //             //                 text: TextSpan(
            //             //                   children: [
            //             //                     // TextSpan(
            //             //                     //     text: "$task['name']\n".toUpperCase(),
            //             //                     //     style: Theme.of(context).textTheme.button),
            //             //                     // TextSpan(
            //             //                     //   text: "$task['description']".toUpperCase(),
            //             //                     //   style: TextStyle(
            //             //                     //     color: kPrimaryColor.withOpacity(0.5),
            //             //                     //   ),
            //             //                     // ),
            //             //                   ],
            //             //                 ),
            //             //               ),
            //             //               // Spacer(),
            //             //               // Text(
            //             //               //   "\$$task['price']",
            //             //               //   style: Theme.of(context)
            //             //               //       .textTheme
            //             //               //       .button
            //             //               //       .copyWith(color: kPrimaryColor),
            //             //               // )
            //             //             ],
            //             //           ),
            //             //         ),
            //             //       )
            //             //     ],
            //             //   ),
            //             // );


            //             // return GestureDetector(
            //             //   onTap: (){},
            //             //   child: Card(
            //             //     child: Column(
            //             //       crossAxisAlignment: CrossAxisAlignment.start,
            //             //       children: <Widget>[
            //             //         Expanded(
            //             //           child: Container(
            //             //             padding: EdgeInsets.all(kDefaultPaddin),
            //             //             decoration: BoxDecoration(
            //             //               color: Colors.white,
            //             //               borderRadius: BorderRadius.circular(8),
            //             //             ),
            //             //             child: Hero(
            //             //               tag: "${task['name']}",
            //             //               child: CachedNetworkImage(
            //             //                 placeholder: (context, url) => CircularProgressIndicator(),
            //             //                 imageUrl: task['image'],
            //             //               ),
            //             //             ),
            //             //           ),
            //             //         ),
            //             //         Padding(
            //             //           padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            //             //           child: Text(
            //             //             task['name'],
            //             //             style: TextStyle(color: kTextLightColor),
            //             //           ),
            //             //         ),
            //             //         Text(
            //             //           "\$${task['price']}",
            //             //           style: TextStyle(fontWeight: FontWeight.bold),
            //             //         )
            //             //       ],
            //             //     ),
            //             //   ),
            //             // );
            //           }


            //         );


            //       }

            //   ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}