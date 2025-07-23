import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStaffPage extends StatefulWidget {
  const ManageStaffPage({super.key});
  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _staff = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _staff = prefs.getStringList('staff_list') ?? [];
    });
  }

  Future<void> _saveStaff() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('staff_list', _staff);
  }

  void _addStaff() {
    final name = _controller.text.trim();
    if (name.isNotEmpty && !_staff.contains(name)) {
      setState(() {
        _staff.add(name);
        _controller.clear();
      });
      _saveStaff();
    }
  }

  void _removeStaff(String name) {
    setState(() {
      _staff.remove(name);
    });
    _saveStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Staff ID or Name'),
            ),
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: _addStaff),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _staff.length,
          itemBuilder: (_, index) {
            final name = _staff[index];
            return ListTile(
              title: Text(name),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('QR for $name'),
                        content: QrImageView(data: name, size: 200),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeStaff(name),
                ),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}
