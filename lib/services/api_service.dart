import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class ApiService {
  static const String defaultStudentsUrl =
      'https://69bac59db3dcf7e0b4be09f6.mockapi.io/students';
  static const Duration _requestTimeout = Duration(seconds: 10);

  final http.Client _client;
  final Uri _studentsUri;

  ApiService({
    http.Client? client,
    Uri? studentsUri,
  })  : _client = client ?? http.Client(),
        _studentsUri = studentsUri ?? Uri.parse(defaultStudentsUrl);

  Future<List<Student>> fetchStudents() async {
    http.Response response;
    try {
      response = await _client.get(_studentsUri).timeout(_requestTimeout);
    } on TimeoutException {
      throw Exception('Het thoi gian ket noi den API sinh vien.');
    } on Exception catch (error) {
      throw Exception('Loi mang khi tai danh sach sinh vien: $error');
    }

    if (response.statusCode != 200) {
      throw Exception('Khong the tai danh sach sinh vien: ${response.statusCode}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const FormatException('Noi dung phan hoi khong phai JSON hop le.');
    }

    if (decoded is! List) {
      throw const FormatException('Du lieu tra ve phai la mot mang JSON.');
    }

    final students = _parseStudents(decoded);

    if (students.isEmpty) {
      throw const FormatException('Khong tim thay ban ghi sinh vien hop le tu API.');
    }

    return students;
  }

  Future<void> printStudentsPreview() async {
    final students = await fetchStudents();
    // ignore: avoid_print
    print('Da tai ${students.length} sinh vien tu MockAPI.');
    if (students.isNotEmpty) {
      final first = students.first;
      // ignore: avoid_print
      print('Sinh vien dau tien: ${first.name} - GPA ${first.gpa} - ${first.status}');
    }
  }

  List<Student> _parseStudents(List<dynamic> decoded) {
    final students = <Student>[];

    for (var i = 0; i < decoded.length; i++) {
      final item = decoded[i];
      if (item is! Map<String, dynamic>) {
        throw FormatException(
          'Sinh vien tai vi tri $i khong hop le: khong phai JSON object.',
        );
      }

      try {
        students.add(Student.fromJson(item));
      } on FormatException catch (error) {
        throw FormatException(
          'Sinh vien tai vi tri $i khong hop le: ${error.message}',
        );
      }
    }

    return students;
  }
}
