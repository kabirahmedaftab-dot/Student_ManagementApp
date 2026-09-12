import 'dart:io';
import 'package:flutter/material.dart';
import 'edit_student_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {
  late Map<String, dynamic> student;

  @override
  void initState() {
    super.initState();

    student = Map<String, dynamic>.from(
      widget.student,
    );
  }

  Future<void> editStudent() async {
    final result =
        await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditStudentScreen(
          student: Map<String, dynamic>.from(
            student,
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        student = result;
      });

      Navigator.pop(context, result);
    }
  }

  Widget buildPhoto() {
    final imagePath = student['imagePath'];

    if (imagePath != null &&
        imagePath.toString().isNotEmpty &&
        File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 65,
        backgroundImage: FileImage(
          File(imagePath),
        ),
      );
    }

    return CircleAvatar(
      radius: 65,
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
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: editStudent,
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildPhoto(),

            const SizedBox(height: 18),

            Text(
              student['name'],
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              student['id'],
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),

            _infoCard(
              Icons.person_outline,
              'Student Name',
              student['name'],
            ),

            _infoCard(
              Icons.badge_outlined,
              'Student ID',
              student['id'],
            ),

            _infoCard(
              Icons.family_restroom,
              'Father Name',
              student['father'],
            ),

            _infoCard(
              Icons.school_outlined,
              'Department',
              student['department'],
            ),

            _infoCard(
              Icons.menu_book_outlined,
              'Semester',
              student['semester'],
            ),

            _infoCard(
              Icons.toggle_on_outlined,
              'Status',
              student['status'],
            ),

            _infoCard(
              Icons.phone_outlined,
              'Phone',
              student['phone'],
            ),

            _infoCard(
              Icons.email_outlined,
              'Email',
              student['email'],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: editStudent,
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Student',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}