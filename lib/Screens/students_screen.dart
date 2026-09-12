import 'dart:io';
import 'package:flutter/material.dart';
import '../app_data.dart';
import 'add_student_screen.dart';
import 'student_details_screen.dart';
import 'edit_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  final String? selectedDepartment;

  const StudentsScreen({
    super.key,
    this.selectedDepartment,
  });

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final searchController = TextEditingController();

  String selectedDepartment = 'All';

  final appData = AppData.instance;

  @override
  void initState() {
    super.initState();

    if (widget.selectedDepartment != null) {
      selectedDepartment = widget.selectedDepartment!;
    }

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<String> get departmentFilters {
    return [
      'All',
      ...appData.departments,
    ];
  }

  List<Map<String, dynamic>> get filteredStudents {
    final query = searchController.text.trim().toLowerCase();

    return appData.students.where((student) {
      final matchesSearch =
          student['name'].toString().toLowerCase().contains(query) ||
          student['id'].toString().toLowerCase().contains(query) ||
          student['department']
              .toString()
              .toLowerCase()
              .contains(query);

      final matchesDepartment =
          selectedDepartment == 'All' ||
          student['department'] == selectedDepartment;

      return matchesSearch && matchesDepartment;
    }).toList();
  }

  Future<void> addStudent() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddStudentScreen(),
      ),
    );

    if (result != null) {
      appData.addStudent(result);
      setState(() {});
    }
  }

  Future<void> editStudent(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditStudentScreen(
          student: Map<String, dynamic>.from(
            appData.students[index],
          ),
        ),
      ),
    );

    if (result != null) {
      appData.updateStudent(index, result);
      setState(() {});
    }
  }

  Future<void> showStudentDetails(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailsScreen(
          student: Map<String, dynamic>.from(
            appData.students[index],
          ),
        ),
      ),
    );

    if (result != null) {
      appData.updateStudent(index, result);
      setState(() {});
    }
  }

  void deleteStudent(int index) {
    final student = appData.students[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Student?'),
          content: Text(
            'Are you sure you want to delete ${student['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                appData.deleteStudent(index);

                Navigator.pop(dialogContext);

                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student deleted successfully.'),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget studentAvatar(Map<String, dynamic> student) {
    final imagePath = student['imagePath'];

    if (imagePath != null &&
        imagePath.toString().isNotEmpty &&
        File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: FileImage(
          File(imagePath),
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      child: Text(
        student['name']
                .toString()
                .trim()
                .isNotEmpty
            ? student['name']
                .toString()
                .trim()[0]
                .toUpperCase()
            : '?',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredStudents;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Students',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addStudent,
        icon: const Icon(
          Icons.person_add_alt_1,
        ),
        label: const Text('Add Student'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search student...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),

          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: departmentFilters.length,
              itemBuilder: (context, index) {
                final department =
                    departmentFilters[index];

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: ChoiceChip(
                    label: Text(department),
                    selected:
                        selectedDepartment == department,
                    onSelected: (_) {
                      setState(() {
                        selectedDepartment =
                            department;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No students found',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      100,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final student = filtered[index];

                      final originalIndex =
                          appData.students.indexOf(
                        student,
                      );

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(10),
                          leading:
                              studentAvatar(student),
                          title: Text(
                            student['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${student['id']} • ${student['department']}',
                          ),
                          onTap: () {
                            showStudentDetails(
                              originalIndex,
                            );
                          },
                          trailing:
                              PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                editStudent(
                                  originalIndex,
                                );
                              } else if (value ==
                                  'delete') {
                                deleteStudent(
                                  originalIndex,
                                );
                              }
                            },
                            itemBuilder: (_) =>
                                const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}