import 'package:flutter/material.dart';
import 'pages/scanner_page.dart';
import 'pages/logs_page.dart';
import 'pages/staff_page.dart';

void main() {
  runApp(const StaffTimerApp());
}

class StaffTimerApp extends StatelessWidget {
  const StaffTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline QR Staff Timer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final pages = const [
    QRScannerPage(),
    LogsPage(),
    ManageStaffPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline QR Staff Timer')),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan QR'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Staff'),
        ],
      ),
    );
  }
}
