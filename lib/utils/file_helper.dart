import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/logs.json');
  }

  static Future<Map<String, dynamic>> loadLogs() async {
    final file = await _getLogFile();
    if (!(await file.exists())) {
      return {};
    }
    final content = await file.readAsString();
    return content.isNotEmpty ? jsonDecode(content) : {};
  }

  static Future<void> saveLogs(Map<String, dynamic> logs) async {
    final file = await _getLogFile();
    await file.writeAsString(jsonEncode(logs));
  }
}
