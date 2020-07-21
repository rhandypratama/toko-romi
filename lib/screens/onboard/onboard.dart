import 'package:flutter/material.dart';
import 'package:toko_romi/utils/splash.dart';
import 'package:toko_romi/utils/widget-model.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  static Color primary = Color.fromRGBO(52, 43, 37, 1);
  static Color gray = Color.fromRGBO(137, 137, 137, 1);
  static Color secoundry = Color.fromRGBO(198, 116, 27, 1);
  static Color secoundryLight = Color.fromRGBO(226, 185, 141, 1);

  PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await savePreferences('onboard', boolValue: true);
              navigationManager(context, SplashScreen(), isPushReplaced: true);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: Text('Lewati', style: TextStyle(
                color: gray,
                fontSize: 16,
                fontWeight: FontWeight.w400
              ),),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                image: 'assets/images/step-one.png',
                title: "Lebih mudah dan aman",
                content: "Belanja kebutuhan sehari - hari jauh lebih mudah dan aman, sesuai protokol covid-19"
              ),
              makePage(
                reverse: true,
                image: 'assets/images/step-two.png',
                title: "Harga bersaing",
                content: "Semua harga yang tertera bisa kalian bandingkan dengan toko sebelah"
              ),
              makePage(
                image: 'assets/images/step-three.png',
                title: "Transaksi aman dan terpercaya",
                content: "Semua transaksi yang dilakukan di jamin aman karena menggunakan sistem COD, jadi kalian tidak perlu kawatir lagi"
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse ? 
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(image),
              ),
              SizedBox(height: 30,),
            ],
          ) : SizedBox(),
          Text(title, textAlign: TextAlign.center, style: TextStyle(
            color: primary,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 20,),
          Text(content, textAlign: TextAlign.center, style: TextStyle(
            color: gray,
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),),
          reverse ? 
          Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(image),
              ),
            ],
          ) : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: secoundry,
        borderRadius: BorderRadius.circular(5)
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i<3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }

}

