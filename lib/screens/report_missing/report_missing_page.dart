import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karu/screens/dashboard/dashboard.dart';
import 'package:karu/screens/report_missing/widgets/photo_upload_section.dart';
import 'package:karu/screens/report_missing/widgets/progress_section.dart';
import 'package:karu/screens/report_missing/widgets/last_seen_location.dart';
import 'package:karu/provider/user_alerts.dart';

class ReportMissingPage extends ConsumerStatefulWidget {
  const ReportMissingPage({super.key});

  @override
  ConsumerState<ReportMissingPage> createState() => _ReportMissingPageState();
}

class _ReportMissingPageState extends ConsumerState<ReportMissingPage> {
  String? _imagePath;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _featuresController = TextEditingController();
  double? _lastSeenLatitude;
  double? _lastSeenLongitude;
  String? _lastSeenAddress;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _contactController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  void _publishAlert() {
    final name = _nameController.text;
    final age = _ageController.text;
    final height = _heightController.text;
    final contact = _contactController.text;
    final desc = _featuresController.text;
    final lat = _lastSeenLatitude;
    final lng = _lastSeenLongitude;
    final address = _lastSeenAddress;

    try {
      // Show Loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Check required fields
      if (_imagePath == null ||
          _nameController.text.isEmpty ||
          _ageController.text.isEmpty ||
          _heightController.text.isEmpty) {
        Navigator.pop(context); // Dismiss loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields.')),
        );
        return;
      } else {
        ref
            .read(userAlertsProvider.notifier)
            .publishAlert(
              _imagePath!,
              name,
              age,
              height,
              contact,
              desc,
              lat!,
              lng!,
              address!,
            );
      }

      // Simulate network call delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context); // Dismiss loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alert published successfully!')),
          );
        }
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
          // MaterialPageRoute(builder: (context) => const SmartShareCard()),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss loading indicator
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to publish alert.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
        leadingWidth: 80,
        title: const Text(
          'Report Missing',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    progressSection(),

                    SizedBox(height: screenHeight * 0.025),

                    // Title
                    const Text(
                      'Missing Person Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Photo upload section
                    AddPhotoSection(
                      screenHeight: screenHeight,
                      onImageSelected: (String imagePath) {
                        setState(() {
                          _imagePath = imagePath;
                        });
                      },
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Full Name field
                    _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      placeholder: 'e.g. John Doe',
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Age and Height row
                    _buildAgeHeightRow(isSmallScreen),

                    SizedBox(height: screenHeight * 0.025),

                    // Contact Information field
                    _buildTextField(
                      label: 'Contact',
                      controller: _contactController,
                      placeholder: 'e.g. +237654123456',
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Distinctive features field
                    _buildTextField(
                      label: 'Distinctive Clothing or Features',
                      controller: _featuresController,
                      placeholder:
                          'Red hoodie, blue jeans, scar on left cheek...',
                      maxLines: 4,
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Last Known Location
                    LastSeenLocation(
                      screenHeight: screenHeight,
                      onLocationPicked:
                          (double lat, double lng, String address) {
                            // Handle location picked
                            _lastSeenLatitude = lat;
                            _lastSeenLongitude = lng;
                            _lastSeenAddress = address;
                            setState(() {});
                          },
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),

            // Publish button at bottom
            publishButton(),
          ],
        ),
      ),
    );
  }

  Widget publishButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle publish alert
          _publishAlert();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign, size: 20),
            SizedBox(width: 8),
            Text(
              'PUBLISH ALERT NOW',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeHeightRow(bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          flex: isSmallScreen ? 1 : 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Age',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '##',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: isSmallScreen ? 1 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Height',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'ft/cm',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
