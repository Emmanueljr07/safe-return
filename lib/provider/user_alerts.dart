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
    String description,
  ) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final imageFilename = path.basename(imageUrl);
      final copiedimageUrl = await File(
        imageUrl,
      ).copy('${appDir.path}/$imageFilename');

      final alert = AlertItem(
        imageUrl: copiedimageUrl.path,
        name: name,
        age: age,
        height: height,
        description: description,
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
}

final userAlertsProvider =
    StateNotifierProvider<UserAlertsNotifier, List<AlertItem>>((ref) {
      return UserAlertsNotifier();
    });
