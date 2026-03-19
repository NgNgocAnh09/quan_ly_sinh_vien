import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/api_service.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/student_list_widget.dart'; // Nơi chứa StudentCard đã được cập nhật
import 'student_detail_screen.dart';
import 'student_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Quản lý 2 luồng dữ liệu: Gốc và Đã lọc
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Lấy dữ liệu từ API do Thành viên 1 cung cấp
  Future<void> _fetchData() async {
    try {
      final students = await ApiService().fetchStudents();
      setState(() {
        _allStudents = students;
        _filteredStudents = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }



  // Hàm hứng dữ liệu đã lọc từ Thành viên 4
  void _handleFilteredStudents(List<Student> filtered) {
    setState(() {
      _filteredStudents = filtered;
    });
  }

  // Hàm điều hướng sang màn hình Chi tiết của Thành viên 3
  void _navigateToDetail(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailScreen(student: student),
      ),
    );
  }
 
 Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentFormScreen()),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      await ApiService().addStudent(result); // Gọi API thêm
      await _fetchData(); // Tải lại danh sách mới nhất
      if (!mounted) return; // Kiểm tra nếu widget đã bị hủy
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm sinh viên thành công!')));
    }
  }

  // THÊM MỚI: Xử lý Sửa SV
  Future<void> _navigateToEdit(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentFormScreen(student: student)),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      await ApiService().updateStudent(student.id, result); // Gọi API sửa
      await _fetchData(); 
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật thông tin!')));
    }
  }

  // THÊM MỚI: Xử lý Xóa SV (Có xác nhận)
  Future<void> _deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text('Bạn có chắc muốn xoá sinh viên ${student.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Xoá', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await ApiService().deleteStudent(student.id); // Gọi API xóa
      await _fetchData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá sinh viên!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Danh sách Sinh viên'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchFilterWidget(
            students: _allStudents,
            onFiltered: _handleFilteredStudents,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredStudents.length,
            itemBuilder: (context, index) {
              final student = _filteredStudents[index];
              return StudentCard(
                student: student,
                onTap: () => _navigateToDetail(student),
                // Truyền 2 hàm mới vào thẻ
                onEdit: () => _navigateToEdit(student),
                onDelete: () => _deleteStudent(student),
              );
            },
          ),
        ),
      ],
    );
  }
}