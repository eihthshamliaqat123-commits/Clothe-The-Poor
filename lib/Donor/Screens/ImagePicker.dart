import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<File?> CaptureFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image == null) return null;

    return File(image.path);
  }
}
