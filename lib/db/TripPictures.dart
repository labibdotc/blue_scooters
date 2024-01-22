import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class TripPictures {

  static Future<String> uploadImageToFirebase(String fileName, String folderName) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(folderName);
      UploadTask uploadTask = storageReference.putFile(File(fileName));

      await uploadTask.whenComplete(() => print('Image uploaded to Firebase Storage'));

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }
}