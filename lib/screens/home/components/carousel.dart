import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toko_romi/utils/widget-model.dart';

final List<String> sliderItems = [
  'assets/images/slider/sakti.jpg',
  'assets/images/step-two.png',
  'assets/images/step-three.png',
];

class Carousel extends StatelessWidget {
  
  final List<Widget> imageSliders = sliderItems.map((item) => Container(
    child: Container(
      // margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: Stack(
          children: <Widget>[
            Image.asset(item, fit: BoxFit.cover, width: 1000,),
            // Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: dynamicText(
                  'No. ${sliderItems.indexOf(item)} image',
                  color: Colors.white,
                  fontSize: 14.0,
                  
                ),
              ),
            ),
          ],
        )
      ),
    ),
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
              ),
              items: imageSliders,
            )
            
            // Swiper(
            //   itemCount: sliderItems.length,
            //   autoplay: true,
            //   curve: Curves.easeInOutBack,
            //   // pagination: SwiperPagination(),
            //   // control: SwiperControl(),
              
            //   itemBuilder: (BuildContext context, int i) {
            //     return Image.asset(sliderItems[i], fit: BoxFit.cover);
            //   },
            // ),
          ),
          // Container(
          //   height: 100,
          //   color: Colors.black.withOpacity(0.5),
          // ),
          // Positioned(
          //   bottom: 0,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.black.withOpacity(0.3),
          //     child: dynamicText("Awali harimu dengan #DiRumahAja", color: Colors.white, fontSize: 12),
          //   ), 
            
          // ),
        ],
      ),
    );
  }
}
