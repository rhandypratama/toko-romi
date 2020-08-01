import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_romi/models/user.dart';
import 'package:toko_romi/screens/cart/cart.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class DetailScreen extends StatefulWidget {
  final String documentId;
  final String category;
  final String name;
  final String description;
  final int price;
  final String unit;
  final String image;
  final bool isPublish;

  const DetailScreen({
    Key key, 
    this.documentId,
    this.category,
    this.name,
    this.description,
    this.price,
    this.unit,
    this.image,
    this.isPublish
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int numOfItems = 1;
  double jumlah = 1;
  var f = NumberFormat('#,##0', 'id_ID');
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  
  @override
  void initState() {
    super.initState();
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: widget.documentId,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      imageUrl: (widget.image == "") ? defaultImage : widget.image,
                      fit: BoxFit.fill,
                    ),
                    // Image.asset(
                    //   image,
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                ),
                Container(
                  // height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.yellow[700],
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      dynamicText(widget.category, color: Colors.black, fontSize: 14),
                      SizedBox(height: 4),
                      dynamicText(widget.name, color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          dynamicText("Rp", color: Colors.black, fontSize: 14),
                          SizedBox(width: 4),
                          dynamicText("${f.format(widget.price)}", color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ],
                      )
                      
                    ],
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              dynamicText("Jumlah : ", 
                                color: Colors.black, 
                                fontSize: 16, 
                                // fontWeight: FontWeight.bold
                              ),
                              dynamicText("${jumlah.round()}", color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),

                            ],
                          ),
                          // SizedBox(height: 10),
                          
                          // Row(
                          //   children: <Widget>[
                          //     buildOutlineButton(
                          //       icon: Icons.remove,
                          //       press: () {
                          //         if (numOfItems > 1) {
                          //           setState(() {
                          //             numOfItems--;
                          //           });
                          //         }
                          //       },
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                          //       child: Text(
                          //         // if our item is less  then 10 then  it shows 01 02 like that
                          //         numOfItems.toString().padLeft(2, "0"),
                          //         style: Theme.of(context).textTheme.headline6,
                          //       ),
                          //     ),
                          //     buildOutlineButton(
                          //         icon: Icons.add,
                          //         press: () {
                          //           setState(() {
                          //             numOfItems++;
                          //           });
                          //         }),
                          //   ],
                          // )
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          dynamicText("Satuan : ", 
                            color: Colors.black, 
                            fontSize: 16, 
                            // fontWeight: FontWeight.bold
                          ),
                          dynamicText("${widget.unit.toUpperCase()}", color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ],
                      ),
                      
                      
                    ],
                  ),
                ),
                Slider(
                  value: jumlah.toDouble(), 
                  min: 1,
                  max: 100,
                  onChanged: (newJumlah) {
                    setState(() {
                      jumlah = newJumlah;
                    });
                  }
                ),
                
              ],
            ),
          ),

          Column(
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
                          margin: EdgeInsets.only(right: kDefaultPaddin),
                          height: 50,
                          width: 58,
                          decoration: BoxDecoration(
                            color: kKuning,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.yellow[800],
                            ),
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              "assets/icons/add_to_cart.svg",
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              // var orderId = await getPreferences('orderId', kType: "string");
                              // print('pref ${orderId}');
                              // print(userId); return false;

                              CollectionReference carts = firestore.collection('carts');
                              DocumentReference result = await carts.add(<String, dynamic>{
                                'userId': userId,
                                'orderDate': DateTime.now(),
                                'name': widget.name,
                                'qty': jumlah.toInt(),
                                'price': widget.price.toInt(),
                                'image': widget.image,
                              });

                              if (result.documentID != null) {
                                // Navigator.pop(context, true);
                                _showSnackBarMessage("Berhasil ditambahkan ke keranjang belanjamu");
                              } else {
                                _showSnackBarMessage("An error occured! Document ID is null");
                              }
                              
                            },
                          ),
                        ),
                        Expanded(
                          child: defaultButton(
                            context, 
                            "pesan sekarang",
                            onPress: () {
                              try {
                                defaultAlert(context, () async {
                                  Navigator.pop(context);
                                  var subTotal = jumlah.toInt() * widget.price.toInt();
                                  var nomorAdmin = await getPreferences('admin-utama', kType: 'string');
                                  
                                  CollectionReference product = firestore.collection('orders');
                                  DocumentReference result = await product.add(<String, dynamic>{
                                    'date': DateTime.now(),
                                    'userId': userId,
                                    'status': 'menunggu proses',
                                    'location': {
                                      'lat': '',
                                      'long': ''
                                    },
                                    'service': {
                                      'type': 'barang',
                                      'detail': [
                                        {
                                          'product': widget.name,
                                          'qty': jumlah.round(),
                                          'total': subTotal 
                                        }
                                      ]
                                    },
                                  });
                                  if (result.documentID != null) {
                                    try {
                                      await FlutterOpenWhatsapp.sendSingleMessage(
                                        nomorAdmin, 
                                        '${widget.name} | ${jumlah.round().toString()} | ${f.format(widget.price)} = ${f.format(subTotal)}'
                                      );
                                    } catch (e) {
                                      _showSnackBarMessage(e.toString());
                                    }
                                  }
                                  
                                });
                                
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          ),
                          
                          // SizedBox(
                          //   height: 50,
                          //   child: FlatButton(
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8)),
                          //     color: Colors.pink,
                          //     onPressed: () {
                          //       try {
                          //         defaultAlert(context, () async {
                          //           Navigator.pop(context);
                          //           var subTotal = jumlah.toInt() * widget.price.toInt();
                          //           await FlutterOpenWhatsapp.sendSingleMessage(
                          //             adminNumber, 
                          //             '${widget.name} | ${jumlah.round().toString()} | ${f.format(widget.price)} = ${f.format(subTotal)}'
                          //           );
                          //         });
                                  
                          //       } catch (e) {
                          //         print(e.toString());
                          //       }
                          //     },
                          //     child: Text(
                          //       "Pesan Sekarang".toUpperCase(),
                          //       style: TextStyle(
                          //         fontSize: 17,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Color(0xFF3D82AE),
      // backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: true,

      leading: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )
        ),
        // backgroundColor: Colors.white.withOpacity(0.5),
        child: IconButton(
          padding: EdgeInsets.all(0.0),
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        // IconButton(
        //   icon: SvgPicture.asset("assets/icons/search.svg", color: Colors.black,),
        //   onPressed: () {},
        // ),
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )
          ),
          child: IconButton(
            icon: SvgPicture.asset("assets/icons/shop.svg"),
            onPressed: () {
              navigationManager(context, CartScreen(), isPushReplaced: false);
            },
            // color: Colors.black,
          ),
        ),
        // SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
  
}