// lib/providers/employee_provider.dart
import 'package:flutter/material.dart';

import '../model/employee.dart';

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [
    Employee(id: 1, name: 'John Doe', department: 'HR', project: 'Recruitment', salary: 50000),
    Employee(id: 2, name: 'Jane Smith', department: 'IT', project: 'App Development', salary: 80000),
  ];

  List<Employee> get employees => _employees;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void updateEmployee(int id, String newName, double newSalary) {
    final index = _employees.indexWhere((emp) => emp.id == id);
    if (index != -1) {
      _employees[index].name = newName;
      _employees[index].salary = newSalary;
      notifyListeners();
    }
  }
}
