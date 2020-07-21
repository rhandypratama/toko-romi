import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toko_romi/models/product.dart';
import 'package:toko_romi/utils/constant.dart';

class ProductTitleWithImage extends StatelessWidget {
  final String documentId;
  final String category;
  final String name;
  final int price;
  final String image;
  
  const ProductTitleWithImage({
    Key key,
    this.documentId,
    this.category,
    this.name,
    this.price,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Harga\n"),
                    TextSpan(text: "Rp"),
                    TextSpan(
                      text: "${price}",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 80),
              Expanded(
                child: Hero(
                  
                  tag: documentId,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    imageUrl: image,
                    fit: BoxFit.fill,
                  ),
                  // Image.asset(
                  //   image,
                  //   fit: BoxFit.fill,
                  // ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}