// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _obscureText = true;

//   Future<void> onTapLogin(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.220.111/cekginjal/login_api.php'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': emailController.text,
//           'password': passwordController.text,
//         }),
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'success') {
//           if (data['role'] == 0) {
//             Navigator.pushReplacementNamed(context, '/admin');
//           } else if (data['role'] == 2) {
//             Navigator.pushReplacementNamed(context, '/pakar');
//           } else {
//             Navigator.pushReplacementNamed(context, '/home_container_screen');
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Login gagal: ${data['message']}')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Gagal terhubung: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Terjadi kesalahan: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text("Login"),
//         ),
//         body: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Form(
//               key: _formKey,
//               child: Container(
//                 width: double.maxFinite,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 39,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextFormField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your email",
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),
//                     TextFormField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         hintText: "Enter your password",
//                         prefixIcon: Icon(Icons.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscureText ? Icons.visibility : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscureText = !_obscureText;
//                             });
//                           },
//                         ),
//                       ),
//                       obscureText: _obscureText,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 28),
//                     ElevatedButton(
//                       onPressed: () {
//                         onTapLogin(context);
//                       },
//                       child: Text("Login"),
//                     ),
//                     SizedBox(height: 26),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Don't have an account?"),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, '/sign_up_screen');
//                           },
//                           child: Text("Sign Up"),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

// Future<void> onTapLogin(BuildContext context) async {
//   if (!_formKey.currentState!.validate()) {
//     return;
//   }

//   try {
//     final response = await http.post(
//       Uri.parse('http://192.168.235.111/cekginjal/login_api.php'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'email': emailController.text,
//         'password': passwordController.text,
//       }),
//     );

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         final prefs = await SharedPreferences.getInstance();
        
//         // Periksa apakah 'nama' ada dan tidak null
//         final userName = data['nama'] ?? 'User'; // Jika 'nama' null, gunakan 'User' sebagai default
//         await prefs.setString('token', data['token'] ?? '');
//         await prefs.setInt('id_user', int.tryParse(data['id_user']) ?? 0);
//         await prefs.setString('nama', userName);
//         print('token : ${data['token']}');

//         if (data['role'] == '0') {
//           Navigator.pushReplacementNamed(context, '/admin');
//         } else if (data['role'] == '2') {
//           Navigator.pushReplacementNamed(context, '/pakar');
//         } else {
//           Navigator.pushReplacementNamed(context, '/home_container_screen');
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login gagal: ${data['message']}')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal terhubung: ${response.statusCode}')),
//       );
//     }
//   } catch (e) {
//     print('Error: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Terjadi kesalahan: $e')),
//     );
//   }
// }
Future<void> onTapLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.235.111/cekginjal/login_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          final prefs = await SharedPreferences.getInstance();

          // Periksa apakah 'nama' ada dan tidak null
          final userName = data['nama'] ?? 'User'; // Jika 'nama' null, gunakan 'User' sebagai default
          await prefs.setString('token', data['token'] ?? '');
          await prefs.setInt('id_user', int.tryParse(data['id_user']) ?? 0);
          await prefs.setString('nama', userName);

          print('Token: ${data['token']}');
          print('ID User: ${data['id_user']}');
          print('Nama: $userName');
          
          if (data['role'] == '0') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (data['role'] == '2') {
            Navigator.pushReplacementNamed(context, '/pakar');
          } else {
            Navigator.pushReplacementNamed(context, '/home_container_screen');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal terhubung: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 39,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: () {
                        onTapLogin(context);
                      },
                      child: Text("Login"),
                    ),
                    SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_up_screen');
                          },
                          child: Text("Sign Up"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
