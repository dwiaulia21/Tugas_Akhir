import 'package:awull_s_application3/widgets/app_bar/appbar_subtitle_two.dart';
import 'package:awull_s_application3/widgets/custom_text_form_field.dart';
import 'package:awull_s_application3/widgets/custom_checkbox_button.dart';
import 'package:awull_s_application3/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:awull_s_application3/core/app_export.dart';
import 'package:awull_s_application3/presentation/sign_up_success_dialog/sign_up_success_dialog.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatelessWidget {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Base URL of your PHP backend
  static const String baseUrl = 'http://10.0.167.213/cekginjal/register_api.php';

  // Method to send registration data to PHP backend
  Future<void> registerUser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'nama': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Registration Successful!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to login screen or any other screen as needed
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Registration Failed!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to server. Please try again later.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                registerUser(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}