class Student {
  final String id;
  final String name;
  final String avatar;
  final String major;
  final double gpa;
  final String status;

  const Student({
    required this.id,
    required this.name,
    required this.avatar,
    required this.major,
    required this.gpa,
    required this.status,
  });

  factory Student.fromJson(
    Map<String, dynamic> json, {
    bool strictId = true,
    String? fallbackId,
  }) {
    final id = strictId
        ? _readNonEmptyString(json, 'id')
        : _readOptionalString(json, 'id', fallbackValue: fallbackId);
    final name = _readNonEmptyString(json, 'name');
    final avatar = _readNonEmptyString(json, 'avatar');
    final major = _readNonEmptyString(json, 'major');
    final status = _readNonEmptyString(json, 'status');
    final gpa = _readGpa(json['gpa']);

    return Student(
      id: id,
      name: name,
      avatar: avatar,
      major: major,
      gpa: gpa,
      status: status,
    );
  }

  static String _readNonEmptyString(
    Map<String, dynamic> json,
    String key,
  ) {
    final raw = json[key];
    final value = raw?.toString().trim() ?? '';
    if (value.isEmpty) {
      throw FormatException('Thieu hoac rong truong: $key');
    }
    return value;
  }

  static String _readOptionalString(
    Map<String, dynamic> json,
    String key, {
    String? fallbackValue,
  }) {
    final raw = json[key] ?? fallbackValue;
    return raw?.toString().trim() ?? '';
  }

  static double _readGpa(dynamic rawValue) {
    final numValue =
        rawValue is num ? rawValue.toDouble() : double.tryParse('$rawValue');
    if (numValue == null) {
      throw const FormatException('Truong gpa khong hop le: phai la so.');
    }
    if (numValue < 0 || numValue > 4) {
      throw const FormatException('Truong gpa khong hop le: phai trong khoang 0 den 4.');
    }
    return numValue;
  }
}
