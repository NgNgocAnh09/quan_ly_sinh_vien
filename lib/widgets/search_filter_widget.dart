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
  static const List<String> _tags = [
    'Tat ca',
    'HTTT',
    'Dang hoc',
    'Canh bao',
    'Bao luu',
  ];

  final TextEditingController _searchController = TextEditingController();

  late final List<Student> _baseStudents;
  List<Student> _filteredStudents = <Student>[];
  String _selectedTag = 'Tat ca';

  @override
  void initState() {
    super.initState();
    _baseStudents = widget.students ?? _dummyStudents;
    _filteredStudents = List<Student>.from(_baseStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Loc theo ten sinh vien, dung where() nhu yeu cau.
  List<Student> filterByName(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return List<Student>.from(_baseStudents);
    }

    return _baseStudents
        .where(
          (student) => student.name.toLowerCase().contains(normalizedQuery),
        )
        .toList();
  }

  // Loc theo tag (status/major), dung where() nhu yeu cau.
  List<Student> filterByTag(String tag) {
    final normalizedTag = tag.trim().toLowerCase();
    if (normalizedTag.isEmpty || normalizedTag == 'tat ca') {
      return List<Student>.from(_baseStudents);
    }

    if (normalizedTag == 'httt') {
      return _baseStudents
          .where((student) => student.major.toLowerCase().contains('httt'))
          .toList();
    }

    return _baseStudents
        .where(
          (student) => student.status.toLowerCase().contains(normalizedTag),
        )
        .toList();
  }

  void _applyFilters() {
    final byName = filterByName(_searchController.text);
    final byTag = filterByTag(_selectedTag);

    final filtered = byName
        .where((student) => byTag.any((tagMatch) => tagMatch.id == student.id))
        .toList();

    setState(() {
      _filteredStudents = filtered;
    });

    widget.onFiltered?.call(_filteredStudents);

    // Console test de xac nhan logic loc dung.
    debugPrint(
      'Search="${_searchController.text}", tag="$_selectedTag" => ${_filteredStudents.length} result(s): '
      '${_filteredStudents.map((student) => student.name).join(', ')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) => _applyFilters(),
          decoration: InputDecoration(
            hintText: 'Tim theo ten sinh vien...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _tags.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final tag = _tags[index];
              final isSelected = tag == _selectedTag;

              return ActionChip(
                label: Text(tag),
                backgroundColor: isSelected
                    ? Colors.blue.shade100
                    : Colors.grey.shade200,
                onPressed: () {
                  setState(() {
                    _selectedTag = tag;
                  });
                  _applyFilters();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

const List<Student> _dummyStudents = [
  Student(
    id: 'SV001',
    name: 'Nguyen Minh Anh',
    avatar: 'https://i.pravatar.cc/150?img=12',
    major: 'HTTT',
    gpa: 3.67,
    status: 'Dang hoc',
  ),
  Student(
    id: 'SV002',
    name: 'Tran Gia Bao',
    avatar: 'https://i.pravatar.cc/150?img=24',
    major: 'Ke toan',
    gpa: 2.54,
    status: 'Dang hoc',
  ),
  Student(
    id: 'SV003',
    name: 'Le Hoang Phuc',
    avatar: 'https://i.pravatar.cc/150?img=35',
    major: 'HTTT',
    gpa: 1.92,
    status: 'Canh bao',
  ),
  Student(
    id: 'SV004',
    name: 'Pham Quynh Nhu',
    avatar: 'https://i.pravatar.cc/150?img=41',
    major: 'Marketing',
    gpa: 3.21,
    status: 'Bao luu',
  ),
];
