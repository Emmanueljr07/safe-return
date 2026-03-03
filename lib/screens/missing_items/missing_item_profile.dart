import 'dart:io';

import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';

class MissingPersonProfilePage extends StatefulWidget {
  const MissingPersonProfilePage({super.key, required this.alert});

  final AlertItem alert;

  @override
  State<MissingPersonProfilePage> createState() =>
      _MissingPersonProfilePageState();
}

class _MissingPersonProfilePageState extends State<MissingPersonProfilePage> {
  // bool _markAsFoundEnabled = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
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
                    // Critical Alert Banner
                    _buildCriticalAlert(),

                    SizedBox(height: screenHeight * 0.02),

                    // Name and Missing Date
                    _buildPersonInfo(),

                    SizedBox(height: screenHeight * 0.025),

                    // Photos Section
                    _buildPhotosSection(screenWidth, isSmallScreen),

                    SizedBox(height: screenHeight * 0.015),

                    // Accuracy disclaimer
                    _buildAccuracyDisclaimer(),

                    SizedBox(height: screenHeight * 0.03),

                    // Vital Statistics
                    _buildVitalStatistics(),

                    SizedBox(height: screenHeight * 0.025),

                    // Distinguishing Features
                    _buildDistinguishingFeatures(),

                    SizedBox(height: screenHeight * 0.03),

                    // Last Seen Location
                    _buildLastSeenLocation(screenHeight),

                    SizedBox(height: screenHeight * 0.025),

                    // Guardian Controls
                    _buildGuardianControls(),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            _buildBottomActions(isSmallScreen),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Handle back navigation
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Case #${widget.alert.id.substring(0, 6).toUpperCase()}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () {
            // Handle share
          },
        ),
      ],
    );
  }

  Widget _buildCriticalAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Text(
            'MISSING - CRITICAL',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.alert.name,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              'Missing since ${widget.alert.createdAt.month} ${widget.alert.createdAt.day}, ${widget.alert.createdAt.year}',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosSection(double screenWidth, bool isSmallScreen) {
    final photoWidth = (screenWidth - (isSmallScreen ? 48 : 56)) / 2;

    return Row(
      children: [
        // Original Photo
        Expanded(
          child: _buildPhotoCard(
            photoWidth: photoWidth,
            label: 'ORIGINAL',
            labelColor: Colors.brown.shade700,
            labelBackgroundColor: Colors.brown.shade200,
            captionTop: 'Last Seen (${widget.alert.createdAt.year})',
            captionTopColor: Colors.black,
            borderColor: Colors.brown.shade200,
            // Placeholder for original photo
            photoPlaceholder: Image.file(
              File(widget.alert.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // AI Aging Photo
        Expanded(
          child: _buildPhotoCard(
            photoWidth: photoWidth,
            label: 'AI AGING',
            labelColor: Colors.white,
            labelBackgroundColor: Colors.blue,
            captionTop: 'Projected Age (8 yrs)',
            captionTopColor: Colors.blue,
            borderColor: Colors.blue.shade200,
            // Placeholder for AI aged photo
            photoPlaceholder: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.face,
                  size: photoWidth * 0.4,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard({
    required double photoWidth,
    required String label,
    required Color labelColor,
    required Color labelBackgroundColor,
    required String captionTop,
    required Color captionTopColor,
    required Color borderColor,
    required Widget photoPlaceholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                AspectRatio(aspectRatio: 0.75, child: photoPlaceholder),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: labelBackgroundColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (label == 'AI AGING')
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.auto_awesome,
                              size: 12,
                              color: labelColor,
                            ),
                          ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          captionTop,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: captionTopColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyDisclaimer() {
    return Center(
      child: Text(
        'AI projection has ~85% accuracy based on familial traits.',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildVitalStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VITAL STATISTICS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'CURRENT AGE',
                  value: '${widget.alert.age} Years Old',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  label: 'HEIGHT',
                  value: '5\' 2" (${widget.alert.height}cm)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'HAIR COLOR',
                  value: 'Blonde, Curly',
                ),
              ),
              Expanded(
                child: _buildStatItem(label: 'EYE COLOR', value: 'Blue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDistinguishingFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DISTINGUISHING FEATURES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFeatureChip(widget.alert.description),
            _buildFeatureChip('E.g Birthmark on neck'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLastSeenLocation(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Last Seen Location',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: screenHeight * 0.18,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Map placeholder
                Container(color: Colors.grey.shade300),
                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                // Map icon placeholder
                Center(
                  child: Icon(Icons.map, size: 48, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.park, color: Colors.grey.shade700, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Near Oak Park Playground',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Geofence Active (5km radius)',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuardianControls() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Guardian Controls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mark as Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Notifies authorities & community',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Switch(
                value: !widget.alert.isMissing,
                onChanged: (value) {
                  setState(() {
                    widget.alert.isMissing = !value;
                  });
                },
                activeThumbColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit anonymous tip
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 14 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 20),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Text(
                        'Submit Anonymous Tip',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined),
                  color: Colors.black87,
                  onPressed: () {
                    // Handle share
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              // Handle contact police dispatch
            },
            icon: Icon(
              Icons.shield_outlined,
              color: Colors.red.shade700,
              size: 18,
            ),
            label: Text(
              'Contact Police Dispatch (911)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
