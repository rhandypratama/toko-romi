import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_romi/screens/listrik/components/tagihan-listrik.dart';
import 'package:toko_romi/screens/listrik/components/token-listrik.dart';
//import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class ListrikScreen extends StatefulWidget {
  @override
  _ListrikScreenState createState() => _ListrikScreenState();
}

class _ListrikScreenState extends State<ListrikScreen> {
  final _tabPage = <Widget>[
    TokenListrik(),
    TagihanListrik(),
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
            title: dynamicText("Listrik PLN", fontWeight: FontWeight.w600),
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
                          child: dynamicText("Token Listrik")
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
                          child: dynamicText("Tagihan Listrik")
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