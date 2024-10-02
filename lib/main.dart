// lib/main.dart
import 'package:demoproject2_10/provider/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmployeeProvider(),
      child: MaterialApp(
        title: 'Employee POC',
        home: EmployeeScreen(),
      ),
    );
  }
}

class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: EmployeeTable(),
          ),
          EmployeeForm(),
        ],
      ),
    );
  }
}

class EmployeeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<EmployeeProvider>(context).employees;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('Project')),
          DataColumn(label: Text('Salary')),
          DataColumn(label: Text('Actions')),
        ],
        rows: employees
            .map(
              (emp) => DataRow(cells: [
            DataCell(Text(emp.id.toString())),
            DataCell(Text(emp.name)),
            DataCell(Text(emp.department)),
            DataCell(Text(emp.project)),
            DataCell(Text(emp.salary.toString())),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => UpdateEmployeeDialog(employee: emp),
                    );
                  },
                ),
              ],
            )),
          ]),
        )
            .toList(),
      ),
    );
  }
}

class EmployeeForm extends StatefulWidget {
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _projectController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Employee',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _departmentController,
            decoration: InputDecoration(labelText: 'Department'),
          ),
          TextField(
            controller: _projectController,
            decoration: InputDecoration(labelText: 'Project'),
          ),
          TextField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Salary'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final department = _departmentController.text;
              final project = _projectController.text;
              final salary = double.parse(_salaryController.text);

              Provider.of<EmployeeProvider>(context, listen: false)
                  .addEmployee(Employee(
                id: DateTime.now().millisecondsSinceEpoch,
                name: name,
                department: department,
                project: project,
                salary: salary,
              ));
              _nameController.clear();
              _departmentController.clear();
              _projectController.clear();
              _salaryController.clear();
            },
            child: Text('Add Employee'),
          ),
        ],
      ),
    );
  }
}

class UpdateEmployeeDialog extends StatefulWidget {
  final Employee employee;

  UpdateEmployeeDialog({required this.employee});

  @override
  _UpdateEmployeeDialogState createState() => _UpdateEmployeeDialogState();
}

class _UpdateEmployeeDialogState extends State<UpdateEmployeeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _salaryController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.employee.name);
    _salaryController = TextEditingController(text: widget.employee.salary.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Employee'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Salary'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final newName = _nameController.text;
            final newSalary = double.parse(_salaryController.text);

            Provider.of<EmployeeProvider>(context, listen: false)
                .updateEmployee(widget.employee.id, newName, newSalary);

            Navigator.of(context).pop();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
