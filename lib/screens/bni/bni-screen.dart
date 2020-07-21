import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_romi/screens/bni/components/buka-rekening.dart';
import 'package:toko_romi/screens/bni/components/setor-tunai.dart';
import 'package:toko_romi/screens/listrik/components/tagihan-listrik.dart';
import 'package:toko_romi/screens/listrik/components/token-listrik.dart';
import 'package:toko_romi/utils/widget-model.dart';

class BniScreen extends StatefulWidget {
  @override
  _BniScreenState createState() => _BniScreenState();
}

class _BniScreenState extends State<BniScreen> {
  final _tabPage = <Widget>[
    BukaRekening(),
    SetorTunai(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: dynamicText("BNI Laku Pandai", color: Colors.black),
            leading: IconButton(
              icon: SvgPicture.asset("assets/icons/back.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.grey),
              labelStyle: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: Colors.yellow
              ),
              tabs: [
                Tab(
                  child: Container(
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: dynamicText("Buka Rekening")
                        )
                      ]
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: dynamicText("Setor Tunai")
                        )
                      ]
                    ),
                  ),
                ),
                           
              ]
            ),
          ),
          
          body: TabBarView(children: _tabPage)
          // body: TokenListrik()
          // body: TagihanListrik()
          // body: SettingScreen()

        ),
      ),
    );
  }

  
}