import 'dart:convert';
import 'dart:typed_data';

import 'package:animal_app/services/location_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReportCaseScreen extends StatefulWidget {
  const ReportCaseScreen({super.key});

  @override
  State<ReportCaseScreen> createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends State<ReportCaseScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocationServices>().fetchCurrentLocation();
    });
  }

  XFile? selectedimage;
  Uint8List? selectedimagebytes;

  bool _loading = false;

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

  Future uploadReportCases(String imageUrl) async {
    final locationServices = context.read<LocationServices>();
    await FirebaseFirestore.instance.collection("cases").add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'image': imageUrl,
      'description': descriptionController.text.trim(),
      'createdAt': Timestamp.now(),
      'geoPoint': GeoPoint(
        locationServices.geoPoint?.latitude ?? 0.0,
        locationServices.geoPoint?.longitude ?? 0.0,
      ),
      'address': locationServices.address ?? 'Unknown location',
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
                // Image upload section
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
                              ? Image.memory(selectedimagebytes!,
                                  fit: BoxFit.cover)
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

                // Location Display Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Consumer<LocationServices>(
                    builder: (context, locationServices, child) {
                      if (locationServices.loading) {
                        return const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF74BCEA),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF74BCEA),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Getting current location...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        );
                      }

                      if (locationServices.address != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF74BCEA),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Current Location',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        locationServices.address!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (locationServices.geoPoint != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF74BCEA).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Lat: ${locationServices.geoPoint!.latitude.toStringAsFixed(6)}, '
                                  'Lng: ${locationServices.geoPoint!.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF74BCEA),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Icon(
                            Icons.location_off,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location unavailable',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                Text(
                                  'Please check location permissions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<LocationServices>()
                                  .fetchCurrentLocation();
                            },
                            child: const Text(
                              'Retry',
                              style: TextStyle(
                                color: Color(0xFF74BCEA),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Description section
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  maxLines: 8,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add a detailed description of the case...',
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

                const SizedBox(height: 36),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedimage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an image'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (descriptionController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please add a description'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        setState(() {
                          _loading = true;
                        });
                        var imagebytes = await selectedimage!.readAsBytes();
                        final imageUrl = await uploadImageToCloudinary(
                            imagebytes, selectedimage!.name);

                        if (imageUrl != null) {
                          await uploadReportCases(imageUrl);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Case reported successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF74BCEA),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Submit Report',
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
