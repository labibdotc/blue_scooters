import 'package:bluescooters/db/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripInfo {
  //can throw
  static Future<void> uploadStartInfoToFirebase(String trip_id, String before_pic, DateTime startTime, int cents_price) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> data = createTripSchema();
      data['trip_id'] = trip_id;
      data['before_pic_url'] = before_pic;
      data['start_time'] = startTime;
      data['end_time'] = startTime;
      data['cents_price'] = cents_price;
      print(data);
      // Assuming you have a 'collectionName' collection
      await firestore.collection('trips').doc(trip_id).set(data);
      print("uploaded trip info to trips");

  }
  //can throw
  static Future<void>  uploadEndInfoToFirebase(String trip_id, String  after_pic, DateTime endTime, int cents_price, int rounded_up_mins_duration) async {


    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = updateTripSchema();
    data['after_pic_url'] = after_pic;
    data['end_time'] = endTime;
    data['cents_price'] = cents_price;
    data['rounded_up_mins_duration'] = rounded_up_mins_duration;
    // Assuming you have a 'collectionName' collection
    firestore.collection('trips').doc(trip_id).update(data);

  }

}