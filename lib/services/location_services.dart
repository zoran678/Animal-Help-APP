import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationServices with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  changeLoadingState(bool state) {
    _loading = state;
    notifyListeners();
  }

  String? _address;
  String? get address => _address;

  GeoPoint? _geoPoint;
  GeoPoint? get geoPoint => _geoPoint;

  Future<void> fetchCurrentLocation() async {
    try {
      changeLoadingState(true);
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          // if (mounted) setState(() => weatherCondition = 'Permission Denied');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lon = position.longitude;

      print('Current Location: $lat, $lon');

      _geoPoint = GeoPoint(lat, lon);
      notifyListeners();

      var add = await getAddressFromCoordinates(lat, lon);
      if (add != null) {
        _address = add;
        notifyListeners();
      } else {
        print('Failed to get address from coordinates');
      }
    } catch (e) {
      print("Error fetching weather: $e");
      changeLoadingState(false);
      return;
    } finally {
      changeLoadingState(false);
    }
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'flutter_web_app'}, // Required by Nominatim
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final address = data['display_name'];
      return address;
    } else {
      print('Failed to reverse geocode: ${response.statusCode}');
      return null;
    }
  }
}
