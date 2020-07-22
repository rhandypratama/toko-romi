import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toko_romi/screens/auth/login-screen.dart';
import 'package:toko_romi/screens/cart/cart.dart';
import 'package:toko_romi/screens/details/detail-screen.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toko_romi/utils/widget-model.dart';

class SembakoScreen extends StatefulWidget {
  @override
  _SembakoScreenState createState() => _SembakoScreenState();
}

class _SembakoScreenState extends State<SembakoScreen> {
  final Firestore firestore = Firestore.instance;
  final f = NumberFormat('#,##0', 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 0),
              child: dynamicText("Barang Sembako", fontWeight: FontWeight.bold)
            ),
        
            Expanded(
              child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('products')
                    .where("category", isEqualTo: "Sembako")
                    .orderBy('name')
                    .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                  
                    return GridView.builder(
                      // itemCount: products.length,
                      itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        // childAspectRatio: 0.75,
                        childAspectRatio: 0.8,
                      ),
                      // itemBuilder: (context, index) => ItemCard(
                      //       product: products[index],
                      //       press: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => DetailsScreen(
                      //               product: products[index],
                      //             ),
                      //           )),
                      // )
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data.documents[index];
                        Map<String, dynamic> task = document.data;
                        // print(document.documentID);

                        return InkWell(
                          onTap: () {
                            navigationManager(
                              context,
                              DetailScreen(
                                documentId: document.documentID ?? "",
                                category: task['category'] ?? "",
                                name: task['name'] ?? "",
                                description: task['description'] ?? "",
                                price: task['price'] ?? 0,
                                unit: task['unit'] ?? "",
                                image: task['image'],
                                isPublish: task['is_publish'] ?? true,
                              ),
                            );
                          },
                          child: Container(
                              // width: MediaQuery.of(context).size.width / 1.2,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3.0)
                                  ]),
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
                                            imageUrl: (task['image'] == "") ? defaultImage : task['image'],
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                            fit: BoxFit.cover,
                                          ),
                                            
                                          // Image(
                                          //   height: MediaQuery.of(context).size.height / 2.2,
                                          //   // width: MediaQuery.of(context).size.width / 1.2,
                                          //   width: MediaQuery.of(context).size.width,
                                          //   image: AssetImage(img),
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 0.0,
                                    bottom: 0.0,
                                    child: Container(
                                      height: 50,
                                      // width: MediaQuery.of(context).size.width / 1.1,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                        ),
                                        color: Colors.white
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width / 2.5,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: dynamicText(task['name'],
                                              fontSize: 12.0,
                                              // fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              // maxLines: 2
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                                            child: Row(
                                              children: <Widget>[
                                                dynamicText("Rp", fontSize: 12, color: Colors.pink),
                                                dynamicText("${f.format(task['price'])}", fontSize: 14, color: Colors.pink, fontWeight: FontWeight.bold),
                                                // SizedBox(width: 4),
                                                // dynamicText("Rp", fontSize: 12, color: Colors.black45),
                                                // dynamicText("${task['price']}", fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
                                              ],
                                            )
                                            
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );


                        // Size size = MediaQuery.of(context).size;
                        // return Container(
                        //   margin: EdgeInsets.only(
                        //     // left: kDefaultPaddin,
                        //     top: kDefaultPaddin / 2,
                        //     // bottom: kDefaultPaddin * 2.5,
                        //   ),
                        //   width: size.width * 0.4,
                        //   child: Column(
                        //     children: <Widget>[
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           color: Colors.black,
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10),
                        //             topRight: Radius.circular(10),
                        //           ),
                                  
                        //           boxShadow: [
                        //             BoxShadow(
                        //               offset: Offset(0, 1),
                        //               color: kPrimaryColor.withOpacity(0.23),
                        //             ),
                        //           ],
                        //         ),
                        //         child: CachedNetworkImage(
                        //           placeholder: (context, url) => CircularProgressIndicator(),
                        //           imageUrl: task['image'],
                        //           fit: BoxFit.fill,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: (){},
                        //         child: Container(
                        //           padding: EdgeInsets.all(kDefaultPaddin / 2),
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.only(
                        //               bottomLeft: Radius.circular(10),
                        //               bottomRight: Radius.circular(10),
                        //             ),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 // offset: Offset(0, 1),
                        //                 blurRadius: 2,
                        //                 // color: kPrimaryColor.withOpacity(0.23),
                        //               ),
                        //             ],
                        //           ),
                        //           child: Row(
                        //             children: <Widget>[
                        //               RichText(
                        //                 text: TextSpan(
                        //                   children: [
                        //                     // TextSpan(
                        //                     //     text: "$task['name']\n".toUpperCase(),
                        //                     //     style: Theme.of(context).textTheme.button),
                        //                     // TextSpan(
                        //                     //   text: "$task['description']".toUpperCase(),
                        //                     //   style: TextStyle(
                        //                     //     color: kPrimaryColor.withOpacity(0.5),
                        //                     //   ),
                        //                     // ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               // Spacer(),
                        //               // Text(
                        //               //   "\$$task['price']",
                        //               //   style: Theme.of(context)
                        //               //       .textTheme
                        //               //       .button
                        //               //       .copyWith(color: kPrimaryColor),
                        //               // )
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // );


                        // return GestureDetector(
                        //   onTap: (){},
                        //   child: Card(
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: <Widget>[
                        //         Expanded(
                        //           child: Container(
                        //             padding: EdgeInsets.all(kDefaultPaddin),
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(8),
                        //             ),
                        //             child: Hero(
                        //               tag: "${task['name']}",
                        //               child: CachedNetworkImage(
                        //                 placeholder: (context, url) => CircularProgressIndicator(),
                        //                 imageUrl: task['image'],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
                        //           child: Text(
                        //             task['name'],
                        //             style: TextStyle(color: kTextLightColor),
                        //           ),
                        //         ),
                        //         Text(
                        //           "\$${task['price']}",
                        //           style: TextStyle(fontWeight: FontWeight.bold),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // );
                      }


                    );


                  }

                ),
              ),
            ),
          ],
        ),
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
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/password.svg",
            color: kTextColor,
          ),
          onPressed: () {
            navigationManager(context, LoginScreen(), isPushReplaced: false);
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            color: kTextColor,
          ),
          onPressed: () {
            navigationManager(context, CartScreen(), isPushReplaced: false);
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
  
}