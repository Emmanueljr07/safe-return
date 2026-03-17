import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoSection extends StatefulWidget {
  final void Function(String imagePath) onImageSelected;
  const AddPhotoSection({
    super.key,
    required this.screenHeight,
    required this.onImageSelected,
  });

  final double screenHeight;

  @override
  State<AddPhotoSection> createState() => _AddPhotoSectionState();
}

class _AddPhotoSectionState extends State<AddPhotoSection> {
  List<XFile>? _mediaFileList;
  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    // Implement image picker logic here
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _setImageFileListFromFile(pickedFile);
        widget.onImageSelected(
          pickedFile?.path ?? '',
        ); // Send image path to parent widget
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImages() {
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: Image.file(
          File(_mediaFileList!.first.path),
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                  child: Text('This image type is not supported'),
                );
              },
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return photoUploadSection(widget.screenHeight);
  }

  Widget photoUploadSection(double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle photo upload
            _onImageButtonPressed(ImageSource.gallery, context: context);
          },
          borderRadius: BorderRadius.circular(16),
          child: _mediaFileList != null
              ? _previewImages()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(28),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tap to add Last Seen Photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Clear face photos work best',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
