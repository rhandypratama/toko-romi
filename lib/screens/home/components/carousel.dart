import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toko_romi/utils/widget-model.dart';

class Carousel extends StatelessWidget {
  final List sliderItems = [
    'assets/images/slider/sakti.jpg',
    'assets/images/step-two.png',
    'assets/images/step-three.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 120,
            child: Swiper(
              itemCount: sliderItems.length,
              autoplay: true,
              curve: Curves.easeInOutBack,
              // pagination: SwiperPagination(),
              // control: SwiperControl(),
              
              itemBuilder: (BuildContext context, int i) {
                return Image.asset(sliderItems[i], fit: BoxFit.cover);
              },
            ),
          ),
          // Container(
          //   height: 100,
          //   color: Colors.black.withOpacity(0.5),
          // ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.3),
              child: dynamicText("Awali harimu dengan #DiRumahAja", color: Colors.white, fontSize: 12),
            ), 
            
          ),
        ],
      ),
    );
  }
}
