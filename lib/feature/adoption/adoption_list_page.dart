import 'package:animal_app/feature/adoption/pet_adoption_form.dart';
import 'package:animal_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionListPage extends StatelessWidget {
  const AdoptionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Find Your Perfect Pet',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF74BCEA).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            navigateTo(context, const PetAdoptionForm());
          },
          backgroundColor: const Color(0xFF74BCEA),
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Add Pet',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('adoptions')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF74BCEA)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pets available yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to add a pet for adoption!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          final pets = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index].data() as Map<String, dynamic>;
              return _buildPetCard(context, pet);
            },
          );
        },
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, dynamic> pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showPetDetails(context, pet),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: pet['imageUrl'] != null &&
                            pet['imageUrl'].toString().isNotEmpty
                        ? Image.network(
                            pet['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(),
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
                const SizedBox(width: 16),

                // Pet Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pet['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          _buildGenderIcon(pet['gender']),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet['breed'] ?? 'Mixed'} • ${pet['age'] ?? 'Unknown age'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pet['location'] ?? 'Location not specified',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildQuickTags(pet),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF74BCEA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.pets,
        size: 32,
        color: Color(0xFF74BCEA),
      ),
    );
  }

  Widget _buildGenderIcon(String? gender) {
    if (gender == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            gender.toLowerCase() == 'male' ? Colors.blue[50] : Colors.pink[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        gender,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: gender.toLowerCase() == 'male'
              ? Colors.blue[700]
              : Colors.pink[700],
        ),
      ),
    );
  }

  Widget _buildQuickTags(Map<String, dynamic> pet) {
    List<Widget> tags = [];

    if (pet['isVaccinated'] == true) {
      tags.add(_buildTag('Vaccinated', Colors.green));
    }
    if (pet['isNeutered'] == true) {
      tags.add(_buildTag('Neutered', Colors.blue));
    }
    if (pet['isGoodWithKids'] == true) {
      tags.add(_buildTag('Kid-friendly', Colors.orange));
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags.take(3).toList(), // Show max 3 tags
    );
  }

  Widget _buildTag(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color[700],
        ),
      ),
    );
  }

  void _showPetDetails(BuildContext context, Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet Image
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[100],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: pet['imageUrl'] != null &&
                                    pet['imageUrl'].toString().isNotEmpty
                                ? Image.network(
                                    pet['imageUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildPlaceholderImage(),
                                  )
                                : _buildPlaceholderImage(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pet Name and Basic Info
                      Center(
                        child: Text(
                          pet['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          '${pet['petType'] ?? 'Pet'} • ${pet['breed'] ?? 'Mixed breed'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Info Cards
                      Row(
                        children: [
                          Expanded(
                              child: _buildInfoCard(
                                  'Age', pet['age'] ?? 'Unknown')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildInfoCard(
                                  'Size', pet['size'] ?? 'Unknown')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildInfoCard(
                                  'Gender', pet['gender'] ?? 'Unknown')),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Location
                      _buildDetailSection(
                        'Location',
                        pet['location'] ?? 'Not specified',
                        Icons.location_on_outlined,
                      ),

                      const SizedBox(height: 20),

                      // Description
                      if (pet['description'] != null &&
                          pet['description'].toString().isNotEmpty)
                        _buildDetailSection(
                          'About ${pet['name'] ?? 'this pet'}',
                          pet['description'],
                          Icons.info_outline,
                        ),

                      const SizedBox(height: 20),

                      // Health & Behavior Tags
                      _buildTagsSection(pet),

                      const SizedBox(height: 24),

                      // Contact Information
                      _buildContactSection(pet),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF74BCEA).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF74BCEA)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(Map<String, dynamic> pet) {
    List<Widget> tags = [];

    if (pet['isVaccinated'] == true) {
      tags.add(
          _buildDetailTag('Vaccinated', Icons.verified_user, Colors.green));
    }
    if (pet['isNeutered'] == true) {
      tags.add(_buildDetailTag(
          'Neutered/Spayed', Icons.local_hospital, Colors.blue));
    }
    if (pet['isHouseTrained'] == true) {
      tags.add(_buildDetailTag('House Trained', Icons.home, Colors.purple));
    }
    if (pet['isGoodWithKids'] == true) {
      tags.add(
          _buildDetailTag('Good with Kids', Icons.child_care, Colors.orange));
    }
    if (pet['isGoodWithPets'] == true) {
      tags.add(_buildDetailTag('Good with Pets', Icons.pets, Colors.teal));
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health & Behavior',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags,
        ),
      ],
    );
  }

  Widget _buildDetailTag(String label, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(Map<String, dynamic> pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (pet['contact'] != null &&
              pet['contact'].toString().isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  pet['contact'],
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            if (pet['email'] != null && pet['email'].toString().isNotEmpty)
              const SizedBox(height: 8),
          ],
          if (pet['email'] != null && pet['email'].toString().isNotEmpty)
            Row(
              children: [
                Icon(Icons.email_outlined, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pet['email'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
