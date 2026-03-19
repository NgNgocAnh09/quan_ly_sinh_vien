import 'package:flutter/material.dart';

class StudentMock {
  final String id;
  final String name;
  final String avatarUrl;
  final String major;
  final double gpa;
  final String status;

  const StudentMock({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.major,
    required this.gpa,
    required this.status,
  });
}

const List<StudentMock> _dummyStudents = [
  StudentMock(
    id: 'SV001',
    name: 'Nguyen Minh Anh',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    major: 'Cong nghe thong tin',
    gpa: 3.68,
    status: 'Đang học',
  ),
  StudentMock(
    id: 'SV002',
    name: 'Tran Gia Bao',
    avatarUrl: 'https://i.pravatar.cc/150?img=24',
    major: 'Kinh te quoc te',
    gpa: 2.74,
    status: 'Bảo lưu',
  ),
  StudentMock(
    id: 'SV003',
    name: 'Le Hoang Phuc',
    avatarUrl: 'https://i.pravatar.cc/150?img=35',
    major: 'Ky thuat phan mem',
    gpa: 1.86,
    status: 'Cảnh báo',
  ),
  StudentMock(
    id: 'SV004',
    name: 'Pham Quynh Nhu',
    avatarUrl: 'https://i.pravatar.cc/150?img=41',
    major: 'Marketing',
    gpa: 3.25,
    status: 'Đang học',
  ),
  StudentMock(
    id: 'SV005',
    name: 'Vo Thanh Dat',
    avatarUrl: 'https://i.pravatar.cc/150?img=52',
    major: 'Tai chinh ngan hang',
    gpa: 2.12,
    status: 'Đang học',
  ),
];

class StudentListWidget extends StatelessWidget {
  const StudentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _dummyStudents.length,
      itemBuilder: (context, index) {
        final student = _dummyStudents[index];
        return StudentCard(
          student: student,
          onTap: () => print('Tapped on: ${student.name}'),
        );
      },
    );
  }
}

class StudentCard extends StatelessWidget {
  final StudentMock student;
  final VoidCallback onTap;

  const StudentCard({super.key, required this.student, required this.onTap});

  Color? _gpaColor(double gpa) {
    if (gpa >= 3.2) {
      return Colors.green.shade700;
    }
    if (gpa < 2.0) {
      return Colors.red.shade700;
    }
    return null;
  }

  Color _statusBackgroundColor(String status) {
    switch (status) {
      case 'Đang học':
        return Colors.green.shade100;
      case 'Bảo lưu':
        return Colors.amber.shade100;
      case 'Cảnh báo':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'Đang học':
        return Colors.green.shade800;
      case 'Bảo lưu':
        return Colors.amber.shade900;
      case 'Cảnh báo':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gpaColor = _gpaColor(student.gpa);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                foregroundImage: NetworkImage(student.avatarUrl),
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.major,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'GPA: ${student.gpa.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: gpaColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBackgroundColor(student.status),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      student.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusTextColor(student.status),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
