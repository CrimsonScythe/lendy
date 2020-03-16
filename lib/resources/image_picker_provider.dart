import 'dart:io';

import 'package:image_picker/image_picker.dart';

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