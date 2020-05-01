import 'dart:io';

import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_saver/image_picker_saver.dart';

class ImagePickerProvider {

  Future<File> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<File> takeImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

}