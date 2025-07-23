import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/file_helper.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String? _selectedDate;
  Map<String, List<Map<String, String>>> _logs = {};

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await FileHelper.loadLogs();
    setState(() {
      _logs = logs;
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  List<Map<String, String>> get _filteredLogs {
    if (_selectedDate == null) return [];
    return _logs[_selectedDate!] ?? [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date: ${_selectedDate ?? ''}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredLogs.isEmpty
                  ? const Center(child: Text('No logs found for this date'))
                  : ListView.builder(
                      itemCount: _filteredLogs.length,
                      itemBuilder: (context, index) {
                        final log = _filteredLogs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(log['name'] ?? 'Unknown'),
                            subtitle: Text('${log['action']} at ${log['time']}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
