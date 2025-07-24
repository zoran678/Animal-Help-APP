import 'dart:typed_data';

import 'package:animal_app/services/cloudinary_services.dart';
import 'package:animal_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetAdoptionForm extends StatefulWidget {
  const PetAdoptionForm({super.key});

  @override
  _PetAdoptionFormState createState() => _PetAdoptionFormState();
}

class _PetAdoptionFormState extends State<PetAdoptionForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocationServices>().fetchCurrentLocation();
    });
  }

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Form variables
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  String _selectedPetType = 'Dog';
  String _selectedGender = 'Male';
  String _selectedSize = 'Medium';
  bool _isVaccinated = false;
  bool _isNeutered = false;
  bool _isHouseTrained = false;
  bool _isGoodWithKids = false;
  bool _isGoodWithPets = false;

  final List<String> _petTypes = [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Fish',
    'Other'
  ];
  final List<String> _genders = ['Male', 'Female'];
  final List<String> _sizes = ['Small', 'Medium', 'Large'];

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        _selectedImage = image;
                        _selectedImageBytes = await image.readAsBytes();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        _selectedImage = image;
                        _selectedImageBytes = await image.readAsBytes();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool loading = false;
  changeloading() {
    if (mounted) {
      setState(() {
        loading = !loading;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      changeloading();
      final imageUrl = await CloudinaryServices.uploadImageToCloudinary(
          _selectedImageBytes!, _selectedImage!.name);
      if (imageUrl == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image upload failed'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      try {
        await FirebaseFirestore.instance.collection('adoptions').add({
          'name': _nameController.text.trim(),
          'petType': _selectedPetType,
          'age': _ageController.text.trim(),
          'breed': _breedController.text.trim(),
          'gender': _selectedGender,
          'size': _selectedSize,
          'location': _locationController.text.trim(),
          'contact': _contactController.text.trim(),
          'email': _emailController.text.trim(),
          'description': _descriptionController.text.trim(),
          'isVaccinated': _isVaccinated,
          'isNeutered': _isNeutered,
          'isHouseTrained': _isHouseTrained,
          'isGoodWithKids': _isGoodWithKids,
          'isGoodWithPets': _isGoodWithPets,
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet listing submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: [31m$e[0m'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        changeloading();
      }
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image of your pet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pet Adoption Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _selectedImageBytes == null
                    ? InkWell(
                        onTap: _pickImage,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Pet Photo',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _selectedImageBytes!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: InkWell(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),

              // Basic Information Section
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _nameController,
                label: 'Pet Name',
                icon: Icons.pets,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter pet name' : null,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Pet Type',
                      value: _selectedPetType,
                      items: _petTypes,
                      onChanged: (value) =>
                          setState(() => _selectedPetType = value!),
                      icon: Icons.category,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _ageController,
                      label: 'Age (months)',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter age' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _breedController,
                label: 'Breed',
                icon: Icons.info_outline,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter breed' : null,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Gender',
                      value: _selectedGender,
                      items: _genders,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value!),
                      icon: Icons.wc,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Size',
                      value: _selectedSize,
                      items: _sizes,
                      onChanged: (value) =>
                          setState(() => _selectedSize = value!),
                      icon: Icons.straighten,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Location & Contact Section
              _buildSectionTitle('Location & Contact'),
              const SizedBox(height: 16),

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: const Color(0xFF74BCEA).withOpacity(0.1),
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

              const SizedBox(height: 16),

              _buildTextField(
                controller: _contactController,
                label: 'Contact Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter contact number'
                    : null,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value!)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Health & Behavior Section
              _buildSectionTitle('Health & Behavior'),
              const SizedBox(height: 16),

              _buildCheckboxTile('Vaccinated', _isVaccinated,
                  (value) => setState(() => _isVaccinated = value!)),
              _buildCheckboxTile('Neutered/Spayed', _isNeutered,
                  (value) => setState(() => _isNeutered = value!)),
              _buildCheckboxTile('House Trained', _isHouseTrained,
                  (value) => setState(() => _isHouseTrained = value!)),
              _buildCheckboxTile('Good with Kids', _isGoodWithKids,
                  (value) => setState(() => _isGoodWithKids = value!)),
              _buildCheckboxTile('Good with Other Pets', _isGoodWithPets,
                  (value) => setState(() => _isGoodWithPets = value!)),

              const SizedBox(height: 24),

              // Description Section
              _buildSectionTitle('Description'),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Tell us about your pet...',
                    prefixIcon:
                        Icon(Icons.description, color: Colors.blue[700]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter description'
                      : null,
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text(
                          'Submit Adoption Listing',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, void Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: CheckboxListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[700],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
