import 'package:flutter/material.dart';
import 'package:toko_romi/screens/details/components/add-to-cart.dart';
import 'package:toko_romi/screens/details/components/color-and-size.dart';
import 'package:toko_romi/screens/details/components/counter-with-fav-btn.dart';
import 'package:toko_romi/screens/details/components/product-title-with-image.dart';
import 'package:toko_romi/utils/constant.dart';
import 'description.dart';

class Body extends StatelessWidget {
  final String documentId;
  final String category;
  final String name;
  final String description;
  final int price;
  final String image;
  final bool isPublish;

  const Body({
    Key key, 
    this.documentId,
    this.category,
    this.name,
    this.description,
    this.price,
    this.image,
    this.isPublish
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      // ColorAndSize(
                      //   documentId: documentId,
                      //   name: name,
                      //   description: description,
                      //   price: price,
                      //   image: image,
                      //   isPublish: isPublish,
                      // ),
                      SizedBox(height: kDefaultPaddin / 2),
                      Description(description: description ?? ""),
                      SizedBox(height: kDefaultPaddin / 2),
                      CounterWithFavBtn(),
                      SizedBox(height: kDefaultPaddin / 2),
                      AddToCart()
                    ],
                  ),
                ),
                ProductTitleWithImage(
                  documentId: documentId,
                  category: category ?? "",
                  name: name ?? "",
                  price: price ?? 0,
                  image: image ?? ""
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}