import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';

Future<bool> isFaceImage(File imageFile) async {
  final options = FaceDetectorOptions(
    performanceMode: FaceDetectorMode.accurate,
  );

  final faceDetector = FaceDetector(options: options);

  try {
    final inputImage = InputImage.fromFile(imageFile);
    final List<Face> faces = await faceDetector.processImage(inputImage);

    return faces.isNotEmpty; // true = face detected
  } finally {
    faceDetector.close(); // always release resources
  }
}