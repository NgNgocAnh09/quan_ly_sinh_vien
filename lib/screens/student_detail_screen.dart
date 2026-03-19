import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  Color _getStatusColor(String status) {
    final value = status.toLowerCase();

    if (value.contains('tot') ||
        value.contains('gioi') ||
        value.contains('active') ||
        value.contains('hoat dong')) {
      return Colors.green;
    }

    if (value.contains('canh bao') ||
        value.contains('warning') ||
        value.contains('yeu')) {
      return Colors.orange;
    }

    if (value.contains('ngung') ||
        value.contains('inactive') ||
        value.contains('khong hoat dong')) {
      return Colors.red;
    }

    return Colors.blueGrey;
  }

  Color _getGpaColor(double gpa) {
    if (gpa > 3.2) return Colors.green;
    if (gpa < 2.0) return Colors.red;
    return Colors.orange;
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x14000000),
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade50,
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(student.status);
    final gpaColor = _getGpaColor(student.gpa);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Chi tiết sinh viên'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.blue.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 14,
                    color: Color(0x22000000),
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(student.avatar),
                      onBackgroundImageError: (_, _) {},
                      child: student.avatar.isEmpty
                          ? const Icon(Icons.person, size: 48)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    student.major,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Mã sinh viên: ${student.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
              icon: Icons.school,
              title: 'Ngành học',
              value: student.major,
            ),
            _buildInfoCard(
              icon: Icons.bar_chart,
              title: 'Điểm GPA',
              value: student.gpa.toStringAsFixed(2),
              valueColor: gpaColor,
            ),
            _buildInfoCard(
              icon: Icons.verified_user,
              title: 'Trạng thái',
              value: student.status,
              valueColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }
}