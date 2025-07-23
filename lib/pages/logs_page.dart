import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/file_helper.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  DateTimeRange? _selectedRange;
  Map<String, List<Map<String, String>>> _logs = {};
  String _searchQuery = '';
  String? _selectedStaff;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await FileHelper.loadLogs();
    setState(() {
      _logs = logs;
      _selectedRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 6)),
        end: DateTime.now(),
      );
    });
  }

  List<Map<String, String>> get _filteredLogs {
    if (_selectedRange == null) return [];
    final start = _selectedRange!.start;
    final end = _selectedRange!.end;
    final filtered = <Map<String, String>>[];

    for (final entry in _logs.entries) {
      final date = DateTime.parse(entry.key);
      if (date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)))) {
        for (final log in entry.value) {
          final nameMatch =
              _searchQuery.isEmpty ||
              log['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
          final staffMatch =
              _selectedStaff == null || log['name'] == _selectedStaff;
          if (nameMatch && staffMatch) {
            filtered.add({...log, 'date': entry.key});
          }
        }
      }
    }
    return filtered;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedRange,
    );
    if (picked != null) {
      setState(() {
        _selectedRange = picked;
      });
    }
  }

  void _exportLogs() {
    final csv = StringBuffer('Name,Action,Time,Date\n');
    for (final log in _filteredLogs) {
      csv.writeln(
        '${log['name']},${log['action']},${log['time']},${log['date']}',
      );
    }
    // Replace with proper file saving later
    Share.share(csv.toString(), subject: 'QR Staff Logs Export');
  }

  Widget _buildSummaryCard() {
    final logs = _filteredLogs;
    int checkIns = logs.where((l) => l['action'] == 'Check-in').length;
    int checkOuts = logs.where((l) => l['action'] == 'Check-out').length;
    int uniqueStaff = logs.map((l) => l['name']).toSet().length;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Summary (${DateFormat.yMMMd().format(_selectedRange!.start)} → ${DateFormat.yMMMd().format(_selectedRange!.end)})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('✅ Check-ins: $checkIns'),
            Text('❌ Check-outs: $checkOuts'),
            Text('👥 Staff logged: $uniqueStaff'),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final dates = _selectedRange == null
        ? []
        : List.generate(
            _selectedRange!.duration.inDays + 1,
            (i) => _selectedRange!.start.add(Duration(days: i)),
          );

    final barGroups = dates.map((date) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final entries = _logs[dateStr] ?? [];
      final checkIns = entries.where((l) => l['action'] == 'Check-in').length;
      final checkOuts = entries.where((l) => l['action'] == 'Check-out').length;

      return BarChartGroupData(
        x: dates.indexOf(date),
        barRods: [
          BarChartRodData(y: checkIns.toDouble(), colors: [Colors.green]),
          BarChartRodData(y: checkOuts.toDouble(), colors: [Colors.red]),
        ],
      );
    }).toList();

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                final i = value.toInt();
                if (i >= 0 && i < dates.length) {
                  return DateFormat('MM/dd').format(dates[i]);
                }
                return '';
              },
              margin: 8,
                getTextStyles: (value) => const TextStyle(fontSize: 10),
            ),
          ),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffList = _filteredLogs.map((l) => l['name']).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _filteredLogs.isEmpty ? null : _exportLogs,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _selectedRange == null
                          ? 'Select Date Range'
                          : '${DateFormat.yMMMd().format(_selectedRange!.start)} → ${DateFormat.yMMMd().format(_selectedRange!.end)}',
                    ),
                    onPressed: () => _selectDateRange(context),
                  ),
                ),
              ],
            ),
            if (_selectedRange != null) _buildSummaryCard(),
            if (_selectedRange != null) _buildChart(),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: '🔍 Search staff by name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            DropdownButton<String>(
              hint: const Text('Filter by staff'),
              value: _selectedStaff,
              items: staffList.map((staff) {
                return DropdownMenuItem<String>(
                  value: staff,
                  child: Text(staff ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStaff = value),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredLogs.isEmpty
                  ? const Center(
                      child: Text('No logs found for selected range'),
                    )
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
                            title: Text('${log['name']}'),
                            subtitle: Text(
                              '${log['action']} at ${log['time']} on ${log['date']}',
                            ),
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
