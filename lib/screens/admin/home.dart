import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_romi/screens/admin/barang.dart';
import 'package:toko_romi/screens/admin/list-pesanan.dart';
import 'package:toko_romi/utils/widget-model.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _tabPage = <Widget>[
    BarangScreen(),
    DaftarPesananScreen(),
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
            title: dynamicText("Admin Panel", fontWeight: FontWeight.w600),
            leading: IconButton(
              icon: SvgPicture.asset("assets/icons/back.svg"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.grey),
              labelStyle: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              
              // indicator: BoxDecoration(
              //   borderRadius: BorderRadius.circular(80),
              //   color: Colors.yellow
              // ),
              tabs: [
                Tab(
                  child: Container(
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: dynamicText("Daftar Barang")
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
                          child: dynamicText("Pesanan")
                        )
                      ]
                    ),
                  ),
                ),
                           
              ]
            ),
          ),
          
          body: TabBarView(children: _tabPage)
          // body: DaftarPesananScreen()
          
        ),
      ),
    );
  }
}