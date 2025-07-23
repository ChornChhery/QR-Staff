import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import '../utils/file_helper.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? _lastLog;

  Future<void> logAction(String staffId, BuildContext context) async {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm').format(now);

    final logs = await FileHelper.loadLogs();
    final dayLogs = logs[date] ?? [];

    final lastAction = dayLogs.lastWhere(
      (log) => log['name'] == staffId,
      orElse: () => {},
    );

    final action = (lastAction == null || lastAction['action'] == 'Check-out')
        ? 'Check-in'
        : 'Check-out';

    dayLogs.add({'name': staffId, 'action': action, 'time': time});
    logs[date] = dayLogs;
    await FileHelper.saveLogs(logs);

    setState(() {
      _lastLog = '$staffId $action at $time';
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_lastLog!)));
  }

  void _startScan() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Scan QR')),
        body: MobileScanner(
          onDetect: (BarcodeCapture capture) {
            final code = capture.barcodes.firstOrNull?.rawValue;
            if (code != null) {
              Navigator.pop(context);
              logAction(code, context);
            }
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Tap below to scan staff QR', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan QR'),
            ),
            if (_lastLog != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('✅ $_lastLog', style: const TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}
