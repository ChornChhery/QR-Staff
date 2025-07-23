import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/file_helper.dart';
import 'package:intl/intl.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  Future<void> logAction(String staffId, BuildContext context) async {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm').format(now);

    final logs = await FileHelper.loadLogs();
    final dayLogs = logs[date] ?? [];

    final lastAction = dayLogs.lastWhere(
      (log) => log['name'] == staffId,
      orElse: () => null,
    );
    final action = (lastAction == null || lastAction['action'] == 'Check-out')
        ? 'Check-in'
        : 'Check-out';

    dayLogs.add({'name': staffId, 'action': action, 'time': time});
    logs[date] = dayLogs;

    await FileHelper.saveLogs(logs);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$staffId $action at $time')));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('📷 Tap to Scan QR', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Scan QR')),
                body: MobileScanner(
                  onDetect: (BarcodeCapture capture) {
                    final Barcode? barcode = capture.barcodes.firstOrNull;
                    final String? code = barcode?.rawValue;

                    if (code != null) {
                      Navigator.pop(context);
                      logAction(code, context);
                    }
                  },
                ),
              ),
            ));
          },
          child: const Text('Scan QR'),
        ),
      ]),
    );
  }
}
