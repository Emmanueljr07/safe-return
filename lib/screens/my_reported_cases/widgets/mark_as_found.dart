import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MarkAsFoundSection extends StatefulWidget {
  MarkAsFoundSection({super.key, required this.isFound});

  bool isFound;

  @override
  State<MarkAsFoundSection> createState() => _MarkAsFoundSectionState();
}

class _MarkAsFoundSectionState extends State<MarkAsFoundSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mark as Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Toggling this will expire the public poster link and notify authorities that the search is complete.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Toggle Switch
          Row(
            children: [
              Switch(
                value: widget.isFound,
                onChanged: (value) {
                  setState(() {
                    widget.isFound = value;
                  });
                  if (value) {
                    _showMarkAsFoundDialog();
                  }
                },
                activeThumbColor: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isFound ? 'Marked as Found' : 'Not Found',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.isFound
                      ? Colors.green.shade700
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMarkAsFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Found?'),
        content: const Text(
          'This will expire the public poster link and notify authorities. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.isFound = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Case marked as found');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
