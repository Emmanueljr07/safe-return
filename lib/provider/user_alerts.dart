import 'package:flutter_riverpod/legacy.dart';
import 'package:karu/models/alert_item.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart' show debugPrint;

class UserAlertsNotifier extends StateNotifier<List<AlertItem>> {
  UserAlertsNotifier() : super(const []);
  final SupabaseClient _supabase = Supabase.instance.client;

  // Publish New Alert
  Future<AlertItem> publishAlert(
    String imageUrl,
    String name,
    String age,
    String height,
    String contact,
    String description,
    double latitude,
    double longitude,
    String address,
  ) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final imageFilename = path.basename(imageUrl);
      final copiedimageUrl = await File(
        imageUrl,
      ).copy('${appDir.path}/$imageFilename');

      // upload Image to supabase
      final url = await uploadImageAndGetUrl(copiedimageUrl);

      if (url == null) {
        debugPrint("Something went wrong with image");
        throw Exception("Something went wrong");
      }

      final alert = AlertItem(
        // imageUrl: copiedimageUrl.path,
        imageUrl: url,
        name: name,
        age: age,
        height: height,
        contact: contact,
        description: description,
        location: AlertLocation(
          latitude: latitude,
          longitude: longitude,
          address: address,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final response = await _supabase
          .from('alerts')
          .insert(alert.toJson())
          .select()
          .single();

      state = [...state, AlertItem.fromJson(response)];
      return AlertItem.fromJson(response);
    } catch (e) {
      debugPrint('Error publishing alert: $e');
      throw Exception('Failed to create alert: $e');
    }
  }

  // Get All Alerts
  Future<void> fetchAlerts() async {
    try {
      final response = await _supabase
          .from('alerts')
          .select()
          .order('createdAt', ascending: false);
      final List<AlertItem> allAlerts = (response as List)
          .map((json) => AlertItem.fromJson(json))
          .toList();

      state = allAlerts;
    } catch (e) {
      debugPrint('Error fetching alerts: $e');
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  // Upload and Get ImageUrl
  Future<String?> uploadImageAndGetUrl(File file) async {
    // 1. Generate a unique file name
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = 'uploads/$fileName'; // folder/filename in bucket

    // 2. Upload to Supabase Storage
    await _supabase.storage
        .from('images') // your bucket name
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false, // set true to overwrite existing files
          ),
        );

    // 4. Get the public URL
    final String publicUrl = _supabase.storage
        .from('images')
        .getPublicUrl(filePath);

    debugPrint('Image URL: $publicUrl');
    return publicUrl;
  }
}

final userAlertsProvider =
    StateNotifierProvider<UserAlertsNotifier, List<AlertItem>>((ref) {
      return UserAlertsNotifier();
    });
