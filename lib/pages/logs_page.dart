import 'package:flutter/material.dart';
import '../utils/file_helper.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});
  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  Map<String, dynamic> _logs = {};

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await FileHelper.loadLogs();
    setState(() {
      _logs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _logs.entries.map((entry) {
        final date = entry.key;
        final List logs = entry.value;
        return ExpansionTile(
          title: Text('📅 $date'),
          children: logs.map<Widget>((log) {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('${log['name']} - ${log['action']} - ${log['time']}'),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
