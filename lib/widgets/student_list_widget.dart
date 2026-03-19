import 'package:flutter/material.dart';
import '../models/student_model.dart'; // Gọi model thật vào

class StudentCard extends StatelessWidget {
  final Student student; // Thay đổi từ StudentMock sang Student
  final VoidCallback onTap;
  final VoidCallback onEdit;      // THÊM MỚI
  final VoidCallback onDelete;

  const StudentCard({super.key, required this.student, required this.onTap,required this.onEdit,required this.onDelete});

  Color? _gpaColor(double gpa) {
    if (gpa >= 3.2) return Colors.green.shade700;
    if (gpa < 2.0) return Colors.red.shade700;
    return null;
  }

  Color _statusBackgroundColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('đang học') || value.contains('active')) {
      return Colors.green.shade100;
    }
    if (value.contains('bảo lưu')) {
      return Colors.amber.shade100;
    }
    if (value.contains('cảnh báo')) {
      return Colors.red.shade100;
    }
    return Colors.grey.shade200;
  }

  Color _statusTextColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('đang học') || value.contains('active')) {
      return Colors.green.shade800;
    }
    if (value.contains('bảo lưu')) {
      return Colors.amber.shade900;
    }
    if (value.contains('cảnh báo')) {
      return Colors.red.shade800;
    }
    return Colors.grey.shade800;
  }

  @override
  Widget build(BuildContext context) {
    final gpaColor = _gpaColor(student.gpa);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                foregroundImage: NetworkImage(student.avatar),
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(student.major, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              
              // KHU VỰC ĐIỂM SỐ & TRẠNG THÁI
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('GPA: ${student.gpa.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: gpaColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: _statusBackgroundColor(student.status), borderRadius: BorderRadius.circular(999)),
                    child: Text(student.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusTextColor(student.status))),
                  ),
                ],
              ),

              // THÊM MỚI: Menu 3 chấm (Sửa / Xóa)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text('Sửa')])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Xoá')])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}