import 'package:flutter/material.dart';
import 'package:toko_romi/utils/constant.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({
    Key key,
    @required this.description,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}