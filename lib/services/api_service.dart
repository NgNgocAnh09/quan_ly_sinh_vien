import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class ApiService {
  static const String _studentsUrl =
      'https://69bac59db3dcf7e0b4be09f6.mockapi.io/students';
  static const Duration _requestTimeout = Duration(seconds: 10);
  static final Uri _studentsUri = Uri.parse(_studentsUrl);

  Future<List<Student>> fetchStudents({bool strict = false}) async {
    http.Response response;
    try {
      response = await http.get(_studentsUri).timeout(_requestTimeout);
    } on Exception catch (error) {
      throw Exception('Loi mang khi tai danh sach sinh vien: $error');
    }

    if (response.statusCode != 200) {
      throw Exception('Khong the tai danh sach sinh vien: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Du lieu tra ve phai la mot mang JSON.');
    }

    final students = <Student>[];
    for (var i = 0; i < decoded.length; i++) {
      final item = decoded[i];
      if (item is! Map<String, dynamic>) {
        if (strict) {
          throw FormatException(
            'Sinh vien tai vi tri $i khong hop le: khong phai JSON object.',
          );
        }
        continue;
      }

      try {
        students.add(
          Student.fromJson(
            item,
            strictId: strict,
            fallbackId: 'generated-id-$i',
          ),
        );
      } on FormatException catch (error) {
        if (strict) {
          throw FormatException(
            'Sinh vien tai vi tri $i khong hop le: ${error.message}',
          );
        }
      }
    }

    if (students.isEmpty) {
      throw const FormatException('Khong tim thay ban ghi sinh vien hop le tu API.');
    }

    return students;
  }

  Future<void> printStudentsPreview({bool strict = false}) async {
    final students = await fetchStudents(strict: strict);
    // ignore: avoid_print
    print('Da tai ${students.length} sinh vien tu MockAPI.');
    if (students.isNotEmpty) {
      final first = students.first;
      // ignore: avoid_print
      print('Sinh vien dau tien: ${first.name} - GPA ${first.gpa} - ${first.status}');
    }
  }
}
