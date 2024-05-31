import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class User {
  final int id;
  final String firstName;
  final String lastName;
  final String about;
  final String image;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.about,
    required this.image,
  });

  String get fullName => '$firstName $lastName';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late List<User> userList;
  late Map<int, User> userCache;

  @override
  void initState() {
    super.initState();
    userList = [];
    userCache = {};
    loadUserList();
  }

  Future<void> loadUserList() async {
    try {
      String jsonString = await rootBundle.loadString('assets/users.json');
      List<dynamic> jsonList = json.decode(jsonString);

      userList = jsonList.map((json) {
        int id = json['id'];
        return User(
          id: id,
          firstName: '',
          lastName: '',
          about: '',
          image: '',
        );
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error loading user list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          User user = userList[index];
          return ListTile(
            title: Text(user.fullName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(userId: user.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
  final int userId;

  const UserDetailsScreen({required this.userId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<User?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUserById(widget.userId);
  }

  Future<User?> getUserById(int id) async {
    var userCache;
    if (userCache.containsKey(id)) {
      return userCache[id];
    } else {
      User? user;
      try {
        String jsonString = await rootBundle.loadString('assets/users.json');
        List<dynamic> jsonList = json.decode(jsonString);

        jsonList.forEach((json) {
          if (json['id'] == id) {
            user = User(
              id: id,
              firstName: json['first_name'],
              lastName: json['last_name'],
              about: json['about'],
              image: json['image'],
            );
          }
        });

        if (user != null) {
          userCache[id] = user!;
        }
      } catch (e) {
        print('Error fetching user information: $e');
      }

      return user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<User?>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user details'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(user.image),
                  SizedBox(height: 16.0),
                  Text(
                    user.fullName,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(user.about),
                ],
              ),
            );
          } else {
            return Center(child: Text('User not found'));
          }
        },
      ),
    );
  }
}