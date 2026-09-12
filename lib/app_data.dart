import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  AppData._privateConstructor();

  static final AppData instance = AppData._privateConstructor();

  final List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Software Engineering',
    'Electrical Engineering',
    'Business Administration',
    'English',
  ];

  final List<Map<String, dynamic>> students = [
    {
      'id': 'CS-001',
      'name': 'Ali Ahmed',
      'father': 'Ahmed Khan',
      'department': 'Computer Science',
      'semester': '3rd Semester',
      'phone': '03001234567',
      'email': 'ali@example.com',
      'status': 'Active',
      'imagePath': null,
    },
    {
      'id': 'IT-002',
      'name': 'Sara Khan',
      'father': 'Khalid Khan',
      'department': 'Information Technology',
      'semester': '2nd Semester',
      'phone': '03007654321',
      'email': 'sara@example.com',
      'status': 'Active',
      'imagePath': null,
    },
    {
      'id': 'SE-003',
      'name': 'Usman Ali',
      'father': 'Muhammad Ali',
      'department': 'Software Engineering',
      'semester': '4th Semester',
      'phone': '03111234567',
      'email': 'usman@example.com',
      'status': 'Inactive',
      'imagePath': null,
    },
  ];

  int get totalStudents => students.length;

  int get totalDepartments => departments.length;

  int get activeStudents {
    return students.where((student) {
      return student['status'] == 'Active';
    }).length;
  }

  int get inactiveStudents {
    return students.where((student) {
      return student['status'] == 'Inactive';
    }).length;
  }

  void addStudent(Map<String, dynamic> student) {
    students.add(student);
    notifyListeners();
  }

  void updateStudent(int index, Map<String, dynamic> student) {
    students[index] = student;
    notifyListeners();
  }

  void deleteStudent(int index) {
    students.removeAt(index);
    notifyListeners();
  }

  void addDepartment(String department) {
    final name = department.trim();

    if (name.isEmpty) return;

    if (departments.any(
      (item) => item.toLowerCase() == name.toLowerCase(),
    )) {
      return;
    }

    departments.add(name);
    notifyListeners();
  }

  bool deleteDepartment(String department) {
    final hasStudents = students.any(
      (student) => student['department'] == department,
    );

    if (hasStudents) {
      return false;
    }

    departments.remove(department);
    notifyListeners();
    return true;
  }
}