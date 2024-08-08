import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<User> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('id_user');

    if (idUser == null) {
      throw Exception('User not logged in');
    }

    final response = await http.get(
      Uri.parse('http://192.168.206.111/cekginjal/get_user_data.php?id_user=$idUser'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return User.fromJson(data['data']);
      } else {
        throw Exception('Failed to load user data: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _updateUserData(String field, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('id_user');

    if (idUser == null) {
      throw Exception('User not logged in');
    }

    final response = await http.post(
      Uri.parse('http://192.168.206.111/cekginjal/update_user_data.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_user': idUser,
        'field': field,
        'value': newValue,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _userFuture = _fetchUserData();
        });
      } else {
        throw Exception('Failed to update user data: ${data['message']}');
      }
    } else {
      throw Exception('Failed to update user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: CurvedPainter(),
            child: Center(
              child: FutureBuilder<User>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profile Saya',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildProfileSection(user),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 29),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 5),
                              _buildLogoutSection(context),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(User user) {
    return Column(
      children: [
        _buildEditableInfoBox(
          icon: Icons.person,
          label: user.name,
          field: 'name',
          onSave: (newValue) {
            _updateUserData('name', newValue);
          },
        ),
        SizedBox(height: 10),
        _buildEditableInfoBox(
          icon: Icons.email,
          label: user.email,
          field: 'email',
          onSave: (newValue) {
            _updateUserData('email', newValue);
          },
        ),
        SizedBox(height: 10),
        _buildEditableInfoBox(
          icon: Icons.location_on,
          label: user.address,
          field: 'address',
          onSave: (newValue) {
            _updateUserData('address', newValue);
          },
        ),
      ],
    );
  }

  Widget _buildEditableInfoBox({required IconData icon, required String label, required String field, required Function(String) onSave}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _showEditDialog(field, label, onSave);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String field, String currentValue, Function(String) onSave) {
    TextEditingController _controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushNamedAndRemoveUntil(context, '/login_screen', (Route<dynamic> route) => false);
      },
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Logout",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.45, size.width, size.height * 0.35);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class User {
  final String name;
  final String email;
  final String address;

  User({required this.name, required this.email, required this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      address: json['address'],
    );
  }
}
