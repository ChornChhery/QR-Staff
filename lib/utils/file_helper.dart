import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<Map<String, List<Map<String, String>>>> loadLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.json');
      if (!await file.exists()) {
        return {};
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);
      return Map<String, List<Map<String, String>>>.from(jsonData);
    } catch (e) {
      return {};
    }
  }

  static Future<void> saveLogs(Map<String, List<Map<String, String>>> logs) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/logs.json');
      final jsonData = jsonEncode(logs);
      await file.writeAsString(jsonData);
    } catch (e) {
      // Handle any error, e.g. log to console or show snackbar
      print('Error saving logs: $e');
    }
  }

  //Load staff from staff.json
  static Future<List<String>> loadStaff() async {
    try {
      final directory = await getApplicationCacheDirectory();
      final file = File('${directory.path}/staff.json');
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      return List<String>.from(jsonDecode(contents));
    } catch (e) {
      print('Error loading staff: $e');
      return [];
    }
  }

  // Save staff to staff.json
  static Future<void> saveStaff(List<String> staff) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/staff.json');
      final jsonData = jsonEncode(staff);
      await file.writeAsString(jsonData);
    } catch (e) {
      // Handle any error, e.g. log to console or show snackbar
      print('Error saving staff: $e');
  }
  }
}
