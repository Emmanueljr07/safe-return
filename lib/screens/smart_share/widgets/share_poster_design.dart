import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/smart_share/widgets/qr_code_section.dart';

class SharePosterDesign extends StatelessWidget {
  const SharePosterDesign({super.key, required this.alert});

  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 600,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Missing Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'MISSING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            // Row with photo and Qr code
            Row(
              children: [
                // Photo placeholder
                Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(alert.imageUrl, fit: BoxFit.cover),
                  // child: Image.file(File(alert.imageUrl), fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),

                // QR Code Display Screen (for showing QR on poster)
                QRCodeSection(caseId: alert.id),
              ],
            ),

            // Name and Age
            Center(
              child: Column(
                children: [
                  Text(
                    alert.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Age: ${alert.age} • Height: ${alert.height}cm",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            // Last seen
            Text(
              "Last seen at Post Central Park, Yde on ${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year} at ${alert.createdAt.hour}:${alert.createdAt.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
