import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_data.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState
    extends State<AddStudentScreen> {
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final fatherController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? studentImage;

  String department = 'Computer Science';
  String semester = '1st Semester';
  String status = 'Active';

  final semesterList = const [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  final statusList = const [
    'Active',
    'Inactive',
  ];

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        studentImage = File(image.path);
      });
    }
  }

  void saveStudent() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final student = <String, dynamic>{
      'id': idController.text.trim(),
      'name': nameController.text.trim(),
      'father': fatherController.text.trim(),
      'department': department,
      'semester': semester,
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'status': status,
      'imagePath': studentImage?.path,
    };

    Navigator.pop(context, student);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    fatherController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  InputDecoration decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final departments = AppData.instance.departments;

    if (departments.isNotEmpty &&
        !departments.contains(department)) {
      department = departments.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Student',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                      backgroundImage:
                          studentImage != null
                              ? FileImage(
                                  studentImage!,
                                )
                              : null,
                      child: studentImage == null
                          ? Icon(
                              Icons.person,
                              size: 65,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            )
                          : null,
                    ),
                    CircleAvatar(
                      radius: 19,
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .primary,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Tap to add student photo',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 28),

              TextFormField(
                controller: idController,
                decoration: decoration(
                  'Student ID',
                  Icons.badge_outlined,
                ),
                validator: requiredValidator,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                decoration: decoration(
                  'Student Name',
                  Icons.person_outline,
                ),
                validator: requiredValidator,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: fatherController,
                decoration: decoration(
                  'Father Name',
                  Icons.family_restroom,
                ),
                validator: requiredValidator,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: department,
                decoration: decoration(
                  'Department',
                  Icons.school_outlined,
                ),
                items: departments
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      department = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: semester,
                decoration: decoration(
                  'Semester',
                  Icons.menu_book_outlined,
                ),
                items: semesterList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      semester = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: decoration(
                  'Status',
                  Icons.toggle_on_outlined,
                ),
                items: statusList
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      status = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: decoration(
                  'Phone Number',
                  Icons.phone_outlined,
                ),
                validator: requiredValidator,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: decoration(
                  'Email',
                  Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter email';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  onPressed: saveStudent,
                  icon: const Icon(
                    Icons.save_outlined,
                  ),
                  label: const Text(
                    'Save Student',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}