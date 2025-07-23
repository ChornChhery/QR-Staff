class LogEntry {
  final String name;
  final String action;
  final String time;

  LogEntry({
    required this.name,
    required this.action,
    required this.time,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      name: json['name'],
      action: json['action'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'action': action,
      'time': time,
    };
  }
}
