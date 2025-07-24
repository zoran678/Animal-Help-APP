import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CloudinaryServices {
  static Future<String?> uploadImageToCloudinary(
      Uint8List imageFile, String filename) async {
    const cloudName = 'dhwaakhlb';
    const uploadPreset = 'ResQnow';

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageFile,
        filename: filename,
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStream = await response.stream.bytesToString();
      final responseData = json.decode(resStream);
      return responseData['secure_url'];
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  }
}
