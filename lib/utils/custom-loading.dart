import 'package:flutter/material.dart';
import 'package:toko_romi/home.dart';
import 'package:toko_romi/utils/widget-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading {
  void startLoading() {}
  void finishLoading(isSuccess, {message}) {}
}

class MyDialog {
  final BuildContext context;
  String title;
  String content;

  MyDialog(this.context, {title, content});

  void loading() {
    boxDialog(
      context,
      true,
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100.0))
          ),
          padding: EdgeInsets.all(20.0),
          child: new CircularProgressIndicator(
            backgroundColor: Colors.teal,
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.white
            )
          )
        )
      )
    );
  }

  void pop() {
    Navigator.of(context).pop();
  }

  void error(message, {title}) {
    boxDialog(
        context,
        true,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.greenAccent,
                    size: 70,
                  ),
                ),
                SizedBox(height: 10),
                dynamicText(
                  message, 
                  fontSize: 14, 
                  textAlign: TextAlign.center, 
                  // fontWeight: FontWeight.bold
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  void success(message, {title, bool noButton = false, Function btnPressed, isOneButton}) {
    // defaultAlertDialog(context, title, message, isSuccess: true, isOneButton: isOneButton, btnText: "OK", onPressedOK: btnPressed);
    boxDialog(
        context,
        true,
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.greenAccent,
                    size: 70,
                  ),
                ),
                dynamicText(
                  title,
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center
                ),
                SizedBox(height: 10),
                dynamicText(
                  message, 
                  fontSize: 14,
                  color: Colors.grey,
                  textAlign: TextAlign.center
                ),
                SizedBox(height: 10),
                noButton == false ? defaultButton(context, "OK", onPress: btnPressed == null ? () {
                  Navigator.pop(context);
                } : btnPressed) : Container()
              ],
            ),
          ),
        ));
  }

  void sessionEnd() {
    boxDialog(
        context,
        false,
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.greenAccent,
                    size: 120,
                  ),
                ),
                dynamicText("Session token kamu telah berakhir", fontSize: 18, fontWeight: FontWeight.bold, textAlign: TextAlign.center),
                SizedBox(height: 10),
                dynamicText("Silahkan login ulang untuk melanjutkan", fontSize: 14, textAlign: TextAlign.center,color: Colors.grey),
                SizedBox(height: 10),
                defaultButton(context, "OK", onPress: () async {
                  Navigator.pop(context);
                  var ref = await SharedPreferences.getInstance();
                  ref.clear();
                  navigationManager(context, HomeScreen(),
                      isPushReplaced: true);
                })
              ],
            ),
          ),
        ));
  }

  Future<void> boxDialog(
      BuildContext context, bool isDismissable, Widget childWidget) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isDismissable,
      builder: (BuildContext context) {
        return childWidget;
      },
    );
  }
}
