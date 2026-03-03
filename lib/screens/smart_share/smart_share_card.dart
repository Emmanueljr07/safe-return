import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/smart_share/widgets/action_buttons.dart';
import 'package:karu/screens/smart_share/widgets/build_poster_card.dart';
import 'package:karu/screens/smart_share/widgets/share_poster_design.dart';
import 'package:karu/services/whatsapp_share_service.dart';

class SmartShareCard extends StatefulWidget {
  const SmartShareCard({super.key, required this.alert});

  final AlertItem alert;

  @override
  State<SmartShareCard> createState() => _SmartShareCardState();
}

class _SmartShareCardState extends State<SmartShareCard> {
  final WhatsAppShareService shareService = WhatsAppShareService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: 16,
            ),
            child: Column(
              children: [
                // Main Poster Card
                BuildPosterCard(alert: widget.alert),

                SizedBox(height: screenHeight * 0.03),

                // Action Buttons at Bottom
                ActionButtons(
                  onWhatsAppShare: () {
                    _sharePosterToWhatsApp();
                  },
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const DashboardPage()),
          // );
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Digital Smart Card',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () {
              // Handle share
              _shareViaShareSheet();
            },
            child: const Text(
              'Share',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sharePosterToWhatsApp() async {
    // Check if WhatsApp is installed first
    final isInstalled = await shareService.isWhatsAppInstalled();

    if (!isInstalled && mounted) {
      shareService.showWhatsAppNotInstalledDialog(context);
      return;
    }

    // Create a poster widget (your actual poster design)
    final posterWidget = SharePosterDesign(alert: widget.alert);

    if (mounted) {
      await shareService.sharePosterToWhatsApp(
        posterWidget: posterWidget,
        context: context,
        caption: '🚨 URGENT - Missing Person',
      );
    }
  }

  Future<void> _shareViaShareSheet() async {
    await shareService.shareViaShareSheet(
      text: '''
🚨 URGENT - MISSING PERSON 🚨

Name: Sarah Jenkins
Age: 24 years old
Last Seen: Starbucks on 4th St
Time: Yesterday 4:30 PM

Case #8921
Contact: 911

Please share to help!
''',
      subject: 'Missing Person Alert',
    );
  }
}
