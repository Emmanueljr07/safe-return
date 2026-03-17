import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/smart_share/smart_share_card.dart';

Widget buildCaseCard(AlertItem caseItem, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigate to case details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SmartShareCard(alert: caseItem),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Image Placeholder
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.asset(caseItem.imageUrl, fit: BoxFit.cover),
                      // child: Image.file(File(alert.imageUrl), fit: BoxFit.cover),
                    ),
                  ),
                ),

                // Badge (Urgent or Senior)
                // if (caseItem.isUrgent || caseItem.isSenior)
                //   Positioned(
                //     top: 12,
                //     left: 12,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 10,
                //         vertical: 4,
                //       ),
                //       decoration: BoxDecoration(
                //         color: caseItem.isUrgent
                //             ? Colors.red.shade600
                //             : Colors.blue.shade600,
                //         borderRadius: BorderRadius.circular(6),
                //       ),
                //       child: Text(
                //         caseItem.isUrgent ? 'URGENT' : 'SENIOR',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.bold,
                //           letterSpacing: 0.5,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),

          // Info Section
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${caseItem.name}, ${caseItem.age} yrs",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share_outlined,
                              color: Colors.grey.shade600,
                              size: 16,
                            ),
                            onPressed: () {
                              // Handle share
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              caseItem.location.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Last Seen
                  Text(
                    "Last Seen ${caseItem.createdAt.hour}hrs ago",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
