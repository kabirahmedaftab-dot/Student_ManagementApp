import 'package:flutter/material.dart';
import '../app_data.dart';
import 'students_screen.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  void showAddDepartmentDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add Department',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Department Name',
              prefixIcon: Icon(Icons.school_outlined),
            ),
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
                final name = controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final appData = AppData.instance;

                final alreadyExists = appData.departments.any(
                  (department) =>
                      department.toLowerCase() == name.toLowerCase(),
                );

                if (alreadyExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This department already exists.',
                      ),
                    ),
                  );
                  return;
                }

                appData.addDepartment(name);

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$name department added successfully.',
                    ),
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteDepartment(
    BuildContext context,
    String department,
  ) {
    final appData = AppData.instance;

    final hasStudents = appData.students.any(
      (student) => student['department'] == department,
    );

    if (hasStudents) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cannot delete this department because students are assigned to it.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Department?'),
          content: Text(
            'Are you sure you want to delete "$department"?',
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
                appData.deleteDepartment(department);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Department deleted.'),
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

  @override
  Widget build(BuildContext context) {
    final appData = AppData.instance;

    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Departments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showAddDepartmentDialog(context);
                },
                icon: const Icon(Icons.add),
                tooltip: 'Add Department',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showAddDepartmentDialog(context);
            },
            icon: const Icon(Icons.add_business),
            label: const Text('Add Department'),
          ),
          body: appData.departments.isEmpty
              ? const Center(
                  child: Text(
                    'No departments added yet.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ),
                  itemCount: appData.departments.length,
                  itemBuilder: (context, index) {
                    final department = appData.departments[index];

                    final studentCount = appData.students
                        .where(
                          (student) =>
                              student['department'] == department,
                        )
                        .length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            Icons.school_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                        title: Text(
                          department,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$studentCount students',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudentsScreen(
                                    selectedDepartment: department,
                                  ),
                                ),
                              );
                            }

                            if (value == 'delete') {
                              deleteDepartment(
                                context,
                                department,
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'view',
                              child: Text('View Students'),
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
        );
      },
    );
  }
}