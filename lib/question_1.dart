import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class Company {
  final bool isActive;
  final String name;
  final Address address;
  final DateTime established;
  final List<Department> departments;

  Company({
    required this.isActive,
    required this.name,
    required this.address,
    required this.established,
    required this.departments,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    final addressJson = json['address'] as Map<String, dynamic>;
    final departmentsJson = json['departments'] as List<dynamic>;

    return Company(
      isActive: json['is_active'] == 1,
      name: json['name'],
      address: Address.fromJson(addressJson),
      established: DateTime.parse(json['established']).toUtc(),
      departments: departmentsJson.map((deptJson) => Department.fromJson(deptJson)).toList(),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String postalCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
    );
  }
}

class Department {
  final String deptId;
  final String name;
  final String manager;
  final double budget;
  final int year;
  final Availability availability;
  final String meetingTime;

  Department({
    required this.deptId,
    required this.name,
    required this.manager,
    required this.budget,
    required this.year,
    required this.availability,
    required this.meetingTime,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    final availabilityJson = json['availability'] as Map<String, dynamic>;

    return Department(
      deptId: json['deptId'],
      name: json['name'],
      manager: json['manager'],
      budget: json['budget'].toDouble(),
      year: json['year'],
      availability: Availability.fromJson(availabilityJson),
      meetingTime: json['meeting_time'],
    );
  }
}

class Availability {
  final bool online;
  final bool inStore;

  Availability({
    required this.online,
    required this.inStore,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      online: json['online'],
      inStore: json['inStore'],
    );
  }
}

void main() {
  final json = {
    "company": {
      "is_active": 0,
      "name": "Tech Innovators Inc.",
      "address": {
        "street": "123 Innovation Drive",
        "city": "Techville",
        "state": "CA",
        "postalCode": "94043"
      },
      "established": "2023-05-24T00:00:00Z",
      "departments": [
        {
          "deptId": "D001",
          "name": "Engineering",
          "manager": "Carol Davis",
          "budget": 500000.00,
          "year": 2023,
          "availability": {
            "online": true,
            "inStore": false
          },
          "meeting_time": "14:30"
        },
        {
          "deptId": "D002",
          "name": "Marketing",
          "manager": "David Wilson",
          "budget": 300000.00,
          "year": 2023,
          "availability": {
            "online": true,
            "inStore": true
          },
          "meeting_time": "10:00 AM"
        }
      ]
    }
  };

  final companyJson = json['company'];
  final company = Company.fromJson(companyJson!);

  print('Company Name: ${company.name}');
  print('Active: ${company.isActive}');
  print('Established: ${DateFormat('yyyy-MM-dd').format(company.established)}');
  print('Address: ${company.address.street}, ${company.address.city}, ${company.address.state}, ${company.address.postalCode}');

  print('Departments:');
  for (final department in company.departments) {
    print('---');
    print('Department ID: ${department.deptId}');
    print('Name: ${department.name}');
    print('Manager: ${department.manager}');
    print('Budget: \$${department.budget}');
    print('Year: ${department.year}');
    print('Availability: Online - ${department.availability.online}, In-store - ${department.availability.inStore}');
    print('Meeting Time: ${department.meetingTime}');
  }

  runApp(const MyApp());
}