import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/data/alerts_list.dart';

class LiveQrStatus extends StatefulWidget {
  const LiveQrStatus({super.key, required this.alertId});

  final String alertId;

  @override
  State<LiveQrStatus> createState() => _LiveQrStatusState();
}

class _LiveQrStatusState extends State<LiveQrStatus> {
  // Get alert details based on alertId (mocked for this example)
  AlertItem getAlertDetails(String id) {
    return alerts.firstWhere((alert) => alert.id == id);
  }

  @override
  initState() {
    super.initState();
    final alertDetails = getAlertDetails(widget.alertId);
    debugPrint('Loaded alert details for: ${alertDetails.name}');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Received alert ID: $widget.alertId');

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Urgent Alert Badge
            _buildUrgentAlert(),

            SizedBox(height: screenHeight * 0.02),

            // Status Header
            _buildStatusHeader(),

            SizedBox(height: screenHeight * 0.03),

            // Profile Section
            _buildProfileSection(screenHeight),

            SizedBox(height: screenHeight * 0.025),

            // Name
            const Text(
              'Sarah Jenkins',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // Age and Height
            _buildPersonStats(),

            SizedBox(height: screenHeight * 0.03),

            // Distinguishing Features
            _buildDistinguishingFeatures(),

            SizedBox(height: screenHeight * 0.03),

            // Contact Reporter Button
            _buildContactButton(),

            SizedBox(height: screenHeight * 0.015),

            // Share Profile Button
            _buildShareButton(),

            SizedBox(height: screenHeight * 0.035),

            // Last Seen Location
            _buildLastSeenSection(screenHeight),

            SizedBox(height: screenHeight * 0.03),

            // Case Timeline
            _buildCaseTimeline(),

            SizedBox(height: screenHeight * 0.03),

            // Footer Info
            _buildFooter(),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black, size: 28),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Case Status #8921',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.ios_share, color: Colors.blue, size: 24),
          onPressed: () {
            // Handle share
          },
        ),
      ],
    );
  }

  Widget _buildUrgentAlert() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, color: Colors.red.shade700, size: 18),
          const SizedBox(width: 6),
          Text(
            'URGENT ALERT',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Column(
      children: [
        const Text(
          'STILL MISSING',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last update: 2 hours ago',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProfileSection(double screenHeight) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: screenHeight * 0.2,
          height: screenHeight * 0.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink.shade400, Colors.blue.shade600],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.shade100,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: screenHeight * 0.08,
                color: Colors.orange.shade300,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: screenHeight * 0.065,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.search, color: Colors.blue, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatChip('Age: 24'),
        const SizedBox(width: 12),
        _buildStatChip('5\'7"'),
      ],
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDistinguishingFeatures() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
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
          Text(
            'Last seen wearing a blue denim jacket, black leggings, and white sneakers. Has a small butterfly tattoo on her right wrist.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle contact reporter
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 20),
            SizedBox(width: 8),
            Text(
              'Contact Reporter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          // Handle share
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share, size: 20),
            SizedBox(width: 8),
            Text(
              'Share Case Profile',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastSeenSection(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Last Seen Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '2 miles away',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: screenHeight * 0.18,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Map placeholder
                Container(
                  color: Colors.blue.shade100,
                  child: Center(
                    child: Icon(
                      Icons.map,
                      size: 48,
                      color: Colors.blue.shade300,
                    ),
                  ),
                ),
                // Location pin
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Location details overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Starbucks on 4th St',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'San Francisco, CA • Yesterday 4:30 PM',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
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
      ],
    );
  }

  Widget _buildCaseTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Case Timeline',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        _buildTimelineItem(
          time: 'Yesterday, 4:30 PM',
          title: 'Last seen at Coffee Shop',
          description:
              'Witness reported seeing her order a latte and leave towards Market St.',
          isFirst: true,
        ),
        _buildTimelineItem(
          time: 'Yesterday, 8:00 AM',
          title: 'Left home for work',
          description: null,
          isFirst: false,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    String? description,
    required bool isFirst,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isFirst ? Colors.blue : Colors.grey.shade400,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst ? Colors.blue.shade700 : Colors.grey.shade500,
                  width: 3,
                ),
              ),
            ),
            if (description != null)
              Container(width: 2, height: 60, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
              if (description != null) const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'If you have any information, please contact the reporter\nimmediately or call local authorities.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Handle privacy policy
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            Text(' • ', style: TextStyle(color: Colors.grey.shade400)),
            TextButton(
              onPressed: () {
                // Handle report issue
              },
              child: Text(
                'Report Issue',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
