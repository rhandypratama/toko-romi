import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore firestore = Firestore.instance;

class Orderan {
  Future<DocumentReference> saveOrderanJasa(String uid, String product) async {
    CollectionReference orderan = firestore.collection('orders');
    DocumentReference result = await orderan.add(<String, dynamic>{
      'date': DateTime.now(),
      'userId': uid,
      'status': 'menunggu proses',
      'location': {
        'lat': '',
        'long': ''
      },
      'service': {
        'type': 'jasa',
        'detail': [
          {
            'product': product,
            'qty': 1,
            'total': 0 
          }
        ]
      },
    });
    return result;
  }

}