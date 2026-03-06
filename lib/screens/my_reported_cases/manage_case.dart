import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/my_reported_cases/widgets/case_action_buttons.dart';
import 'package:karu/screens/my_reported_cases/widgets/case_info_card.dart';
import 'package:karu/screens/my_reported_cases/widgets/case_performance_section.dart';
import 'package:karu/screens/my_reported_cases/widgets/mark_as_found.dart';

class ManageCasePage extends StatefulWidget {
  const ManageCasePage({super.key, required this.caseItem});

  final AlertItem caseItem;

  @override
  State<ManageCasePage> createState() => _ManageCasePageState();
}

class _ManageCasePageState extends State<ManageCasePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Case Information Card
            CaseInfoCard(
              screenHeight: screenHeight,
              imageUrl: widget.caseItem.imageUrl,
              name: widget.caseItem.name,
              address: widget.caseItem.location.address,
              id: widget.caseItem.id,
            ),

            SizedBox(height: screenHeight * 0.02),

            // Mark as Found Section
            MarkAsFoundSection(isFound: !widget.caseItem.isMissing),

            SizedBox(height: screenHeight * 0.03),

            // Case Performance Section
            CasePerformanceSection(),

            SizedBox(height: screenHeight * 0.03),

            // Action Buttons
            CaseActionButtons(),

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
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Manage Case',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.black, size: 28),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Case'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () {
                Navigator.pop(context);
                // Handle notifications
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Case',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Case?'),
        content: const Text(
          'This action cannot be undone. All case data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
