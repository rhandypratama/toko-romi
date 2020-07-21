import 'package:flutter/material.dart';
import 'package:toko_romi/screens/listrik/listrik-screen.dart';
import 'package:toko_romi/screens/makanan/makanan-screen.dart';
import 'package:toko_romi/screens/pulsa/pulsa-screen.dart';
import 'package:toko_romi/screens/sembako/sembako-screen.dart';
import 'package:toko_romi/screens/tarik/tarik-screen.dart';
import 'package:toko_romi/screens/transfer/transfer-screen.dart';
import 'package:toko_romi/utils/constant.dart';
import 'package:toko_romi/utils/widget-model.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["Makanan & Minuman", "Pulsa & Paket Data", "Listrik PLN"];
  // By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          // color: kKuning,
          // color: kKuning,
          // border: Border.all(color: kKuning, width: 1.5),
          // borderRadius: BorderRadius.circular(10),
        ),
        // margin: EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Align(
          alignment: AlignmentDirectional.topCenter,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  mainMenu(
                    "assets/images/wheat.png",
                    "Sembako",
                    () {
                      navigationManager(context, SembakoScreen(), isPushReplaced: false);
                    }
                  ),
                  mainMenu(
                    "assets/images/fork.png",
                    "Makanan",
                    () {
                      navigationManager(context, MakananScreen(), isPushReplaced: false);
                    }
                  ),
                  mainMenu(
                    "assets/images/packs/wifi-connection.png",
                    "Pulsa & Data",
                    () {
                      navigationManager(context, PulsaScreen(), isPushReplaced: false);
                    }
                  ),
                  mainMenu(
                    "assets/images/packs/lamp.png",
                    "Listrik PLN",
                    () {
                      navigationManager(context, ListrikScreen(), isPushReplaced: false);
                    }
                  ),
                ],
              ),
              SizedBox(height: 14,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  mainMenu(
                    "assets/images/doctor.png",
                    "BPJS",
                    () {}
                  ),
                  mainMenu(
                    "assets/images/money.png",
                    "Transfer",
                    () {
                      navigationManager(context, TransferScreen(), isPushReplaced: false);
                    }
                  ),
                  mainMenu(
                    "assets/images/packs/withdraw2.png",
                    "Tarik Tunai",
                    () {
                      navigationManager(context, TarikScreen(), isPushReplaced: false);
                    }
                  ),
                  mainMenu(
                    "assets/images/more.png",
                    "Lainnya",
                    () {
                      _showModalSheet();
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 20,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget mainMenu(String imgpath, String title, Function press) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: press,
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.grey[100], width: 1.5),
                border: Border.all(color: kKuning, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                imgpath, height: 100,
                // 'assets/images/logo.png',
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          dynamicText(title, fontSize: 10, color: Colors.black)
        ],
      ),
    );
  }

  void _showModalSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
          child: Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          padding: EdgeInsets.only(
              top: 6,
              left: 18,
              right: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                dynamicText("Kategori Lainnya",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.left),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    mainMenu(
                      "assets/images/motorbike.png",
                      "Angs Motor",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/authority.png",
                      "Pajak STNK",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/truck.png",
                      "Kirim Barang",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/business-and-finance.png",
                      "BNI Online",
                      () {
                        
                      }
                    ),
                    
                  ],
                ),
                
                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    mainMenu(
                      "assets/images/credit-card-payment.png",
                      "Top Up",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/repair.png",
                      "Bengkel Motor",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/car-rental.png",
                      "Travel & Rental",
                      () {
                        
                      }
                    ),
                    mainMenu(
                      "assets/images/electric-service.png",
                      "Service Elektro",
                      () {
                        
                      }
                    ),
                    
                  ],
                ),
                
                SizedBox(height: 30.0),
                
              ],
            ),
          ),
        ));
      });
  }
}