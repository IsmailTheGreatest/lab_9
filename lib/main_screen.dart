import 'package:flutter/material.dart';
import 'db_helper.dart';

class main_screen extends StatelessWidget {
  const main_screen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Information',
      theme: ThemeData(
        primaryColor: const Color(0xffccd5f0), // Background color
        hintColor: const Color(0xff350f9c), // Text color
        scaffoldBackgroundColor: const Color(0xffccd5f0), // Background color for scaffold
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  List<User> allUsers = []; // List to hold all users
  List<User> displayedUsers = []; // List to hold displayed users after search
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch all users when the screen loads
  }

  Future<void> _fetchUsers() async {
    // Fetch all users from DBHelper
    DBHelper dbHelper = DBHelper();
    List<User> fetchedUsers = (await dbHelper.getAllUsers('users.db')).cast<User>();

    setState(() {
      allUsers = fetchedUsers;
      displayedUsers = allUsers; // Initially, display all users
    });
  }

  void _searchUser(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedUsers = allUsers;
      } else {
        displayedUsers = allUsers
            .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchUser,
          decoration: InputDecoration(
            hintText: 'Search by username',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchUser('');
              },
            ),
          ),
        ),
      ),
      body: displayedUsers.isEmpty
          ? const Center(child: Text('No users found'))
          : ListView.builder(
        itemCount: displayedUsers.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 2.0,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: ${displayedUsers[index].username}',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    'Email: ${displayedUsers[index].email}',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    'Phone: ${displayedUsers[index].phone}',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    'Address: ${displayedUsers[index].address}',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  // Add more user details here as needed
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

