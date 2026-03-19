import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student; // Nếu null -> Thêm mới. Nếu có data -> Sửa.

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _gpaController;
  
  String _selectedMajor = 'Hệ thống thông tin';
  String _selectedStatus = 'Đang học';

  final List<String> _majors = ['Hệ thống thông tin', 'Kế toán', 'Marketing', 'Quản trị KD'];
  final List<String> _statuses = ['Đang học', 'Cảnh báo', 'Bảo lưu'];

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị (nếu là chế độ Sửa thì điền sẵn data cũ)
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _avatarController = TextEditingController(text: widget.student?.avatar ?? 'https://i.pravatar.cc/150');
    _gpaController = TextEditingController(text: widget.student?.gpa.toString() ?? '');
    
    if (widget.student != null) {
      if (_majors.contains(widget.student!.major)) _selectedMajor = widget.student!.major;
      if (_statuses.contains(widget.student!.status)) _selectedStatus = widget.student!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Đóng gói dữ liệu trả về màn hình trước
      final studentData = {
        'name': _nameController.text.trim(),
        'avatar': _avatarController.text.trim(),
        'major': _selectedMajor,
        'status': _selectedStatus,
        'gpa': double.parse(_gpaController.text.trim()),
      };
      Navigator.pop(context, studentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa Sinh Viên' : 'Thêm Sinh Viên'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Họ và tên', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _gpaController,
              decoration: const InputDecoration(labelText: 'Điểm GPA (0 - 4)', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Vui lòng nhập GPA';
                final gpa = double.tryParse(value);
                if (gpa == null || gpa < 0 || gpa > 4) return 'GPA không hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedMajor,
              decoration: const InputDecoration(labelText: 'Ngành học', border: OutlineInputBorder()),
              items: _majors.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) => setState(() => _selectedMajor = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Trạng thái', border: OutlineInputBorder()),
              items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _selectedStatus = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _submitForm,
              child: Text(isEditing ? 'CẬP NHẬT' : 'THÊM MỚI', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}