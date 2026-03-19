import 'package:flutter/material.dart';
import '../models/student_model.dart';

class SearchFilterWidget extends StatefulWidget {
  const SearchFilterWidget({super.key, this.students, this.onFiltered});

  final List<Student>? students;
  final ValueChanged<List<Student>>? onFiltered;

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  // Tag bây giờ chỉ dùng cho Trạng thái học tập
  static const List<String> _statusTags = [
    'Tất cả',
    'Đang học',
    'Cảnh báo',
    'Bảo lưu',
  ];

  final TextEditingController _searchController = TextEditingController();

  List<Student> _baseStudents = [];
  List<Student> _filteredStudents = <Student>[];
  
  String _selectedStatus = 'Tất cả';
  String _selectedMajor = 'Tất cả các lớp'; // Biến mới để lưu Lớp/Ngành đang chọn

  @override
  void initState() {
    super.initState();
    _baseStudents = widget.students ?? _dummyStudents;
    _filteredStudents = List<Student>.from(_baseStudents);
  }

  @override
  void didUpdateWidget(SearchFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.students != oldWidget.students) {
      _baseStudents = widget.students ?? _dummyStudents;
      
      // Chốt chặn an toàn: Nếu lớp đang chọn bị xoá hết SV, tự quay về 'Tất cả'
      if (!_availableMajors.contains(_selectedMajor)) {
        _selectedMajor = 'Tất cả các lớp';
      }
      _applyFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Tự động rút trích danh sách các Lớp/Ngành không trùng lặp từ dữ liệu
  List<String> get _availableMajors {
    final majors = _baseStudents.map((s) => s.major).toSet().toList();
    majors.sort(); // Xếp theo bảng chữ cái A-Z cho đẹp
    majors.insert(0, 'Tất cả các lớp'); // Thêm tuỳ chọn mặc định lên đầu
    return majors;
  }

  // Hàm chuẩn hóa chuỗi tiếng Việt (Giữ nguyên như cũ)
  String _normalize(String text) {
    String str = text.toLowerCase().trim();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'[đ]'), 'd');
    return str;
  }

  // Lọc gộp chung cả 3 điều kiện: Tên + Trạng Thái + Lớp
  void _applyFilters() {
    final normalizedSearch = _normalize(_searchController.text);
    final normalizedStatus = _normalize(_selectedStatus);

    final filtered = _baseStudents.where((student) {
      // 1. Kiểm tra Tên
      final matchName = normalizedSearch.isEmpty || 
                        _normalize(student.name).contains(normalizedSearch);

      // 2. Kiểm tra Trạng thái
      final matchStatus = _selectedStatus == 'Tất cả' || 
                          _normalize(student.status).contains(normalizedStatus);

      // 3. Kiểm tra Lớp/Ngành
      final matchMajor = _selectedMajor == 'Tất cả các lớp' || 
                         student.major == _selectedMajor;

      // Phải thoả mãn cả 3 điều kiện mới được hiện ra
      return matchName && matchStatus && matchMajor;
    }).toList();

    setState(() {
      _filteredStudents = filtered;
    });

    widget.onFiltered?.call(_filteredStudents);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hàng 1: Thanh tìm kiếm + Dropdown chọn lớp
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilters(),
                decoration: InputDecoration(
                  hintText: 'Tìm tên...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedMajor,
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                    items: _availableMajors.map((String major) {
                      return DropdownMenuItem<String>(
                        value: major,
                        child: Text(
                          major,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis, // Cắt chữ nếu tên lớp quá dài
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedMajor = newValue;
                        });
                        _applyFilters();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Hàng 2: Nút lọc Trạng thái
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _statusTags.map((tag) {
            final isSelected = tag == _selectedStatus;

            return ActionChip(
              label: Text(
                tag,
                style: TextStyle(
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              backgroundColor: isSelected
                  ? Colors.blue.shade100
                  : Colors.grey.shade200,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                setState(() {
                  _selectedStatus = tag;
                });
                _applyFilters();
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Dummy data phòng hờ khi chưa có API
const List<Student> _dummyStudents = [
  Student(id: 'SV001', name: 'Nguyen Minh Anh', avatar: 'https://i.pravatar.cc/150?img=12', major: 'HTTT', gpa: 3.67, status: 'Đang học'),
];