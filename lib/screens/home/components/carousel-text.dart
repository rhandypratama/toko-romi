import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

final List<String> sliderItems = [
  'Dapatkan KUPON UNDIAN disetiap penyaluran bantuan sosial',
  'Kupon akan diundi setiap akhir bulannya',
  'Hadiah akan dibagikan pada saat penyaluran bantuan sosial di Agen Romi',
];

class CarouselText extends StatelessWidget {
  
  final List<Widget> imageSliders = sliderItems.map((item) => Container(
    child: Container(
      // color: Colors.green[100],
      // height: 40,
      child: dynamicText(item, fontSize: 10),
    ) 
    // Container(
    //   // margin: EdgeInsets.all(5.0),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //     child: Stack(
    //       children: <Widget>[
    //         dynamicText(item),
    //         // Image.asset(item, fit: BoxFit.cover, width: 1000,),
    //         // Image.network(item, fit: BoxFit.cover, width: 1000.0),
    //         Positioned(
    //           bottom: 0.0,
    //           left: 0.0,
    //           right: 0.0,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               gradient: LinearGradient(
    //                 colors: [
    //                   Color.fromARGB(200, 0, 0, 0),
    //                   Color.fromARGB(0, 0, 0, 0)
    //                 ],
    //                 begin: Alignment.bottomCenter,
    //                 end: Alignment.topCenter,
    //               ),
    //             ),
    //             padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    //             child: dynamicText(
    //               'No. ${sliderItems.indexOf(item)} image',
    //               color: Colors.black,
    //               fontSize: 14.0,
                  
    //             ),
    //           ),
    //         ),
    //       ],
    //     )
    //   ),
    // ),
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            // decoration: BoxDecoration(
            //   border: Border.all(color: kKuning, width: 1.5),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // color: Colors.green,
            // height: 19,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                // height: 30,
                height: 19,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                // aspectRatio: 2.0,
                // enlargeCenterPage: true,
                scrollDirection: Axis.vertical,
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
