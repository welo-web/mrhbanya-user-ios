import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BankTransferService with ChangeNotifier {
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  Future pickImage(BuildContext context) async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          'png',
          "jpg",
          "jpeg",
          "pdf",
          "webp",
        ]);
    if (pickedFile?.files.firstOrNull != null) {
      pickedImage = File(pickedFile!.files.firstOrNull!.path!);
    }

    notifyListeners();
  }
}
