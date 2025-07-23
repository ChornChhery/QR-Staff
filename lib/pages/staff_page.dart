import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/file_helper.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<String> staffList = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    // Load staff list from shared preferences or local storage
    final logs = await FileHelper.loadLogs();
    setState(() {
      staffList = logs.keys.toList();
    });
  }

  Future<void> _addStaff(String staffId) async {
    if (staffId.isEmpty || staffList.contains(staffId)) return;

    // Add the new staff member
    final logs = await FileHelper.loadLogs();
    logs[staffId] = [];
    await FileHelper.saveLogs(logs);

    setState(() {
      staffList.add(staffId);
    });
  }

  Future<void> _removeStaff(String staffId) async {
    if (!staffList.contains(staffId)) return;

    // Remove staff member and their logs
    final logs = await FileHelper.loadLogs();
    logs.remove(staffId);
    await FileHelper.saveLogs(logs);

    setState(() {
      staffList.remove(staffId);
    });
  }

  Future<void> _generateQRCode(String staffId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code for $staffId'),
        content: QrImage(
          data: staffId,
          version: QrVersions.auto,
          size: 200.0,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: _addStaff,
              decoration: const InputDecoration(
                labelText: 'Add Staff ID',
                suffixIcon: Icon(Icons.add),
              ),
            ),
            const SizedBox(height: 20),
            Text('Staff List:', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 10),
            Expanded(
              child: staffList.isEmpty
                  ? const Center(child: Text('No staff available.'))
                  : ListView.builder(
                      itemCount: staffList.length,
                      itemBuilder: (context, index) {
                        final staffId = staffList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(staffId),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.qr_code),
                                  onPressed: () => _generateQRCode(staffId),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeStaff(staffId),
                                ),
                              ],
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
