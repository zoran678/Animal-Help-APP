import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({super.key});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  XFile? selectedimage;
  Uint8List? selectedimagebytes;

  final descriptionController = TextEditingController();

  Future<String?> uploadImageToCloudinary(
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

  Future Uploaddatatofirestore(String imageUrl) async {
    await FirebaseFirestore.instance.collection("rescue_data").add({
      // 'uid' : FirebaseAuth.instance.currentUser!.uid,
      'image': imageUrl,
      'description': descriptionController.text.trim(),
      'createdAt': Timestamp.now(),
      'geoPoint': GeoPoint(84.65, 76.567)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report Case',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with rounded corners
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) return;
                    selectedimage = image;
                    selectedimagebytes = await image.readAsBytes();
                    setState(() {});
                  },
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          selectedimagebytes != null
                              ? Image.memory(selectedimagebytes!)
                              : Image.asset(
                                  'Assets/images/Upload.jpg',
                                  fit: BoxFit.cover,
                                ),
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF74BCEA),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 12),

                // Description TextFormField with improved styling
                TextFormField(
                  maxLines: 8,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add a description of the case...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF74BCEA),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Location button with improved styling
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Location functionality
                    },
                    icon: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                    ),
                    label: const Text(
                      'Add Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF74BCEA),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Continue button with improved styling
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      var imagebytes = await selectedimage!.readAsBytes();
                      final imageUrl = await uploadImageToCloudinary(
                          imagebytes, selectedimage!.name);

                      await Uploaddatatofirestore(imageUrl!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF74BCEA),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
