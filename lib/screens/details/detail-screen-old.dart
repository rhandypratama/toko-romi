import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toko_romi/screens/details/components/body.dart';
import 'package:toko_romi/utils/constant.dart';

class DetailsScreen extends StatelessWidget {
  final String documentId;
  final String category;
  final String name;
  final String description;
  final int price;
  final String image;
  final bool isPublish;

  const DetailsScreen({
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
    return Scaffold(
      // each product have a color
      backgroundColor: Color(0xFF3D82AE),
      appBar: buildAppBar(context),
      body: Body(
        documentId: documentId,
        category: category,
        name: name,
        description: description,
        price: price,
        image: image,
        isPublish: isPublish,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF3D82AE),
      // backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}