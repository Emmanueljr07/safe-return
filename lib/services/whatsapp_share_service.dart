import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

/// Service class to handle WhatsApp sharing functionality
class WhatsAppShareService {
  // Screenshot controller for capturing widget as image
  final ScreenshotController screenshotController = ScreenshotController();

  /// Share poster image to WhatsApp
  ///
  /// Captures a widget as image and shares it
  Future<bool> sharePosterToWhatsApp({
    required Widget posterWidget,
    required BuildContext context,
    String? caption,
  }) async {
    try {
      // Capture the poster widget as image
      final Uint8List? imageBytes = await screenshotController
          .captureFromWidget(
            posterWidget,
            context: context,
            pixelRatio: 3.0, // Higher quality image
          );

      if (imageBytes == null) {
        debugPrint('Failed to capture poster');
        return false;
      }

      // Save image to temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/missing_person_poster_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      // Share the image file
      // Note: WhatsApp sharing of images works differently on iOS vs Android
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath)],
          text: caption ?? 'URGENT: Missing Person - Please help share',
        ),
      );
      // await Share.shareXFiles(
      //   [XFile(imagePath)],
      //   text: caption ?? 'URGENT: Missing Person - Please help share',
      //   // On Android, this will show WhatsApp in share menu
      //   // On iOS, user selects WhatsApp from share sheet
      // );

      return true;
    } catch (e) {
      debugPrint('Error sharing poster to WhatsApp: $e');
      return false;
    }
  }

  /// Share via native share sheet (includes WhatsApp)
  ///
  /// This is the most reliable cross-platform method
  Future<void> shareViaShareSheet({
    required String text,
    String? subject,
  }) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text, subject: subject));
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  /// Check if WhatsApp is installed
  Future<bool> isWhatsAppInstalled() async {
    try {
      final Uri uri = Uri.parse(
        'https://wa.me/${237683681584}?text=${Uri.encodeComponent('message')}',
      );
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Show dialog if WhatsApp is not installed
  void showWhatsAppNotInstalledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WhatsApp Not Installed'),
        content: const Text(
          'WhatsApp is not installed on this device. Please install WhatsApp or use another sharing method.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Open Play Store or App Store
              _openWhatsAppStore();
            },
            child: const Text('Install WhatsApp'),
          ),
        ],
      ),
    );
  }

  /// Open WhatsApp in Play Store or App Store
  Future<void> _openWhatsAppStore() async {
    final Uri androidUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.whatsapp',
    );
    final Uri iosUri = Uri.parse(
      'https://apps.apple.com/app/whatsapp-messenger/id310633997',
    );

    try {
      if (Platform.isAndroid) {
        await launchUrl(androidUri, mode: LaunchMode.externalApplication);
      } else if (Platform.isIOS) {
        await launchUrl(iosUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening store: $e');
    }
  }
}
