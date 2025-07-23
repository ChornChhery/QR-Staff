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
  String _searchQuery = '';

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
    final dayLogs = _logs[_selectedDate!] ?? [];
    if (_searchQuery.isEmpty) return dayLogs;
    return dayLogs.where((log) =>
      log['name']!.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _buildSummary() {
    final logs = _filteredLogs;
    int checkIns = logs.where((log) => log['action'] == 'Check-in').length;
    int checkOuts = logs.where((log) => log['action'] == 'Check-out').length;
    int totalStaff = logs.map((log) => log['name']).toSet().length;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📊 Summary for $_selectedDate',
              style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('✅ Check-ins: $checkIns'),
            Text('❌ Check-outs: $checkOuts'),
            Text('👥 Staff logged: $totalStaff'),
          ],
        ),
      ),
    );
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
            const SizedBox(height: 10),
            _buildSummary(),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                labelText: '🔍 Search staff',
                prefixIcon: Icon(Icons.search),
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
                        final isCheckIn = log['action'] == 'Check-in';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(
                              isCheckIn ? Icons.login : Icons.logout,
                              color: isCheckIn ? Colors.green : Colors.red,
                            ),
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
