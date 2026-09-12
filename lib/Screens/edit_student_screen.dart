import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_data.dart';

class EditStudentScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const EditStudentScreen({
    super.key,
    required this.student,
  });

  @override
  State<EditStudentScreen> createState() =>
      _EditStudentScreenState();
}

class _EditStudentScreenState
    extends State<EditStudentScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController fatherController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final ImagePicker picker = ImagePicker();

  File? studentImage;

  late String department;
  late String semester;
  late String status;

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

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(
      text: widget.student['id']?.toString() ?? '',
    );

    nameController = TextEditingController(
      text: widget.student['name']?.toString() ?? '',
    );

    fatherController = TextEditingController(
      text: widget.student['father']?.toString() ?? '',
    );

    phoneController = TextEditingController(
      text: widget.student['phone']?.toString() ?? '',
    );

    emailController = TextEditingController(
      text: widget.student['email']?.toString() ?? '',
    );

    department =
        widget.student['department']?.toString() ??
            AppData.instance.departments.first;

    semester =
        widget.student['semester']?.toString() ??
            '1st Semester';

    status =
        widget.student['status']?.toString() ??
            'Active';

    final imagePath = widget.student['imagePath'];

    if (imagePath != null &&
        imagePath.toString().isNotEmpty &&
        File(imagePath).existsSync()) {
      studentImage = File(imagePath);
    }
  }

  Future<void> changePhoto() async {
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

  void updateStudent() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final updatedStudent = <String, dynamic>{
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

    Navigator.pop(context, updatedStudent);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Student',
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
                onTap: changePhoto,
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
                'Tap to change photo',
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
                  onPressed: updateStudent,
                  icon: const Icon(
                    Icons.save_outlined,
                  ),
                  label: const Text(
                    'Update Student',
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