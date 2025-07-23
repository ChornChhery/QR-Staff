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
}
