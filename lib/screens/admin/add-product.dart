import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toko_romi/utils/widget-background.dart';
import 'package:toko_romi/utils/widget-color.dart';
import 'package:toko_romi/utils/widget-model.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String category;
  final String image;
  final bool isPublish;
  final int price;
  final String unit;

  AddProductScreen({
    @required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.category = '',
    this.image = '',
    this.isPublish = true,
    this.price = 0,
    this.unit = '',
  });

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerImage = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  
  final List<String> categories = ['Sembako', 'Makanan & Minuman'];

  double widthScreen;
  double heightScreen;
  DateTime date = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;
  String currentCat = "";
  String initCat = "";
  String currentUnit = "";
  String initUnit = "";
  File imageFile;
  final picker = ImagePicker();
  String fileName;
  String imgStr = "";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      // _image = File(pickedFile.path);
      imageFile = File(pickedFile.path);
      fileName = basename(imageFile.path);
      controllerImage.text = fileName;
    });
  }

  // Future _getImage() async {
  //   var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     imageFile = selectedImage;
  //     fileName = basename(imageFile.path);
  //     controllerImage.text = fileName;
  //   });
  // }

  Future<String> uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    var downURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downURL.toString();
    print(url);
    return url;
  }

  @override
  void initState() {
    if (widget.isEdit) {
      // date = DateFormat('dd MMMM yyyy').parse(widget.date);
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
      initCat = widget.category;
      initUnit = widget.unit;
      currentCat = widget.category;
      currentUnit = widget.unit;
      controllerImage.text = widget.image;
      controllerPrice.text = widget.price.toString();
      
      // controllerIsPublish.text = widget.isPublish;
      // controllerUnit.text = widget.unit;
    } else {
      // initCat = "";
      // controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      // backgroundColor: appColor.colorPrimary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildWidgetFormPrimary(context),
                  _buildWidgetFormSecondary(),
                  _buildWidgetCategory(),
                  _buildWidgetUnit(),
                  _uploadArea(),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(appColor.colorTertiary),
                            ),
                          ),
                        )
                      : _buildWidgetButtonCreateTask(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: controllerImage,
            enabled: (widget.isEdit) ? false : true,
            decoration: InputDecoration(
              labelText: 'Gambar',
              labelStyle: TextStyle(fontSize: 16),
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: getImage,
                    // onTap: () {},
                    // child: (imageFile == null) ? Icon(Icons.camera_alt) : null,
                    child: Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
            style: TextStyle(fontSize: 18.0),
          ),
          (widget.isEdit) ?
            ((widget.image) != "") ?
              CachedNetworkImage(
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                imageUrl: widget.image,
                width: 50,
                fit: BoxFit.fill,
              ) : dynamicText("Tidak ada gambar", fontSize: 12)
          : (imageFile != null) ? Image.file(imageFile, width: 50,) : dynamicText("Tidak ada gambar", fontSize: 12) 
        ],
      ),
    );
  }

  Widget _buildWidgetFormPrimary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.isEdit ? 'Edit Barang' : 'Buat Barang Baru',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Nama Barang',
              labelStyle: TextStyle(fontSize: 16),
            ),
            style: TextStyle(fontSize: 18.0),
          ),
          TextField(
            controller: controllerDescription,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              labelStyle: TextStyle(fontSize: 16),
            ),
            style: TextStyle(fontSize: 18.0),
          ),
          // SizedBox(height: 16.0),
          
          TextField(
            keyboardType: TextInputType.number,
            controller: controllerPrice,
            decoration: InputDecoration(
              labelText: 'Harga',
              labelStyle: TextStyle(fontSize: 16),
            ),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          DropdownButtonFormField(
            hint: dynamicText("Pilih kategori barang"),
            value: (widget.isEdit) ? initCat : null,
            items: categories.map((String x) {
              return DropdownMenuItem<String>(
                value: x,
                child: Text("$x")
              );
            }).toList(), 
            onChanged: (newCat) {
              setState(() {
                currentCat = newCat;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetUnit() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              hint: dynamicText("Pilih satuan barang"),
              value: (widget.isEdit) ? initUnit : null,
              items: ['pcs', 'kg', 'liter', 'dus', 'ons', 'renteng'].map((String x) {
                return DropdownMenuItem<String>(
                  value: x,
                  child: Text("${x.toUpperCase()}")
                );
              }).toList(), 
              onChanged: (newUnit) {
                setState(() {
                  currentUnit = newUnit;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButtonCreateTask(context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: RaisedButton(
        color: appColor.colorTertiary,
        child: Text(widget.isEdit ? 'UPDATE' : 'SIMPAN'),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () async {
          // uploadImage();
          String name = controllerName.text;
          String description = controllerDescription.text;
          String image = controllerImage.text;
          String price = controllerPrice.text;
          // String category = currentCat;
          String unit = currentUnit;
          if (name.isEmpty) {
            _showSnackBarMessage('Nama barang harus diisi');
            return;
          } else if (price.isEmpty) {
            _showSnackBarMessage('Harga barang harus diisi');
            return;
          } else if (currentCat.isEmpty) {
            _showSnackBarMessage('Pilih kategori barang yang tersedia');
            return;
          } else if (currentUnit.isEmpty) {
            _showSnackBarMessage('Pilih satuan barang yang tersedia');
            return;
          }
          setState(() => isLoading = true);
          if (widget.isEdit) {
            DocumentReference documentTask = firestore.document('products/${widget.documentId}');
            firestore.runTransaction((transaction) async {
              DocumentSnapshot dt = await transaction.get(documentTask);
              if (dt.exists) {
                await transaction.update(
                  documentTask,
                  <String, dynamic>{
                    'category': currentCat,
                    'name': name,
                    'description': description,
                    'image': image,
                    'is_publish': true,
                    'price': int.parse(price),
                    'unit': unit,
                  },
                );
                Navigator.pop(context, true);
              }
            });
          } else {
            // print(currentCat);
            if (imageFile != null) {
              imgStr = await uploadImage();
            }
            
            CollectionReference product = firestore.collection('products');
            DocumentReference result = await product.add(<String, dynamic>{
              'category': currentCat,
              'name': name,
              'description': description,
              'image': imgStr,
              'is_publish': true,
              'price': int.parse(price),
              'unit': unit,
            });
            if (result.documentID != null) {
              Navigator.pop(context, true);
            }
          }
        },
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}