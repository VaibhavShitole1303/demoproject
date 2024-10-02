// lib/models/employee.dart
class Employee {
  final int id;
  String name;
  String department;
  String project;
  double salary;

  Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.project,
    required this.salary,
  });
}
